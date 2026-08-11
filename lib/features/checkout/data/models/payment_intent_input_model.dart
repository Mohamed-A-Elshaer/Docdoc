class PaymentIntentInputModel {
  final String amount;
  final String currency;
  final String customerId;

  PaymentIntentInputModel(
      {required this.amount, required this.currency, required this.customerId});

  factory PaymentIntentInputModel.fromPrice({
    required int priceInMainUnits,
    required String currency,
    String? customerId,
  }) {
    return PaymentIntentInputModel(
      amount: (priceInMainUnits * 100).toString(),
      currency: currency.toLowerCase(),
      customerId: customerId ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final body = <String, dynamic>{
      'amount': amount,
      'currency': currency.toLowerCase(),
      'automatic_payment_methods[enabled]': 'true',
    };

    if (customerId.isNotEmpty) {
      body['customer'] = customerId;
      // Allows Payment Sheet to offer "save card for future use".
      body['setup_future_usage'] = 'off_session';
    }

    return body;
  }
}
