import 'package:docdoc/core/helper_classes/api.dart';
import 'package:docdoc/core/helper_models/environment.dart';
import '../helper_models/appointment_model.dart';

class AppointmentModule{
Future<Map<String, dynamic>> storeAppoint({required int docId,required String start_time,String? notes}) async{
Map<String,dynamic> response= await Api().post(
    url: '${Environment.apiBaseUrl}appointment/store', body: {
  'doctor_id':docId.toString(),
  'start_time':start_time,
  'notes':notes ?? '',
},
   token: null, // Api class will automatically use stored token from SharedPreferences
);

return response;
}


Future<List<AppointmentModel>> getAppoint() async{
  final response = await Api().get(
    url: '${Environment.apiBaseUrl}appointment/index',
    token: null, // Api class will automatically use stored token from SharedPreferences
  );
  final List appointsJson = response['data'];

  return appointsJson
      .map((json) => AppointmentModel.fromJson(json))
      .toList();

}

}