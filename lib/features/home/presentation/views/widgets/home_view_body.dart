import 'package:docdoc/core/generated/app_colors.dart';
import 'package:docdoc/core/generated/app_text_styles.dart';
import 'package:docdoc/core/generated/assets.dart';
import 'package:docdoc/features/home/presentation/views/widgets/custom_bottom_navigation_bar.dart';
import 'package:docdoc/features/home/presentation/views/widgets/custom_doctor_info_model.dart';
import 'package:docdoc/features/home/presentation/views/widgets/custom_doctor_sliver_list.dart';
import 'package:docdoc/features/home/presentation/views/widgets/custom_speciality_icon.dart';
import 'package:docdoc/features/home/presentation/views/widgets/custom_home_app_bar.dart';
import 'package:docdoc/features/home/presentation/views/widgets/see_all_bar.dart';
import 'package:flutter/material.dart';

class HomeViewBody extends StatelessWidget{
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
   return SafeArea(
     child: Scaffold(
       bottomNavigationBar: const CustomBottomNavigationBar(),
       body: Padding(
         padding: const EdgeInsets.symmetric(horizontal: 16),
         child: CustomScrollView(
               slivers: [
                 const SliverToBoxAdapter(
                   child: CustomHomeAppBar(),
                 ),
                 const SliverToBoxAdapter(
                   child: SizedBox(height: 17,),
                 ),
                 SliverToBoxAdapter(
                     child: SizedBox(
                       width: 343,
                       height: 167,
                       child: Stack(
                         clipBehavior: Clip.none,
                         children:[
                           Container(
                           decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(24),
                             color: AppColors.primaryColor
                           ),
                         ),
                           Transform.translate(

                               offset: Offset(MediaQuery.of(context).size.width * 0.03, 0),
                               child: Image.asset(Assets.imagesHomePageBlueContainerPattern,width:594.09,height: 832.57,)),

                           Positioned(
                               top: -30,
                               right: 0,
                               child: Image.asset(
                                 Assets.imagesNurse,
                                 height: 197,
                                 width: 136,
                                 //fit: BoxFit.contain,
                                   )),
                             Padding(
                               padding: const EdgeInsets.symmetric(horizontal: 18,vertical: 12),
                               child: Column(
                                 children: [
                                   Text('Book and \nschedule with \nnearest doctor',style: TextStyles.medium18.copyWith(color: Colors.white),),
                                  const SizedBox(height: 15,),
                                   ElevatedButton(
                                     style: ElevatedButton.styleFrom(
                                       backgroundColor: Colors.white,
                                       shape: RoundedRectangleBorder(
                                         borderRadius: BorderRadius.circular(48)
                                       )
                                     ),
                                       onPressed: (){},
                                       child:Text('Find Nearby',style: TextStyles.regular12.copyWith(color: AppColors.primaryColor),) )
                                 ],
                               ),



                 ),
                    ]
                     ),
                   ),
                 ),
                 const SliverToBoxAdapter(
                   child: SizedBox(height: 24,),
                 ),
                 const SliverToBoxAdapter(
                   child: SeeAllBar(text: 'Doctor Speciality'),
                 ),
                 const SliverToBoxAdapter(
                   child: SizedBox(height: 16,),
                 ),
                 SliverToBoxAdapter(
                   child: SizedBox(
                     height: 120,
                     child: ListView(
                       scrollDirection: Axis.horizontal,
                       children: const [
                         CustomSpecialityIcon(imageName: Assets.imagesDoctorVector, speciality: 'General',),
                         SizedBox(width: 36,),
                         CustomSpecialityIcon(imageName: Assets.imagesBrain, speciality: 'Neurologic',),
                         SizedBox(width: 36,),
                         CustomSpecialityIcon(imageName: Assets.imagesBaby, speciality: 'Pediatric',),
                         SizedBox(width: 36,),
                         CustomSpecialityIcon(imageName: Assets.imagesKidneys, speciality: 'Radiology',),
                       ],
                     ),
                   ),
                 ),
                 const SliverToBoxAdapter(
                   child: SizedBox(height: 23,),
                 ),
                const SliverToBoxAdapter(
                  child: SeeAllBar(text: 'Recommendation Doctor'),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 16,),
                ),
                const CustomDoctorSliverList(),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 24,),
                ),
              ],
            ),
       )
     ),
   );
  }

}