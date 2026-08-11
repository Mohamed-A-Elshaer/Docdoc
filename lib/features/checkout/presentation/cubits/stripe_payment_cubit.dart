import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:docdoc/features/checkout/data/models/payment_intent_input_model.dart';
import 'package:docdoc/features/checkout/domain/repos/checkout_repo.dart';
import 'package:meta/meta.dart';

part 'stripe_payment_state.dart';

class StripePaymentCubit extends Cubit<StripePaymentState> {
  StripePaymentCubit(this.checkoutRepo) : super(StripePaymentInitial());
  final CheckoutRepo checkoutRepo;

  Future makePayment({
    required PaymentIntentInputModel paymentIntentInputModel,
  }) async {
    emit(StripePaymentLoading());
    var data = await checkoutRepo.makePayment(
      paymentIntentInputModel: paymentIntentInputModel,
    );
    data.fold(
      (l) => emit(StripePaymentFailure(l.message)),
      (r) => emit(StripePaymentSuccess()),
    );
  }

  Future<bool> makePaymentAsync({
    required PaymentIntentInputModel paymentIntentInputModel,
  }) async {
    emit(StripePaymentLoading());
    final data = await checkoutRepo.makePayment(
      paymentIntentInputModel: paymentIntentInputModel,
    );
    return data.fold(
      (failure) {
        emit(StripePaymentFailure(failure.message));
        return false;
      },
      (_) {
        emit(StripePaymentSuccess());
        return true;
      },
    );
  }

  @override
  void onChange(Change<StripePaymentState> change) {
    if (change.nextState is StripePaymentFailure) {
      final failure = change.nextState as StripePaymentFailure;
      log('StripePaymentCubit failure: ${failure.errMsg}',
          name: 'StripePayment');
    }
    super.onChange(change);
  }
}
