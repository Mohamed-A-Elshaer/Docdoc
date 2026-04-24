import 'package:docdoc/core/helper_functions/doctor_ratings_merger.dart';
import 'package:docdoc/core/helper_models/doctor_model.dart';
import 'package:docdoc/core/services/database_service.dart';
import 'package:docdoc/core/services/get_it_service.dart';
import 'package:docdoc/core/utils/app_colors.dart';
import 'package:docdoc/core/utils/assets.dart';
import 'package:docdoc/core/utils/backend_endpoint.dart';
import 'package:docdoc/core/widgets/custom_button.dart';
import 'package:docdoc/core/widgets/custom_doctor_info_model.dart';
import 'package:docdoc/core/widgets/custom_pop_up_action_card.dart';
import 'package:docdoc/features/aboutDoctor/presentation/views/widgets/about_doctor_page_view.dart';
import 'package:docdoc/features/bookAppoint/presentation/views/book_appoint_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/widgets/custom_app_bar.dart';

class AboutDoctorViewBody extends StatefulWidget{
  const AboutDoctorViewBody({super.key, this.doctorModel});

  final DoctorModel? doctorModel;

  @override
  State<AboutDoctorViewBody> createState() => _AboutDoctorViewBodyState();
}

class _AboutDoctorViewBodyState extends State<AboutDoctorViewBody> with SingleTickerProviderStateMixin {

  late PageController pageController;
  late TabController tabController;
  var currentPage=0;
  bool isSyncing = false;
  late DoctorModel _doctor;
  Map<String, dynamic>? _eligibleReviewAppointment;

  @override
  void initState() {
    super.initState();
    _doctor = widget.doctorModel!;
    DoctorRatingsMerger.mergeSingle(_doctor).then((merged) {
      if (mounted) setState(() => _doctor = merged);
    });
    _refreshEligibleReviewAppointment();
    pageController=PageController();
    tabController = TabController(length: 3, vsync: this);
    pageController.addListener((){
      currentPage=pageController.page!.round();
    });

    tabController.addListener(() {
      if (!tabController.indexIsChanging && !isSyncing) {
        isSyncing = true;
        pageController.animateToPage(
          tabController.index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        ).then((_) {
          isSyncing = false;
        });
      }
    });
  }

  Future<void> _refreshEligibleReviewAppointment() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      if (mounted) setState(() => _eligibleReviewAppointment = null);
      return;
    }

    final eligible = await getIt<DatabaseService>().getEligibleReviewAppointment(
      appointmentsPath: BackendEndpoint.addAppointmentData,
      ratingsPath: BackendEndpoint.ratings,
      userUid: user.id,
      doctorId: _doctor.id,
    );

    if (mounted) {
      setState(() => _eligibleReviewAppointment = eligible);
    }
  }

  Future<void> _handleReviewTabTap() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please sign in to submit a rating')),
      );
      return;
    }

    await _refreshEligibleReviewAppointment();
    final appointmentId = _eligibleReviewAppointment?['id'];
    final eligibleAppointmentId = appointmentId is int
        ? appointmentId
        : int.tryParse(appointmentId?.toString() ?? '');

    if (eligibleAppointmentId == null) {
      if (!mounted) return;
      /*ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'You can only leave one feedback after a finished appointment for this doctor.',
          ),
        ),
      );*/
      return;
    }

    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: const Color(0xff242424).withOpacity(0.3),
      isDismissible: true,
      isScrollControlled: true,
      builder: (context) => CustomPopUpActionCard(
        title: 'Give Rate',
        isReviewMode: true,
        onSubmitReview: (rating, review) async {
          if (rating < 1) return false;
          final messenger = ScaffoldMessenger.of(context);
          try {
            await getIt<DatabaseService>().submitDoctorRating(
              path: BackendEndpoint.ratings,
              doctorId: _doctor.id,
              userUid: user.id,
              appointmentId: eligibleAppointmentId,
              stars: rating,
              reviewText: review,
              displayedSeedRating:
                  RatingModel.generateFakeForDoctor(_doctor.id).rate,
              displayedSeedReviewCount:
                  RatingModel.generateFakeForDoctor(_doctor.id).count,
            );
            final updated = await DoctorRatingsMerger.mergeSingle(_doctor);
            await _refreshEligibleReviewAppointment();
            if (mounted) {
              setState(() => _doctor = updated);
              messenger.showSnackBar(
                const SnackBar(
                  content: Text('Thanks for your rating'),
                ),
              );
            }
            return true;
          } catch (e) {
            if (mounted) {
              messenger.showSnackBar(
                SnackBar(
                  content: Text('Could not save rating: $e'),
                ),
              );
            }
            return false;
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onTap: ()=>Navigator.of(context).pop(),
        title: _doctor.name,
        leftPadding: 0,),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
              Row(
                children: [
                  Expanded(
                    child: CustomDoctorInfoModel(
                        doctorModel: _doctor,
                        isRecommendedView: false,
                      height: 74,
                      width: 74,
                      isAboutDoctorView: true,
                      ),
                  ),
                  IconButton(
                      onPressed: (){},
                      icon: SvgPicture.asset(Assets.imagesMessageIcon,height: 24,width: 24,color: AppColors.primaryColor,)
                  ),
                ],
              ),
            const SizedBox(height: 24,),
            TabBar(
              controller: tabController,
              indicatorColor: AppColors.primaryColor,
              labelColor: AppColors.primaryColor,
              unselectedLabelColor: const Color(0xff9E9E9E),
              indicatorWeight: 3,
              onTap: (index) async {
                if (index == 2) {
                  await _handleReviewTabTap();
                }
              },
              tabs: const [
                Tab(text: 'About'),
                Tab(text: 'Location'),
                Tab(text: 'Reviews'),
              ],
            ),
            const SizedBox(height: 32,),
            Expanded(
              child: AboutDoctorPageView(
                pageController: pageController,
                onPageChanged: (index) {
                  if (!isSyncing && tabController.index != index) {
                    isSyncing = true;
                    tabController.animateTo(index);
                    Future.delayed(const Duration(milliseconds: 300), () {
                      isSyncing = false;
                    });
                  }
                }, doctorModel: _doctor,),
            ),
           // const SizedBox(height: 16,),
            CustomButton(
                text: 'Make An Appointment',
                onPressed: (){
                  Navigator.pushNamed(context, BookAppointView.routeName, arguments: _doctor);
                }
            ),
            const SizedBox(height: 16,),
          ],
        ),
      ),

    );
  }
}