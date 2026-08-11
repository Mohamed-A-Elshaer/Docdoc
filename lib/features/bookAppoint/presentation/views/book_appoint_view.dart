import 'package:docdoc/core/helper_models/doctor_model.dart';
import 'package:docdoc/features/bookAppoint/domain/entities/booking_entity.dart';
import 'package:docdoc/features/bookAppoint/presentation/views/widgets/book_appoint_view_body.dart';
import 'package:docdoc/features/checkout/data/repos/checkout_repo_impl.dart';
import 'package:docdoc/features/checkout/presentation/cubits/paypal_payment_cubit.dart';
import 'package:docdoc/features/checkout/presentation/cubits/stripe_payment_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class BookAppointView extends StatelessWidget {
  const BookAppointView({super.key, required this.doctorModel});

  static const routeName = 'BookAppoint';

  final DoctorModel doctorModel;
  @override
  Widget build(BuildContext context) {
    final checkoutRepo = CheckoutRepoImpl();

    return ChangeNotifierProvider(
      create: (_) => BookingEntity(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => StripePaymentCubit(checkoutRepo),
          ),
          BlocProvider(
            create: (context) => PayPalPaymentCubit(checkoutRepo),
          ),
        ],
        child: BookAppointViewBody(
          doctorModel: doctorModel,
        ),
      ),
    );
  }
}
