// To parse this JSON data, do
//
//     final payloadOrderModel = payloadOrderModelFromJson(jsonString);

import 'dart:convert';

PayloadOrderModel payloadOrderModelFromJson(String str) =>
    PayloadOrderModel.fromJson(json.decode(str));

String payloadOrderModelToJson(PayloadOrderModel data) =>
    json.encode(data.toJson());

class PayloadOrderModel {
  final Order? order;
  final List<Orderitem>? orderitem;

  PayloadOrderModel({
    this.order,
    this.orderitem,
  });

  PayloadOrderModel copyWith({
    Order? order,
    List<Orderitem>? orderitem,
  }) =>
      PayloadOrderModel(
        order: order ?? this.order,
        orderitem: orderitem ?? this.orderitem,
      );

  factory PayloadOrderModel.fromJson(Map<String, dynamic> json) =>
      PayloadOrderModel(
        order: json['order'] == null ? null : Order.fromJson(json['order']),
        orderitem: json['orderitem'] == null
            ? []
            : List<Orderitem>.from(
                json['orderitem']!.map((x) => Orderitem.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
        'order': order?.toJson(),
        'orderitem': orderitem == null
            ? []
            : List<dynamic>.from(orderitem!.map((x) => x.toJson())),
      };
}

class Order {
  final String? title;
  final String? discount;
  final dynamic customer;
  final bool? isOnline;
  final String? note;

  Order({
    this.title,
    this.discount,
    this.customer,
    this.isOnline,
    this.note,
  });

  Order copyWith({
    String? title,
    String? discount,
    dynamic customer,
    bool? isOnline,
    String? note,
  }) =>
      Order(
        title: title ?? this.title,
        discount: discount ?? this.discount,
        customer: customer ?? this.customer,
        isOnline: isOnline ?? this.isOnline,
        note: note ?? this.note,
      );

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        title: json['title'],
        discount: json['discount'],
        customer: json['customer'],
        isOnline: json['is_online'],
        note: json['note'],
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'discount': discount,
        'customer': customer,
        'is_online': isOnline,
        'note': note,
      };
}

class Orderitem {
  final int? quantity;
  final int? price;
  final int? discount;
  final int? variant;

  Orderitem({
    this.quantity,
    this.price,
    this.discount,
    this.variant,
  });

  Orderitem copyWith({
    int? quantity,
    int? price,
    int? discount,
    int? variant,
  }) =>
      Orderitem(
        quantity: quantity ?? this.quantity,
        price: price ?? this.price,
        discount: discount ?? this.discount,
        variant: variant ?? this.variant,
      );

  factory Orderitem.fromJson(Map<String, dynamic> json) => Orderitem(
        quantity: json['quantity'],
        price: json['price'],
        discount: json['discount'],
        variant: json['variant'],
      );

  Map<String, dynamic> toJson() => {
        'quantity': quantity,
        'price': price,
        'discount': discount,
        'variant': variant,
      };
}
