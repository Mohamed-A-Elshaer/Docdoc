import 'package:docdoc/core/helper_classes/api.dart';
import 'package:docdoc/core/helper_models/appointment_model.dart';
import 'package:docdoc/core/helper_models/environment.dart';

class UserModule{
  Future<Patient> userProfile() async{
       Map<String,dynamic> apiResponse= await Api().get(
          url: '${Environment.apiBaseUrl}user/profile',
          token: null, // Api class will automatically use stored token from SharedPreferences
       );
       print('Body:  $apiResponse');
       
       // Extract the first element from the data array
       if (apiResponse.containsKey('data') && apiResponse['data'] is List) {
         final dataList = apiResponse['data'] as List;
         if (dataList.isNotEmpty && dataList[0] is Map) {
           return Patient.fromJson(dataList[0] as Map<String, dynamic>);
         }
       }
       
       // Fallback: try to parse the response directly (for backward compatibility)
       return Patient.fromJson(apiResponse);
  }

}