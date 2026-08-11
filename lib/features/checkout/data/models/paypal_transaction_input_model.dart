import 'package:docdoc/features/checkout/data/models/paypal_models/order_amount_model/details.dart';
import 'package:docdoc/features/checkout/data/models/paypal_models/order_amount_model/order_amount_model.dart';
import 'package:docdoc/features/checkout/data/models/paypal_models/order_item_list_model/item.dart';
import 'package:docdoc/features/checkout/data/models/paypal_models/order_item_list_model/order_item_list_model.dart';

class PayPalTransactionInputModel {
  final int subtotalInMainUnits;
  final int taxInMainUnits;
  final String currency;
  final String itemName;
  final String description;

  const PayPalTransactionInputModel({
    required this.subtotalInMainUnits,
    required this.taxInMainUnits,
    required this.currency,
    required this.itemName,
    required this.description,
  });

  factory PayPalTransactionInputModel.fromBooking({
    required int appointPrice,
    required int taxAmount,
    required String doctorName,
    String currency = 'USD',
  }) {
    return PayPalTransactionInputModel(
      subtotalInMainUnits: appointPrice,
      taxInMainUnits: taxAmount,
      currency: currency,
      itemName: 'Doctor Appointment - $doctorName',
      description: 'Docdoc appointment booking payment.',
    );
  }

  int get paymentTotalInMainUnits => subtotalInMainUnits + taxInMainUnits;

  OrderAmountModel get orderAmount => OrderAmountModel(
        total: paymentTotalInMainUnits.toString(),
        currency: currency.toUpperCase(),
        details: Details(
          subtotal: subtotalInMainUnits.toString(),
          tax: taxInMainUnits.toString(),
          shipping: '0',
          shippingDiscount: 0,
        ),
      );

  OrderItemListModel get orderItemList => OrderItemListModel(
        items: [
          Item(
            name: itemName,
            quantity: 1,
            price: subtotalInMainUnits.toString(),
            currency: currency.toUpperCase(),
          ),
        ],
      );

  List<Map<String, dynamic>> toTransactionsJson() {
    return [
      {
        'amount': orderAmount.toJson(),
        'description': description,
        'item_list': orderItemList.toJson(),
      },
    ];
  }
}
