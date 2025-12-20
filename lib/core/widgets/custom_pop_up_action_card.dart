import 'package:docdoc/core/generated/app_text_styles.dart';
import 'package:docdoc/core/widgets/custom_button.dart';
import 'package:docdoc/core/widgets/custom_tab_button.dart';
import 'package:docdoc/features/speciality/presentation/views/widgets/doctor_speciality_view_body.dart';
import 'package:flutter/material.dart';
import '../helper_functions/responsive_dimesions.dart';

class CustomPopUpActionCard extends StatefulWidget{
   const CustomPopUpActionCard({
    super.key,
    required this.title,
    this.onDone,
  });
 final String title;
 final void Function(String? selectedSpeciality, String? selectedRating)? onDone;

  @override
  State<CustomPopUpActionCard> createState() => _CustomPopUpActionCardState();
}

class _CustomPopUpActionCardState extends State<CustomPopUpActionCard> {
  int _selectedIndex = 0;
  int _selectedRatingIndex = 0;
  
  static const List<String> _ratingTabs = ['All', '5', '4', '3', '2', '1'];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: ResponsiveDimensions.responsiveHeight(context,480),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30.53) ,
          topRight: Radius.circular(30.53),
        ),
      border: Border.all(
        width: 0.95,
        color: const Color(0xffF5F5F5),
      ),

      boxShadow: [
            BoxShadow(
                color: const Color(0xff000000).withOpacity(0.13),
                blurRadius: 19.08,
                offset: const Offset(0, -3.82),
                spreadRadius: 0,
            )
          ]

      ),

      child: Column(
        children: [
          const SizedBox(height: 55,),
          Center(
            child: Text(widget.title,style: TextStyles.semiBold18.copyWith(color: const Color(0xff242424)),),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Divider(
              height: 1,
              thickness: 1,
              color: Color(0xffEDEDED),
            ),
          ),
          const SizedBox(height: 33,),

          //put the boolean here
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 24),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text('Speciality',style: TextStyles.medium16.copyWith(color: const Color(0xff242424)),)),
                ),
                const SizedBox(height: 24,),
                SizedBox(
                  height: 51,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(left: 24),
                      itemCount: DoctorSpecialityViewBody.specialities.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(
                            right: index < DoctorSpecialityViewBody.specialities.length - 1 ? 12 : 0,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedIndex = index;
                              });
                            },
                            child: CustomTabButton(
                              containerHeight: 51,
                              containerWidth: 145,
                              buttonRadius: 34,
                              isActive: _selectedIndex == index,
                              isRatingTab: false,
                              tabTitle: DoctorSpecialityViewBody.specialities[index]['speciality'] as String,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                const SizedBox(height: 24,),
                Padding(
                  padding: const EdgeInsets.only(left: 24),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text('Rating',style: TextStyles.medium16.copyWith(color: const Color(0xff242424)),)
                  ),
                ),
                const SizedBox(height: 24,),
                SizedBox(
                  height: 41,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(left: 24),
                      itemCount: _ratingTabs.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(
                            right: index < _ratingTabs.length - 1 ? 12 : 0,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedRatingIndex = index;
                              });
                            },
                            child: CustomTabButton(
                              containerHeight: 41,
                              containerWidth: 84,
                              buttonRadius: 34,
                              isActive: _selectedRatingIndex == index,
                              isRatingTab: true,
                              tabTitle: _ratingTabs[index],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

              ],
            ),
          ),

          CustomButton(
              text: 'Done',
              onPressed: (){
                final selectedSpeciality = DoctorSpecialityViewBody.specialities[_selectedIndex]['speciality'] as String;
                final selectedRating = _selectedRatingIndex == 0 
                    ? null 
                    : _ratingTabs[_selectedRatingIndex];
                widget.onDone?.call(selectedSpeciality, selectedRating);
                Navigator.of(context).pop();
              }
          ),
        ],
      ),
    );
  }


}