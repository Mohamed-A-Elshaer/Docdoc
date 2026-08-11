class CustomerSessionInputModel {
  final String customerId;

  CustomerSessionInputModel({required this.customerId});

  factory CustomerSessionInputModel.fromCustomer({
    required String customerId,
  }) {
    return CustomerSessionInputModel(
      customerId: customerId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customer': customerId,
      'components[mobile_payment_element][enabled]': 'true',
      'components[mobile_payment_element][features][payment_method_save]':
          'enabled',
      'components[mobile_payment_element][features][payment_method_redisplay]':
          'enabled',
      'components[mobile_payment_element][features][payment_method_remove]':
          'enabled',
    };
  }
}
