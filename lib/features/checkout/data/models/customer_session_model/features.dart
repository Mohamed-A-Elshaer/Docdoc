class Features {
  List<String>? paymentMethodAllowRedisplayFilters;
  String? paymentMethodRedisplay;
  String? paymentMethodRemove;
  String? paymentMethodSave;
  dynamic paymentMethodSaveAllowRedisplayOverride;

  Features({
    this.paymentMethodAllowRedisplayFilters,
    this.paymentMethodRedisplay,
    this.paymentMethodRemove,
    this.paymentMethodSave,
    this.paymentMethodSaveAllowRedisplayOverride,
  });

  factory Features.fromJson(Map<String, dynamic> json) => Features(
        paymentMethodAllowRedisplayFilters:
            json['payment_method_allow_redisplay_filters'] == null
                ? null
                : List<String>.from(
                    json['payment_method_allow_redisplay_filters'] as List,
                  ),
        paymentMethodRedisplay: json['payment_method_redisplay'] as String?,
        paymentMethodRemove: json['payment_method_remove'] as String?,
        paymentMethodSave: json['payment_method_save'] as String?,
        paymentMethodSaveAllowRedisplayOverride:
            json['payment_method_save_allow_redisplay_override'] as dynamic,
      );

  Map<String, dynamic> toJson() => {
        'payment_method_allow_redisplay_filters':
            paymentMethodAllowRedisplayFilters,
        'payment_method_redisplay': paymentMethodRedisplay,
        'payment_method_remove': paymentMethodRemove,
        'payment_method_save': paymentMethodSave,
        'payment_method_save_allow_redisplay_override':
            paymentMethodSaveAllowRedisplayOverride,
      };
}
