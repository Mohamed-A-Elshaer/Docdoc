import 'package:docdoc/features/doctor_discovery/domain/entities/doctor_filter_entity.dart';

class DoctorDiscoveryQuery {
  const DoctorDiscoveryQuery({
    this.searchQuery = '',
    this.filter = const DoctorFilterEntity(),
  });

  final String searchQuery;
  final DoctorFilterEntity filter;

  bool get hasSearchQuery => searchQuery.trim().isNotEmpty;

  bool get hasFilters => filter.hasActiveFilters;

  DoctorDiscoveryQuery copyWith({
    String? searchQuery,
    DoctorFilterEntity? filter,
  }) {
    return DoctorDiscoveryQuery(
      searchQuery: searchQuery ?? this.searchQuery,
      filter: filter ?? this.filter,
    );
  }
}
