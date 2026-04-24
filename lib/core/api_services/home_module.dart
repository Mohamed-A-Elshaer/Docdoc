import 'package:docdoc/core/helper_classes/api.dart';
import 'package:docdoc/core/helper_functions/doctor_ratings_merger.dart';
import 'package:docdoc/core/helper_models/environment.dart';
import 'package:docdoc/core/helper_models/home_specialty_model.dart';

class HomeModule {
  Future<List<HomeSpecialtyModel>> getHomePage() async {
    final response = await Api().get(
      url: '${Environment.apiBaseUrl}home/index',
      token: null, // Api class will automatically use stored token from SharedPreferences
    );
    final List data = response['data'];
    return data
        .map((json) => HomeSpecialtyModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<List<HomeSpecialtyModel>> getHomePageWithMergedRatings() async {
    final specialties = await getHomePage();
    return DoctorRatingsMerger.mergeIntoHome(specialties);
  }
}
