class BuyButton {
  bool? enabled;

  BuyButton({this.enabled});

  factory BuyButton.fromJson(Map<String, dynamic> json) => BuyButton(
        enabled: json['enabled'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'enabled': enabled,
      };
}
