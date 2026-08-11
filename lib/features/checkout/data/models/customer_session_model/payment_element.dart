class PaymentElement {
  bool? enabled;
  dynamic features;

  PaymentElement({this.enabled, this.features});

  factory PaymentElement.fromJson(Map<String, dynamic> json) {
    return PaymentElement(
      enabled: json['enabled'] as bool?,
      features: json['features'] as dynamic,
    );
  }

  Map<String, dynamic> toJson() => {
        'enabled': enabled,
        'features': features,
      };
}
