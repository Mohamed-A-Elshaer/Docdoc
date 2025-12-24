import 'package:docdoc/core/generated/app_colors.dart';
import 'package:docdoc/core/generated/assets.dart';
import 'package:docdoc/core/helper_models/doctor_model.dart';
import 'package:docdoc/core/widgets/custom_button.dart';
import 'package:docdoc/core/widgets/custom_doctor_info_model.dart';
import 'package:docdoc/features/aboutDoctor/presentation/views/widgets/about_doctor_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

  @override
  void initState() {
    super.initState();
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
        title: widget.doctorModel!.name,
        leftPadding: 0,),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
              Row(
                children: [
                  Expanded(
                    child: CustomDoctorInfoModel(
                        doctorModel: widget.doctorModel!,
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
                }, doctorModel: widget.doctorModel!,),
            ),
           // const SizedBox(height: 16,),
            CustomButton(
                text: 'Make An Appointment',
                onPressed: (){}
            ),
            const SizedBox(height: 16,),
          ],
        ),
      ),

    );
  }
}