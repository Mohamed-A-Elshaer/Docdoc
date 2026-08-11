class PricingTable {
  bool? enabled;

  PricingTable({this.enabled});

  factory PricingTable.fromJson(Map<String, dynamic> json) => PricingTable(
        enabled: json['enabled'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'enabled': enabled,
      };
}
