import 'features.dart';

class MobilePaymentElement {
  bool? enabled;
  Features? features;

  MobilePaymentElement({this.enabled, this.features});

  factory MobilePaymentElement.fromJson(Map<String, dynamic> json) {
    return MobilePaymentElement(
      enabled: json['enabled'] as bool?,
      features: json['features'] == null
          ? null
          : Features.fromJson(json['features'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'enabled': enabled,
        'features': features?.toJson(),
      };
}
