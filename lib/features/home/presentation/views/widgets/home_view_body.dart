import 'package:docdoc/core/generated/app_colors.dart';
import 'package:docdoc/core/generated/app_text_styles.dart';
import 'package:docdoc/core/generated/assets.dart';
import 'package:docdoc/features/home/presentation/views/widgets/custom_bottom_navigation_bar.dart';
import 'package:docdoc/core/widgets/custom_speciality_icon.dart';
import 'package:docdoc/features/home/presentation/views/widgets/custom_home_app_bar.dart';
import 'package:docdoc/features/home/presentation/views/widgets/see_all_bar.dart';
import 'package:docdoc/features/recommended_doctors/presentation/views/recommended_doctors_view.dart';
import 'package:docdoc/features/speciality/presentation/views/doctor_speciality_view.dart';
import 'package:flutter/material.dart';
import '../../../../../core/widgets/custom_doctor_sliver_list.dart';
import '../../../../../core/widgets/top_page_icon.dart';

class HomeViewBody extends StatefulWidget{
   HomeViewBody({super.key});
  final ScrollController controller = ScrollController();

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {

  @override
  Widget build(BuildContext context) {
   return SafeArea(
     child: Scaffold(
       bottomNavigationBar: const CustomBottomNavigationBar(),
         floatingActionButton: TopPageIcon(
           scrollController: widget.controller,
         ),
       body: Padding(
         padding: const EdgeInsets.symmetric(horizontal: 16),
         child: CustomScrollView(
           controller: widget.controller,
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
                   SliverToBoxAdapter(
                     child: SeeAllBar(
                         text: 'Doctor Speciality',
                         onTap: (){
                           Navigator.pushNamed(context, DoctorSpecialityView.routeName);
                         },
                     ),
                   ),
                   const SliverToBoxAdapter(
                     child: SizedBox(height: 16,),
                   ),
                   SliverToBoxAdapter(
                     child: SizedBox(
                       height: 120,
                       child: ListView(
                         scrollDirection: Axis.horizontal,
                         children:  [
                           GestureDetector(
                             onTap: () {
                               Navigator.pushNamed(
                                 context,
                                 RecommendedDoctorsView.routeName,
                                 arguments: 'Cardiology',
                               );
                             },
                             child: CustomSpecialityIcon(imageName: Assets.imagesCardiology, speciality: 'Cardiology',radius: 30,imageSize: 27,
                               textStyle: TextStyles.regular12.copyWith(color: const Color(0xff242424)),),
                           ),
                           const SizedBox(width: 26,),
                           GestureDetector(
                             onTap: () {
                               Navigator.pushNamed(
                                 context,
                                 RecommendedDoctorsView.routeName,
                                 arguments: 'Dermatology',
                               );
                             },
                             child: CustomSpecialityIcon(imageName: Assets.imagesDermatology, speciality: 'Dermatology',radius: 30,imageSize: 27,
                               textStyle: TextStyles.regular12.copyWith(color: const Color(0xff242424)),),
                           ),
                           const SizedBox(width: 26,),
                           GestureDetector(
                             onTap: () {
                               Navigator.pushNamed(
                                 context,
                                 RecommendedDoctorsView.routeName,
                                 arguments: 'Neurology',
                               );
                             },
                             child: CustomSpecialityIcon(imageName: Assets.imagesBrain, speciality: 'Neurology',radius: 30,imageSize: 27,
                               textStyle: TextStyles.regular12.copyWith(color: const Color(0xff242424)),),
                           ),
                           const SizedBox(width: 26,),
                           GestureDetector(
                             onTap: () {
                               Navigator.pushNamed(
                                 context,
                                 RecommendedDoctorsView.routeName,
                                 arguments: 'Orthopedics',
                               );
                             },
                             child: CustomSpecialityIcon(imageName: Assets.imagesOrthopedics, speciality: 'Orthopedics',radius: 30,imageSize: 27,
                               textStyle: TextStyles.regular12.copyWith(color: const Color(0xff242424)),),
                           ),
                         ],
                       ),
                     ),
                   ),
                   const SliverToBoxAdapter(
                     child: SizedBox(height: 23,),
                   ),
                  SliverToBoxAdapter(
                    child: SeeAllBar(
                        text: 'Recommended Doctors',
                        onTap: (){
                        Navigator.pushNamed(context, RecommendedDoctorsView.routeName);
                      },
                    ),
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