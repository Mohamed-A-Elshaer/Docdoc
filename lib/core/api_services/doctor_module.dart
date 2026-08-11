import 'package:docdoc/core/helper_functions/doctor_ratings_merger.dart';
import 'package:docdoc/core/helper_models/environment.dart';
import '../../../core/helper_classes/api.dart';
import '../helper_models/doctor_model.dart';

class DoctorModule {
  Future<List<DoctorModel>> getAllDoctors() async {
    final response = await Api().get(
      url: '${Environment.apiBaseUrl}doctor/index',
      token:
          null, // Api class will automatically use stored token from SharedPreferences
    );
    final List doctorsJson = response['data'];

    return doctorsJson.map((json) => DoctorModel.fromJson(json)).toList();
  }

  /// Same as [getAllDoctors] but replaces rating/count with Supabase aggregates when present.
  Future<List<DoctorModel>> getAllDoctorsWithMergedRatings() async {
    final doctors = await getAllDoctors();
    return DoctorRatingsMerger.mergeIntoDoctors(doctors);
  }
}
