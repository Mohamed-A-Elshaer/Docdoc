import '../../../core/helper_classes/api.dart';
import '../../constants.dart';
import '../helper_models/specialization_model.dart';

class ShowDoctorsSpecialization{
  Future<List<SpecializationModel>> showDoctorsSpecializations ({required int categoryId}) async{
    List<dynamic> data=await Api().get(url: 'https://vcare.integration25.com/api/specialization/show/$categoryId',
        token: token);
    List<SpecializationModel> specializationList=[];
      for(int i=0;i<data.length;i++) {
        specializationList.add(
            SpecializationModel.fromJson(data[i]));

      }
      return specializationList;
  }

}