// To parse this JSON data, do
//
//     final orderDetailModel = orderDetailModelFromJson(jsonString);

import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:one_click/data/models/customer_model.dart';
import 'package:one_click/data/models/order_item_model.dart';

import 'order_model.dart';
import 'status_payment.dart';

part 'order_detail_model.g.dart';

OrderDetailModel orderDetailModelFromJson(String str) =>
    OrderDetailModel.fromJson(json.decode(str));

String orderDetailModelToJson(OrderDetailModel data) =>
    json.encode(data.toJson());

@JsonSerializable()
class OrderDetailModel {
  final int? id;
  final String? title;
  final String? code;
  final double? total;
  final double? discount;
  @JsonKey(name: 'is_online')
  final bool? isOnline;
  final String? note;
  final StatusPaymentModel? settings;
  final int? status;
  @JsonKey(name: 'status_order_data')
  final StatusOrderData? statusOrderData;
  @JsonKey(name: 'status_data')
  final StatusOrderData? statusData;
  final dynamic customer;
  @JsonKey(name: 'customer_data')
  final CustomerModel? customerData;
  final int? shop;
  @JsonKey(name: 'shop_data')
  final ShopData? shopData;
  final List<OrderItemModel>? orderitems;
  final List<OrderItemModel>? orderitemsystem;
  @JsonKey(name: 'updated_at')
  final DateTime? createdAt;
  @JsonKey(name: 'created_at')
  final DateTime? updatedAt;
  @JsonKey(name: 'cancel_reason_data')
  final List<CancelReasonData>? cancelReasonData;

  OrderDetailModel({
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
    this.statusData,
    this.customer,
    this.customerData,
    this.shop,
    this.shopData,
    this.orderitems,
    this.orderitemsystem,
    this.createdAt,
    this.updatedAt,
    this.cancelReasonData,
  });

  OrderDetailModel copyWith({
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
    StatusOrderData? statusData,
    dynamic customer,
    dynamic customerData,
    int? shop,
    ShopData? shopData,
    List<OrderItemModel>? orderitems,
    List<OrderItemModel>? orderitemsystem,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<CancelReasonData>? cancelReasonData,
  }) =>
      OrderDetailModel(
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
        statusData: statusData ?? this.statusData,
        customer: customer ?? this.customer,
        customerData: customerData ?? this.customerData,
        shop: shop ?? this.shop,
        shopData: shopData ?? this.shopData,
        orderitems: orderitems ?? this.orderitems,
        orderitemsystem: orderitemsystem ?? this.orderitemsystem,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        cancelReasonData: cancelReasonData ?? this.cancelReasonData,
      );

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDetailModelToJson(this);
}

@JsonSerializable()
class CancelReasonData {
  final int? id;
  final int? order;
  final int? reason;
  @JsonKey(name: 'reason_data')
  final ReasonData? reasonData;

  CancelReasonData({
    this.id,
    this.order,
    this.reason,
    this.reasonData,
  });

  factory CancelReasonData.fromJson(Map<String, dynamic> json) =>
      _$CancelReasonDataFromJson(json);

  Map<String, dynamic> toJson() => _$CancelReasonDataToJson(this);
}

@JsonSerializable()
class ReasonData {
  final int? id;
  final String? title;
  final int? account;
  final int? system;

  ReasonData({
    this.id,
    this.title,
    this.account,
    this.system,
  });

  factory ReasonData.fromJson(Map<String, dynamic> json) =>
      _$ReasonDataFromJson(json);

  Map<String, dynamic> toJson() => _$ReasonDataToJson(this);
}
