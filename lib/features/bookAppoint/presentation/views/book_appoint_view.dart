import 'package:docdoc/core/helper_models/doctor_model.dart';
import 'package:docdoc/features/bookAppoint/domain/entities/booking_entity.dart';
import 'package:docdoc/features/bookAppoint/presentation/views/widgets/book_appoint_view_body.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class BookAppointView extends StatelessWidget{
  const BookAppointView({super.key, required this.doctorModel});

  static const routeName='BookAppoint';

  final DoctorModel doctorModel;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BookingEntity(),
      child: BookAppointViewBody(doctorModel: doctorModel,)
    );
  }


}