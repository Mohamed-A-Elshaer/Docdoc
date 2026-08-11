import 'package:docdoc/core/helper_models/dot_env_keys.dart';
import 'package:docdoc/features/checkout/data/models/paypal_transaction_input_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';

class PayPalPaymentCancelledException implements Exception {
  PayPalPaymentCancelledException([this.message = 'Payment cancelled.']);

  final String message;

  @override
  String toString() => message;
}

class PayPalPaymentFailedException implements Exception {
  PayPalPaymentFailedException(this.message);

  final String message;

  @override
  String toString() => message;
}

class PayPalService {
  Future<void> makePayment({
    required BuildContext context,
    required PayPalTransactionInputModel transactionInputModel,
  }) async {
    final result = await Navigator.of(context).push<Object?>(
      MaterialPageRoute(
        builder: (navContext) => PaypalCheckoutView(
          sandboxMode: kDebugMode,
          clientId: DotEnvKeys.paypalClientId,
          secretKey: DotEnvKeys.paypalSecretKey,
          transactions: transactionInputModel.toTransactionsJson(),
          note: 'Contact us for any questions on your order.',
          onSuccess: (params) {
            Navigator.pop(navContext, params);
          },
          onError: (error) {
            Navigator.pop(
              navContext,
              PayPalPaymentFailedException(_formatPayPalError(error)),
            );
          },
          onCancel: () {
            Navigator.pop(navContext, PayPalPaymentCancelledException());
          },
        ),
      ),
    );

    if (result == null || result is PayPalPaymentCancelledException) {
      throw PayPalPaymentCancelledException();
    }

    if (result is PayPalPaymentFailedException) {
      throw result;
    }
  }

  String _formatPayPalError(Object error) {
    if (error is Map) {
      final message = error['message'];
      if (message is String && message.isNotEmpty) {
        return message;
      }
    }
    return error.toString();
  }
}
