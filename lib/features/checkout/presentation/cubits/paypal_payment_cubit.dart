import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:docdoc/features/checkout/data/models/paypal_transaction_input_model.dart';
import 'package:docdoc/features/checkout/domain/repos/checkout_repo.dart';
import 'package:flutter/material.dart';

part 'paypal_payment_state.dart';

class PayPalPaymentCubit extends Cubit<PayPalPaymentState> {
  PayPalPaymentCubit(this.checkoutRepo) : super(PayPalPaymentInitial());

  final CheckoutRepo checkoutRepo;

  Future<bool> makePaymentAsync({
    required BuildContext context,
    required PayPalTransactionInputModel transactionInputModel,
  }) async {
    emit(PayPalPaymentLoading());
    final data = await checkoutRepo.makePayPalPayment(
      context: context,
      transactionInputModel: transactionInputModel,
    );
    return data.fold(
      (failure) {
        emit(PayPalPaymentFailure(failure.message));
        return false;
      },
      (_) {
        emit(PayPalPaymentSuccess());
        return true;
      },
    );
  }

  @override
  void onChange(Change<PayPalPaymentState> change) {
    if (change.nextState is PayPalPaymentFailure) {
      final failure = change.nextState as PayPalPaymentFailure;
      log('PayPalPaymentCubit failure: ${failure.errMsg}', name: 'PayPalPayment');
    }
    super.onChange(change);
  }
}
