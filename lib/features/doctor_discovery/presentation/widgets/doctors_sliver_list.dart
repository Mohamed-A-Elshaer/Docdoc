import 'package:docdoc/core/widgets/custom_doctor_sliver_list.dart';
import 'package:flutter/material.dart';

import '../../data/models/doctor_discovery_query.dart';

class DoctorsSliverList extends StatelessWidget {
  const DoctorsSliverList({
    super.key,
    this.isRecommendedView = true,
    required this.query,
    this.onFilteredCountChanged,
  });

  final bool isRecommendedView;
  final DoctorDiscoveryQuery query;
  final ValueChanged<int>? onFilteredCountChanged;

  @override
  Widget build(BuildContext context) {
    return CustomDoctorSliverList(
      isRecommendedView: isRecommendedView,
      searchQuery: query.searchQuery,
      selectedSpeciality: query.filter.selectedSpeciality,
      selectedRating: query.filter.selectedRating,
      onFilteredCountChanged: onFilteredCountChanged,
    );
  }
}
