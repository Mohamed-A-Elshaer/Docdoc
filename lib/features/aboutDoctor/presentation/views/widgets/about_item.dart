import 'package:docdoc/core/generated/app_text_styles.dart';
import 'package:docdoc/core/helper_models/doctor_model.dart';
import 'package:flutter/cupertino.dart';

class AboutItem extends StatelessWidget{
  const AboutItem({super.key, required this.doctorModel});
  final DoctorModel doctorModel;

  String _formatTime(String time) {
    // Remove seconds (":00") and replace ":" with "."
    return time.replaceAll(':00', '').replaceAll(':', '.');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
Text('About me',style: TextStyles.semiBold16.copyWith(color: const Color(0xff242424)),),
const SizedBox(height: 12,),
Text('I am a dedicated medical professional committed to providing high-quality, patient-centered care. With a strong focus on accurate diagnosis, effective treatment, and preventive healthcare, I strive to support my patients\' well-being through clear communication and compassionate service. My goal is to help patients make informed decisions and achieve the best possible health outcomes. ${doctorModel.description}',
  style: TextStyles.regular14.copyWith(color: const Color(0xff757575)),),
          const SizedBox(height: 24,),
Text('Working Time',style: TextStyles.semiBold16.copyWith(color: const Color(0xff242424)),),
const SizedBox(height: 12,),
Text('Monday - Friday, ${_formatTime(doctorModel.startTime)}-${_formatTime(doctorModel.endTime)}',style: TextStyles.regular14.copyWith(color: const Color(0xff757575)),),
          const SizedBox(height: 24,),
Text('STR',style: TextStyles.semiBold16.copyWith(color: const Color(0xff242424)),),
const SizedBox(height: 12,),
Text('4726482464',style: TextStyles.regular14.copyWith(color: const Color(0xff757575)),),
          const SizedBox(height: 24,),
Text('Practical Experience',style: TextStyles.semiBold16.copyWith(color: const Color(0xff242424)),),


        ],
      ),
    );
  }


}