import '../../../core/helper_classes/api.dart';
import '../../constants.dart';
import '../helper_models/doctor_model.dart';

class GetAllDoctorsService{

Future<List<DoctorModel>> getAllDoctors() async{
  final response = await Api().get(
    url: 'https://vcare.integration25.com/api/doctor/index',
    token: token);
  final List doctorsJson = response['data'];

  return doctorsJson
      .map((json) => DoctorModel.fromJson(json))
      .toList();
}

}