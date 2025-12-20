import 'dart:developer';

import 'package:docdoc/core/generated/assets.dart';
import 'package:docdoc/core/widgets/custom_app_bar.dart';
import 'package:docdoc/core/widgets/custom_search_field.dart';
import 'package:docdoc/core/widgets/top_page_icon.dart';
import 'package:docdoc/core/widgets/custom_pop_up_action_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/widgets/custom_doctor_sliver_list.dart';

class RecommendedDoctorsViewBody extends StatefulWidget{
   const RecommendedDoctorsViewBody({super.key, this.initialSpeciality});

  final String? initialSpeciality;

  @override
  State<RecommendedDoctorsViewBody> createState() => _RecommendedDoctorsViewBodyState();
}

class _RecommendedDoctorsViewBodyState extends State<RecommendedDoctorsViewBody> {
  final ScrollController controller = ScrollController();
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  String? selectedSpeciality;
  String? selectedRating;

  @override
  void initState() {
    super.initState();
    // Initialize selectedSpeciality from the initialSpeciality parameter
    selectedSpeciality = widget.initialSpeciality;
    log('RecommendedDoctorsViewBody initialized with speciality: $selectedSpeciality');
  }

  @override
  void dispose() {
    searchController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: CustomAppBar(
       onTap: ()=>Navigator.of(context).pop(),
       title: 'Recommended Doctors',
       leftPadding: 0,),
     floatingActionButton: TopPageIcon(scrollController: controller),
     body: CustomScrollView(
       controller: controller,
       slivers: [
         SliverToBoxAdapter(
           child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18,vertical: 20),
             child: Row(
               children: [
               Expanded(
                 child: CustomSearchField(
                   hintText: 'Search',
                   controller: searchController,
                   onChanged: (value) {
                     setState(() {
                       searchQuery = value;
                     });
                   },
                   prefixIcon: SvgPicture.asset(
                     Assets.imagesSearchIcon,
                     height: 24,
                     width: 24,
                     color: const Color(0xffC2C2C2,),
                   fit: BoxFit.scaleDown,),
                 ),
               ),
                 if (widget.initialSpeciality == null) ...[
                   const SizedBox(width: 12,),
                   IconButton(
                       onPressed: (){
                         showModalBottomSheet(
                           context: context,
                           backgroundColor: Colors.transparent,
                           barrierColor: const Color(0xff242424).withOpacity(0.3),
                           isDismissible: true,
                           isScrollControlled: true,
                           builder: (context) => CustomPopUpActionCard(
                             title: 'Sort',
                             onDone: (speciality, rating) {
                               setState(() {
                                 selectedSpeciality = speciality;
                                 selectedRating = rating;
                               });
                             },
                           ),
                         );
                       },
                       icon:SvgPicture.asset(Assets.imagesSortIcon,height: 24,width: 24,)),
                 ],
               ],
             ),
           ),
         ),
         const SliverToBoxAdapter(
           child: SizedBox(height: 24,),
         ),

         CustomDoctorSliverList(
           isRecommendedView: true,
           searchQuery: searchQuery,
           selectedSpeciality: selectedSpeciality,
           selectedRating: selectedRating,
         ),

       ],
     )
   );
  }


}