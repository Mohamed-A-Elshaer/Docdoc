import 'dart:developer';

import 'package:docdoc/core/api_services/home_module.dart';
import 'package:docdoc/core/helper_models/doctor_model.dart';
import 'package:docdoc/core/helper_models/home_specialty_model.dart';
import 'package:docdoc/core/widgets/custom_doctor_info_model.dart';
import 'package:docdoc/features/aboutDoctor/presentation/views/about_doctor_view.dart';
import 'package:flutter/material.dart';

/// Displays home page doctors in a flat list (no specialty headers), sorted by rating descending.
class HomeDoctorSliverList extends StatelessWidget {
  const HomeDoctorSliverList({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<HomeSpecialtyModel>>(
      future: HomeModule().getHomePageWithMergedRatings(),
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
          final specialties = snapshot.data!;
          final List<DoctorModel> allDoctors = [];
          for (final s in specialties) {
            allDoctors.addAll(s.doctors);
          }
          allDoctors.sort((a, b) => b.ratingModel.rate.compareTo(a.ratingModel.rate));

          if (allDoctors.isEmpty) {
            return const SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: Text('No doctors found'),
                ),
              ),
            );
          }

          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final doctor = allDoctors[index];
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index < allDoctors.length - 1 ? 26 : 0,
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
                      isRecommendedView: true,
                    ),
                  ),
                );
              },
              childCount: allDoctors.length,
            ),
          );
        }

        return const SliverToBoxAdapter(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0),
              child: Text('No doctors found'),
            ),
          ),
        );
      },
    );
  }
}
