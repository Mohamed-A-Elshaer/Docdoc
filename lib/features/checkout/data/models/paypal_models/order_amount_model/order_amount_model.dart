import 'details.dart';

class OrderAmountModel {
  String? total;
  String? currency;
  Details? details;

  OrderAmountModel({this.total, this.currency, this.details});

  factory OrderAmountModel.fromJson(Map<String, dynamic> json) {
    return OrderAmountModel(
      total: json['total'] as String?,
      currency: json['currency'] as String?,
      details: json['details'] == null
          ? null
          : Details.fromJson(json['details'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'total': total,
        'currency': currency,
        'details': details?.toJson(),
      };
}
