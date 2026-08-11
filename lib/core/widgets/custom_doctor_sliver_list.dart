import 'dart:developer';

import 'package:docdoc/core/api_services/doctor_module.dart';
import 'package:docdoc/core/helper_models/doctor_model.dart';
import 'package:docdoc/features/aboutDoctor/presentation/views/about_doctor_view.dart';
import 'package:docdoc/features/doctor_discovery/domain/entities/doctor_filter_entity.dart';
import 'package:docdoc/features/doctor_discovery/domain/usecases/apply_doctor_filters_usecase.dart';
import 'package:flutter/material.dart';
import '../../../../../core/widgets/custom_doctor_info_model.dart';

class CustomDoctorSliverList extends StatelessWidget {
  final bool isRecommendedView;
  final String? searchQuery;
  final String? selectedSpeciality;
  final String? selectedRating;
  final ValueChanged<int>? onFilteredCountChanged;
  const CustomDoctorSliverList({
    super.key,
    this.isRecommendedView = false,
    this.searchQuery,
    this.selectedSpeciality,
    this.selectedRating,
    this.onFilteredCountChanged,
  });
  static final ApplyDoctorFiltersUsecase _applyDoctorFiltersUsecase =
      ApplyDoctorFiltersUsecase();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DoctorModel>>(
        future: DoctorModule().getAllDoctorsWithMergedRatings(),
        builder: (context, snapshot) {
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
            final filteredAndSortedDoctors = _applyDoctorFiltersUsecase(
              doctors: snapshot.data!,
              isRecommendedView: isRecommendedView,
              searchQuery: searchQuery ?? '',
              filter: DoctorFilterEntity(
                selectedSpeciality: selectedSpeciality,
                selectedRating: selectedRating,
              ),
            );
            if (onFilteredCountChanged != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                onFilteredCountChanged!(filteredAndSortedDoctors.length);
              });
            }

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
                      bottom:
                          index < filteredAndSortedDoctors.length - 1 ? 26 : 0,
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
        });
  }
}
