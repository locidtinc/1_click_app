// To parse this JSON data, do
//
//     final orderModel = orderModelFromJson(jsonString);

import 'dart:convert';

import 'package:one_click/data/models/customer_model.dart';

import 'status_payment.dart';

OrderModel orderModelFromJson(String str) =>
    OrderModel.fromJson(json.decode(str));

String orderModelToJson(OrderModel data) => json.encode(data.toJson());

class OrderModel {
  final int? id;
  final String? title;
  final String? code;
  final double? total;
  final double? discount;
  final bool? isOnline;
  final String? note;
  final StatusPaymentModel? settings;
  final int? status;
  final StatusOrderData? statusOrderData;
  final dynamic customer;
  final CustomerModel? customerData;
  final int? shop;
  final ShopData? shopData;
  final List<Orderitem>? orderitems;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic systemBuyData;

  OrderModel({
    this.id,
    this.title,
    this.code,
    this.total,
    this.discount,
    this.isOnline,
    this.note,
    this.settings,
    this.status,
    this.statusOrderData,
    this.customer,
    this.customerData,
    this.shop,
    this.shopData,
    this.orderitems,
    this.createdAt,
    this.updatedAt,
    this.systemBuyData,
  });

  OrderModel copyWith({
    int? id,
    String? title,
    String? code,
    double? total,
    double? discount,
    bool? isOnline,
    String? note,
    StatusPaymentModel? settings,
    int? status,
    StatusOrderData? statusOrderData,
    dynamic customer,
    dynamic customerData,
    int? shop,
    ShopData? shopData,
    List<Orderitem>? orderitems,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      OrderModel(
        id: id ?? this.id,
        title: title ?? this.title,
        code: code ?? this.code,
        total: total ?? this.total,
        discount: discount ?? this.discount,
        isOnline: isOnline ?? this.isOnline,
        note: note ?? this.note,
        settings: settings ?? this.settings,
        status: status ?? this.status,
        statusOrderData: statusOrderData ?? this.statusOrderData,
        customer: customer ?? this.customer,
        customerData: customerData ?? this.customerData,
        shop: shop ?? this.shop,
        shopData: shopData ?? this.shopData,
        orderitems: orderitems ?? this.orderitems,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json['id'],
        title: json['title'],
        code: json['code'],
        total: json['total']?.toDouble(),
        discount: json['discount']?.toDouble(),
        isOnline: json['is_online'],
        note: json['note'],
        settings: json['settings'] == null
            ? null
            : StatusPaymentModel.fromJson(json['settings']),
        status: json['status'],
        statusOrderData: json['status_order_data'] == null
            ? json['status_data'] == null
                ? null
                : StatusOrderData.fromJson(json['status_data'])
            : StatusOrderData.fromJson(json['status_order_data']),
        customer: json['customer'],
        customerData: json['customer_data'] != null
            ? CustomerModel.fromJson(json['customer_data'])
            : null,
        shop: json['shop'],
        shopData: json['shop_data'] == null
            ? null
            : ShopData.fromJson(json['shop_data']),
        orderitems: json['orderitems'] == null
            ? []
            : List<Orderitem>.from(
                json['orderitems']!.map((x) => Orderitem.fromJson(x)),
              ),
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at']),
        updatedAt: json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at']),
        systemBuyData: json['system_buy_data'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'code': code,
        'total': total,
        'discount': discount,
        'is_online': isOnline,
        'note': note,
        'settings': settings?.toJson(),
        'status': status,
        'status_order_data': statusOrderData?.toJson(),
        'customer': customer,
        'customer_data': customerData,
        'shop': shop,
        'shop_data': shopData?.toJson(),
        'orderitems': orderitems == null
            ? []
            : List<dynamic>.from(orderitems!.map((x) => x.toJson())),
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };
}

class Orderitem {
  final int? id;
  final int? quantity;
  final double? price;
  final double? discount;
  final int? variant;
  final DateTime? createdAt;

  Orderitem({
    this.id,
    this.quantity,
    this.price,
    this.discount,
    this.variant,
    this.createdAt,
  });

  Orderitem copyWith({
    int? id,
    int? quantity,
    double? price,
    double? discount,
    int? variant,
    DateTime? createdAt,
  }) =>
      Orderitem(
        id: id ?? this.id,
        quantity: quantity ?? this.quantity,
        price: price ?? this.price,
        discount: discount ?? this.discount,
        variant: variant ?? this.variant,
        createdAt: createdAt ?? this.createdAt,
      );

  factory Orderitem.fromJson(Map<String, dynamic> json) => Orderitem(
        id: json['id'],
        quantity: json['quantity'],
        price: json['price']?.toDouble(),
        discount: json['discount']?.toDouble(),
        variant: json['variant'],
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'quantity': quantity,
        'price': price,
        'discount': discount,
        'variant': variant,
        'created_at': createdAt?.toIso8601String(),
      };
}

class Settings {
  Settings();

  factory Settings.fromJson(Map<String, dynamic> json) => Settings();

  Map<String, dynamic> toJson() => {};
}

class ShopData {
  final int? id;
  final String? title;
  final dynamic address;
  final int? account;
  final dynamic bussinessType;
  final AccountData? accountData;
  final AddressData? addressData;

  ShopData({
    this.id,
    this.title,
    this.address,
    this.account,
    this.bussinessType,
    this.accountData,
    this.addressData,
  });

  ShopData copyWith({
    int? id,
    String? title,
    dynamic address,
    int? account,
    dynamic bussinessType,
    AccountData? accountData,
    AddressData? addressData,
  }) =>
      ShopData(
        id: id ?? this.id,
        title: title ?? this.title,
        address: address ?? this.address,
        account: account ?? this.account,
        bussinessType: bussinessType ?? this.bussinessType,
        accountData: accountData ?? this.accountData,
        addressData: addressData ?? this.addressData,
      );

  factory ShopData.fromJson(Map<String, dynamic> json) => ShopData(
        id: json['id'],
        title: json['title'],
        address: json['address'],
        account: json['account'],
        bussinessType: json['bussiness_type'],
        accountData: json['account_data'] == null
            ? null
            : AccountData.fromJson(json['account_data']),
        addressData: json['address_data'] == null
            ? null
            : AddressData.fromJson(json['address_data']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'address': address,
        'account': account,
        'bussiness_type': bussinessType,
        'account_data': accountData?.toJson(),
        'address_data': addressData,
      };
}

class AddressData {
  final String? title;

  AddressData({
    this.title,
  });

  factory AddressData.fromJson(Map<String, dynamic> json) => AddressData(
        title: json['title'],
      );

  Map<String, dynamic> toJson() => {
        'title': title,
      };
}

class AccountData {
  final int? id;
  final dynamic fullName;
  final String? phone;
  final bool? isActive;

  AccountData({
    this.id,
    this.fullName,
    this.phone,
    this.isActive,
  });

  AccountData copyWith({
    int? id,
    dynamic fullName,
    String? phone,
    bool? isActive,
  }) =>
      AccountData(
        id: id ?? this.id,
        fullName: fullName ?? this.fullName,
        phone: phone ?? this.phone,
        isActive: isActive ?? this.isActive,
      );

  factory AccountData.fromJson(Map<String, dynamic> json) => AccountData(
        id: json['id'],
        fullName: json['full_name'],
        phone: json['phone'],
        isActive: json['is_active'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'full_name': fullName,
        'phone': phone,
        'is_active': isActive,
      };
}

class StatusOrderData {
  final int? id;
  final String? title;
  final String? code;

  StatusOrderData({
    this.id,
    this.title,
    this.code,
  });

  StatusOrderData copyWith({
    int? id,
    String? title,
    String? code,
  }) =>
      StatusOrderData(
        id: id ?? this.id,
        title: title ?? this.title,
        code: code ?? this.code,
      );

  factory StatusOrderData.fromJson(Map<String, dynamic> json) =>
      StatusOrderData(
        id: json['id'],
        title: json['title'],
        code: json['code'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'code': code,
      };
}
