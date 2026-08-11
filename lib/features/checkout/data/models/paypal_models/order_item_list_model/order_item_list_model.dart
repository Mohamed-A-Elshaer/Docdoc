import 'item.dart';

class OrderItemListModel {
  List<Item>? items;

  OrderItemListModel({this.items});

  factory OrderItemListModel.fromJson(Map<String, dynamic> json) {
    return OrderItemListModel(
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => Item.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'items': items?.map((e) => e.toJson()).toList(),
      };
}
