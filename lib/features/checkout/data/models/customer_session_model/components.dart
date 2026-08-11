import 'buy_button.dart';
import 'customer_sheet.dart';
import 'mobile_payment_element.dart';
import 'payment_element.dart';
import 'pricing_table.dart';

class Components {
  BuyButton? buyButton;
  CustomerSheet? customerSheet;
  MobilePaymentElement? mobilePaymentElement;
  PaymentElement? paymentElement;
  PricingTable? pricingTable;

  Components({
    this.buyButton,
    this.customerSheet,
    this.mobilePaymentElement,
    this.paymentElement,
    this.pricingTable,
  });

  factory Components.fromJson(Map<String, dynamic> json) => Components(
        buyButton: json['buy_button'] == null
            ? null
            : BuyButton.fromJson(json['buy_button'] as Map<String, dynamic>),
        customerSheet: json['customer_sheet'] == null
            ? null
            : CustomerSheet.fromJson(
                json['customer_sheet'] as Map<String, dynamic>),
        mobilePaymentElement: json['mobile_payment_element'] == null
            ? null
            : MobilePaymentElement.fromJson(
                json['mobile_payment_element'] as Map<String, dynamic>),
        paymentElement: json['payment_element'] == null
            ? null
            : PaymentElement.fromJson(
                json['payment_element'] as Map<String, dynamic>),
        pricingTable: json['pricing_table'] == null
            ? null
            : PricingTable.fromJson(
                json['pricing_table'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'buy_button': buyButton?.toJson(),
        'customer_sheet': customerSheet?.toJson(),
        'mobile_payment_element': mobilePaymentElement?.toJson(),
        'payment_element': paymentElement?.toJson(),
        'pricing_table': pricingTable?.toJson(),
      };
}
