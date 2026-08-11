import 'dart:developer';
import 'package:docdoc/core/widgets/custom_app_bar.dart';
import 'package:docdoc/features/doctor_discovery/domain/entities/doctor_filter_entity.dart';
import 'package:docdoc/core/widgets/top_page_icon.dart';
import 'package:docdoc/features/doctor_discovery/presentation/widgets/doctor_filter_button.dart';
import 'package:docdoc/features/doctor_discovery/presentation/widgets/doctor_search_bar.dart';
import 'package:docdoc/features/doctor_discovery/presentation/widgets/doctors_sliver_list.dart';
import 'package:flutter/material.dart';

import '../../../../doctor_discovery/data/models/doctor_discovery_query.dart';

class RecommendedDoctorsViewBody extends StatefulWidget {
  const RecommendedDoctorsViewBody({super.key, this.initialSpeciality});

  final String? initialSpeciality;

  @override
  State<RecommendedDoctorsViewBody> createState() =>
      _RecommendedDoctorsViewBodyState();
}

class _RecommendedDoctorsViewBodyState
    extends State<RecommendedDoctorsViewBody> {
  final ScrollController controller = ScrollController();
  final TextEditingController searchController = TextEditingController();
  DoctorDiscoveryQuery query = const DoctorDiscoveryQuery();

  @override
  void initState() {
    super.initState();
    query = query.copyWith(
      filter: DoctorFilterEntity(selectedSpeciality: widget.initialSpeciality),
    );
    log(
      'RecommendedDoctorsViewBody initialized with speciality: '
      '${query.filter.selectedSpeciality}',
    );
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
          onTap: () => Navigator.of(context).pop(),
          title: 'Recommended Doctors',
          leftPadding: 0,
        ),
        floatingActionButton: TopPageIcon(scrollController: controller),
        body: CustomScrollView(
          controller: controller,
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: DoctorSearchBar(
                        controller: searchController,
                        onChanged: (value) {
                          setState(() {
                            query = query.copyWith(searchQuery: value);
                          });
                        },
                      ),
                    ),
                    if (widget.initialSpeciality == null) ...[
                      const SizedBox(
                        width: 12,
                      ),
                      DoctorFilterButton(
                        onDone: (speciality, rating) {
                          setState(() {
                            query = query.copyWith(
                              filter: DoctorFilterEntity(
                                selectedSpeciality: speciality,
                                selectedRating: rating,
                              ),
                            );
                          });
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 24,
              ),
            ),
            DoctorsSliverList(
              isRecommendedView: true,
              query: query,
            ),
          ],
        ));
  }
}
