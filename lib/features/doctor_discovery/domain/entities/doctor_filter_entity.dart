class DoctorFilterEntity {
  const DoctorFilterEntity({
    this.selectedSpeciality,
    this.selectedRating,
  });

  final String? selectedSpeciality;
  final String? selectedRating;

  bool get hasSpeciality =>
      selectedSpeciality != null && selectedSpeciality!.trim().isNotEmpty;

  bool get hasRating =>
      selectedRating != null &&
      selectedRating!.trim().isNotEmpty &&
      selectedRating != 'All';

  bool get hasActiveFilters => hasSpeciality || hasRating;

  DoctorFilterEntity copyWith({
    String? selectedSpeciality,
    String? selectedRating,
  }) {
    return DoctorFilterEntity(
      selectedSpeciality: selectedSpeciality ?? this.selectedSpeciality,
      selectedRating: selectedRating ?? this.selectedRating,
    );
  }
}
