import 'package:dartz/dartz.dart';

import 'package:docdoc/core/errors/failures.dart';
import 'package:dio/dio.dart';
import 'package:docdoc/core/services/paypal_service.dart';
import 'package:docdoc/core/services/stripe_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'package:docdoc/features/checkout/data/models/payment_intent_input_model.dart';
import 'package:docdoc/features/checkout/data/models/paypal_transaction_input_model.dart';

import '../../domain/repos/checkout_repo.dart';

class CheckoutRepoImpl extends CheckoutRepo {
  StripeService stripeService = StripeService();
  PayPalService payPalService = PayPalService();

  @override
  Future<Either<Failures, void>> makePayment({
    required PaymentIntentInputModel paymentIntentInputModel,
  }) async {
    try {
      await stripeService.makePayment(
        paymentIntentInputModel: paymentIntentInputModel,
      );

      return right(null);
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) {
        return left(ServerFailures('Payment cancelled.'));
      }
      return left(ServerFailures(
        e.error.localizedMessage ?? e.error.message ?? 'Payment failed.',
      ));
    } on DioException catch (e) {
      return left(ServerFailures(_extractStripeErrorMessage(e)));
    } catch (e) {
      return left(ServerFailures(e.toString()));
    }
  }

  @override
  Future<Either<Failures, void>> makePayPalPayment({
    required BuildContext context,
    required PayPalTransactionInputModel transactionInputModel,
  }) async {
    try {
      await payPalService.makePayment(
        context: context,
        transactionInputModel: transactionInputModel,
      );
      return right(null);
    } on PayPalPaymentCancelledException catch (e) {
      return left(ServerFailures(e.message));
    } on PayPalPaymentFailedException catch (e) {
      return left(ServerFailures(e.message));
    } catch (e) {
      return left(ServerFailures(e.toString()));
    }
  }

  String _extractStripeErrorMessage(DioException e) {
    final data = e.response?.data;
    if (data is Map) {
      final error = data['error'];
      if (error is Map && error['message'] is String) {
        return error['message'] as String;
      }
    }
    return e.message ?? 'Stripe request failed';
  }
}
