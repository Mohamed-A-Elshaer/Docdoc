import 'package:dartz/dartz.dart';
import 'package:docdoc/core/errors/failures.dart';
import 'package:docdoc/features/checkout/data/models/payment_intent_input_model.dart';
import 'package:docdoc/features/checkout/data/models/paypal_transaction_input_model.dart';
import 'package:flutter/material.dart';

abstract class CheckoutRepo {
  Future<Either<Failures, void>> makePayment({
    required PaymentIntentInputModel paymentIntentInputModel,
  });

  Future<Either<Failures, void>> makePayPalPayment({
    required BuildContext context,
    required PayPalTransactionInputModel transactionInputModel,
  });
}
