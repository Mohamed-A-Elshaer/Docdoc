import 'dart:developer';

import 'package:docdoc/core/api_services/get_all_doctor_service.dart';
import 'package:docdoc/core/helper_models/doctor_model.dart';
import 'package:docdoc/features/aboutDoctor/presentation/views/about_doctor_view.dart';
import 'package:flutter/material.dart';
import '../../../../../core/widgets/custom_doctor_info_model.dart';

class CustomDoctorSliverList extends StatelessWidget{
  final bool isRecommendedView;
  final String? searchQuery;
  final String? selectedSpeciality;
  final String? selectedRating;
  const CustomDoctorSliverList({
    super.key,
    this.isRecommendedView=false, 
    this.searchQuery,
    this.selectedSpeciality,
    this.selectedRating,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DoctorModel>>(
        future: GetAllDoctorsService().getAllDoctors(),
        builder: (context,snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }

          if (snapshot.hasError) {
            log('${snapshot.error}');
            return SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Text(
                    'Failed to load doctors',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            );
          }

          if (snapshot.hasData) {
            List<DoctorModel> filteredAndSortedDoctors = snapshot.data!
                .where((doctor) {
                  // Base rating filter
                  bool ratingMatch = isRecommendedView?
                      doctor.ratingModel.rate >= 1.0 &&
                      doctor.ratingModel.rate <= 5.0
                      : doctor.ratingModel.rate >= 4.0 &&
                       doctor.ratingModel.rate <= 5.0;
                  
                  // Speciality filter
                  bool specialityMatch = true;
                  if (selectedSpeciality != null && selectedSpeciality!.isNotEmpty) {
                    specialityMatch = doctor.specialization.name.toLowerCase() == 
                        selectedSpeciality!.toLowerCase();
                  }
                  
                  // Rating filter from popup
                  bool ratingFilterMatch = true;
                  if (selectedRating != null && selectedRating!.isNotEmpty && selectedRating != 'All') {
                    final ratingValue = double.tryParse(selectedRating!);
                    if (ratingValue != null) {
                      ratingFilterMatch = doctor.ratingModel.rate >= ratingValue && 
                                         doctor.ratingModel.rate < ratingValue + 1;
                    }
                  }
                  
                  // Search query filter
                  bool searchMatch = true;
                  if (searchQuery != null && searchQuery!.isNotEmpty) {
                    final query = searchQuery!.toLowerCase().trim();
                    final nameMatch = doctor.name.toLowerCase().contains(query);
                    final specialityMatch = doctor.specialization.name.toLowerCase().contains(query);
                    final degreeMatch = doctor.degree.toLowerCase().contains(query);
                    searchMatch = nameMatch || specialityMatch || degreeMatch;
                  }
                  
                  return ratingMatch && specialityMatch && ratingFilterMatch && searchMatch;
                })
                .toList()
              ..sort((a, b) => b.ratingModel.rate.compareTo(a.ratingModel.rate));
            
            if (filteredAndSortedDoctors.isEmpty) {
              return SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: Text(
                      'No doctors found',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
              );
            }
            
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final doctor = filteredAndSortedDoctors[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index < filteredAndSortedDoctors.length - 1 ? 26 : 0,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AboutDoctorView.routeName,
                          arguments: doctor,
                        );
                      },
                      child: CustomDoctorInfoModel(
                        doctorModel: doctor,
                        isRecommendedView: isRecommendedView,
                      ),
                    ),
                  );
                },
                childCount: filteredAndSortedDoctors.length,
              ),
            );
          }

          return SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Text(
                  'No doctors found',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          );
        }
    );
  }

}