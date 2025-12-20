import 'package:docdoc/core/helper_classes/api.dart';
import '../../constants.dart';
import '../helper_models/appointment_model.dart';

class StoreAppointment{
Future<AppointmentModel> storeAppoint({required String docId,required String start_time,String? notes}) async{
Map<String,dynamic> data= await Api().post(url: 'https://vcare.integration25.com/api/appointment/store', body: {
  'doctor_id':docId,
  'start_time':start_time,
  'notes':notes,
},
    token: token);

return AppointmentModel.fromJson(data);
}
}