// To parse this JSON data, do
//
//     final promotionItemModel = promotionItemModelFromJson(jsonString);

import 'dart:convert';

PromotionItemModel promotionItemModelFromJson(String str) =>
    PromotionItemModel.fromJson(json.decode(str));

String promotionItemModelToJson(PromotionItemModel data) =>
    json.encode(data.toJson());

class PromotionItemModel {
  final int? id;
  final int? quantity;
  final double? discount;
  final PromotionItemModelSettings? settings;
  final int? typeDiscount;
  final int? promotion;
  final PromotionData? promotionData;
  final int? variant;
  final List<int>? system;
  final TypeDiscountData? typeDiscountData;
  final List<TypeDiscountData>? systemData;

  PromotionItemModel({
    this.id,
    this.quantity,
    this.discount,
    this.settings,
    this.typeDiscount,
    this.promotion,
    this.promotionData,
    this.variant,
    this.system,
    this.typeDiscountData,
    this.systemData,
  });

  PromotionItemModel copyWith({
    int? id,
    int? quantity,
    double? discount,
    PromotionItemModelSettings? settings,
    int? typeDiscount,
    int? promotion,
    PromotionData? promotionData,
    int? variant,
    List<int>? system,
    TypeDiscountData? typeDiscountData,
    List<TypeDiscountData>? systemData,
  }) =>
      PromotionItemModel(
        id: id ?? this.id,
        quantity: quantity ?? this.quantity,
        discount: discount ?? this.discount,
        settings: settings ?? this.settings,
        typeDiscount: typeDiscount ?? this.typeDiscount,
        promotion: promotion ?? this.promotion,
        promotionData: promotionData ?? this.promotionData,
        variant: variant ?? this.variant,
        system: system ?? this.system,
        typeDiscountData: typeDiscountData ?? this.typeDiscountData,
        systemData: systemData ?? this.systemData,
      );

  factory PromotionItemModel.fromJson(Map<String, dynamic> json) =>
      PromotionItemModel(
        id: json['id'],
        quantity: json['quantity'],
        discount: json['discount'],
        settings: json['settings'] == null
            ? null
            : PromotionItemModelSettings.fromJson(json['settings']),
        typeDiscount: json['type_discount'],
        promotion: json['promotion'],
        promotionData: json['promotion_data'] == null
            ? null
            : PromotionData.fromJson(json['promotion_data']),
        variant: json['variant'],
        system: json['system'] == null
            ? []
            : List<int>.from(json['system']!.map((x) => x)),
        typeDiscountData: json['type_discount_data'] == null
            ? null
            : TypeDiscountData.fromJson(json['type_discount_data']),
        systemData: json['system_data'] == null
            ? []
            : List<TypeDiscountData>.from(
                json['system_data']!.map((x) => TypeDiscountData.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'quantity': quantity,
        'discount': discount,
        'settings': settings?.toJson(),
        'type_discount': typeDiscount,
        'promotion': promotion,
        'promotion_data': promotionData?.toJson(),
        'variant': variant,
        'system':
            system == null ? [] : List<dynamic>.from(system!.map((x) => x)),
        'type_discount_data': typeDiscountData?.toJson(),
        'system_data': systemData == null
            ? []
            : List<dynamic>.from(systemData!.map((x) => x.toJson())),
      };
}

class PromotionData {
  final int? id;
  final String? title;
  final bool? status;
  final bool? statusStop;
  final DateTime? start;
  final DateTime? end;

  PromotionData({
    this.id,
    this.title,
    this.status,
    this.statusStop,
    this.start,
    this.end,
  });

  PromotionData copyWith({
    int? id,
    String? title,
    bool? status,
    bool? statusStop,
    DateTime? start,
    DateTime? end,
  }) =>
      PromotionData(
        id: id ?? this.id,
        title: title ?? this.title,
        status: status ?? this.status,
        statusStop: statusStop ?? this.statusStop,
        start: start ?? this.start,
        end: end ?? this.end,
      );

  factory PromotionData.fromJson(Map<String, dynamic> json) => PromotionData(
        id: json['id'],
        title: json['title'],
        status: json['status'],
        statusStop: json['status_stop'],
        start: json['start'] == null ? null : DateTime.parse(json['start']),
        end: json['end'] == null ? null : DateTime.parse(json['end']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'status': status,
        'status_stop': statusStop,
        'start': start?.toIso8601String(),
        'end': end?.toIso8601String(),
      };
}

class PromotionItemModelSettings {
  final dynamic quantityInit;

  PromotionItemModelSettings({
    this.quantityInit,
  });

  PromotionItemModelSettings copyWith({
    dynamic quantityInit,
  }) =>
      PromotionItemModelSettings(
        quantityInit: quantityInit ?? this.quantityInit,
      );

  factory PromotionItemModelSettings.fromJson(Map<String, dynamic> json) =>
      PromotionItemModelSettings(
        quantityInit: json['quantity_init'],
      );

  Map<String, dynamic> toJson() => {
        'quantity_init': quantityInit,
      };
}

class TypeDiscountData {
  final int? id;
  final String? title;
  final String? code;

  TypeDiscountData({
    this.id,
    this.title,
    this.code,
  });

  TypeDiscountData copyWith({
    int? id,
    String? title,
    String? code,
  }) =>
      TypeDiscountData(
        id: id ?? this.id,
        title: title ?? this.title,
        code: code ?? this.code,
      );

  factory TypeDiscountData.fromJson(Map<String, dynamic> json) =>
      TypeDiscountData(
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
