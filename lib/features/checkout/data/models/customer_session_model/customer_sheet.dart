class CustomerSheet {
  bool? enabled;
  dynamic features;

  CustomerSheet({this.enabled, this.features});

  factory CustomerSheet.fromJson(Map<String, dynamic> json) => CustomerSheet(
        enabled: json['enabled'] as bool?,
        features: json['features'] as dynamic,
      );

  Map<String, dynamic> toJson() => {
        'enabled': enabled,
        'features': features,
      };
}
