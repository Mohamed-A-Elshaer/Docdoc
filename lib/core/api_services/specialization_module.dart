import 'package:docdoc/core/helper_models/environment.dart';
import '../../../core/helper_classes/api.dart';
import '../helper_models/specialization_model.dart';

class SpecializationModule {
  Future<List<SpecializationModel>> getAllSpecializations() async {
    List<dynamic> data = await Api().get(
      url: '${Environment.apiBaseUrl}specialization/index',
      token:
          null, // Api class will automatically use stored token from SharedPreferences
    );
    List<SpecializationModel> specializationList = [];
    for (int i = 0; i < data.length; i++) {
      specializationList.add(SpecializationModel.fromJson(data[i]));
    }
    return specializationList;
  }

  Future<List<SpecializationModel>> showDoctorsSpecializations(
      {required int categoryId}) async {
    List<dynamic> data = await Api().get(
      url: '${Environment.apiBaseUrl}specialization/show/$categoryId',
      token:
          null, // Api class will automatically use stored token from SharedPreferences
    );
    List<SpecializationModel> specializationList = [];
    for (int i = 0; i < data.length; i++) {
      specializationList.add(SpecializationModel.fromJson(data[i]));
    }
    return specializationList;
  }
}
