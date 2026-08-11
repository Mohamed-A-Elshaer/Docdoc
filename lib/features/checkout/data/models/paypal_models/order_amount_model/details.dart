class Details {
  String? subtotal;
  String? tax;
  String? shipping;
  int? shippingDiscount;

  Details({
    this.subtotal,
    this.tax,
    this.shipping,
    this.shippingDiscount,
  });

  factory Details.fromJson(Map<String, dynamic> json) => Details(
        subtotal: json['subtotal'] as String?,
        tax: json['tax'] as String?,
        shipping: json['shipping'] as String?,
        shippingDiscount: json['shipping_discount'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'subtotal': subtotal,
        if (tax != null) 'tax': tax,
        'shipping': shipping,
        'shipping_discount': shippingDiscount,
      };
}
