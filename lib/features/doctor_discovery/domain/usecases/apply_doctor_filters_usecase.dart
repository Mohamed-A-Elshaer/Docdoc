import 'package:docdoc/core/helper_models/doctor_model.dart';
import 'package:docdoc/features/doctor_discovery/domain/entities/doctor_filter_entity.dart';

class ApplyDoctorFiltersUsecase {
  List<DoctorModel> call({
    required List<DoctorModel> doctors,
    required bool isRecommendedView,
    String searchQuery = '',
    DoctorFilterEntity filter = const DoctorFilterEntity(),
  }) {
    final normalizedQuery = searchQuery.toLowerCase().trim();
    final selectedSpeciality = filter.selectedSpeciality?.toLowerCase().trim();
    final selectedRating = filter.selectedRating;

    final filteredDoctors = doctors.where((doctor) {
      final doctorRate = doctor.ratingModel.rate;

      final matchesBaseRating = isRecommendedView
          ? doctorRate >= 1.0 && doctorRate <= 5.0
          : doctorRate >= 4.0 && doctorRate <= 5.0;

      var matchesSpeciality = true;
      if (selectedSpeciality != null && selectedSpeciality.isNotEmpty) {
        matchesSpeciality =
            doctor.specialization.name.toLowerCase() == selectedSpeciality;
      }

      var matchesRatingFilter = true;
      if (selectedRating != null &&
          selectedRating.isNotEmpty &&
          selectedRating != 'All') {
        final ratingValue = double.tryParse(selectedRating);
        if (ratingValue != null) {
          matchesRatingFilter =
              doctorRate >= ratingValue && doctorRate < ratingValue + 1;
        }
      }

      var matchesSearch = true;
      if (normalizedQuery.isNotEmpty) {
        final nameMatch = doctor.name.toLowerCase().contains(normalizedQuery);
        final specialityMatch =
            doctor.specialization.name.toLowerCase().contains(normalizedQuery);
        final degreeMatch = doctor.degree.toLowerCase().contains(normalizedQuery);
        matchesSearch = nameMatch || specialityMatch || degreeMatch;
      }

      return matchesBaseRating &&
          matchesSpeciality &&
          matchesRatingFilter &&
          matchesSearch;
    }).toList()
      ..sort((a, b) => b.ratingModel.rate.compareTo(a.ratingModel.rate));

    return filteredDoctors;
  }
}
