// To parse this JSON data, do
//
//     final productCategoryModel = productCategoryModelFromJson(jsonString);

import 'dart:convert';

ProductCategoryModel productCategoryModelFromJson(String str) =>
    ProductCategoryModel.fromJson(json.decode(str));

String productCategoryModelToJson(ProductCategoryModel data) =>
    json.encode(data.toJson());

class ProductCategoryModel {
  final int? id;
  final String? title;
  final String? code;
  final int? system;
  final int? account;
  final List<int>? group;
  final List<int>? product;
  final List<GroupDatum>? groupData;
  final SystemData? systemData;
  final int? productgroupQuantity;
  final DateTime? createdAt;

  ProductCategoryModel({
    this.id,
    this.title,
    this.code,
    this.system,
    this.account,
    this.group,
    this.product,
    this.groupData,
    this.systemData,
    this.productgroupQuantity,
    this.createdAt,
  });

  ProductCategoryModel copyWith({
    int? id,
    String? title,
    String? code,
    int? system,
    int? account,
    List<int>? group,
    List<int>? product,
    List<GroupDatum>? groupData,
    SystemData? systemData,
    int? productgroupQuantity,
    DateTime? createdAt,
  }) =>
      ProductCategoryModel(
        id: id ?? this.id,
        title: title ?? this.title,
        code: code ?? this.code,
        system: system ?? this.system,
        account: account ?? this.account,
        group: group ?? this.group,
        product: product ?? this.product,
        groupData: groupData ?? this.groupData,
        systemData: systemData ?? this.systemData,
        productgroupQuantity: productgroupQuantity ?? this.productgroupQuantity,
        createdAt: createdAt ?? this.createdAt,
      );

  factory ProductCategoryModel.fromJson(Map<String, dynamic> json) =>
      ProductCategoryModel(
        id: json['id'],
        title: json['title'],
        code: json['code'],
        system: json['system'],
        account: json['account'],
        group: json['group'] == null
            ? []
            : List<int>.from(json['group']!.map((x) => x)),
        product: json['product'] == null
            ? []
            : List<int>.from(json['product']!.map((x) => x)),
        groupData: json['group_data'] == null
            ? []
            : List<GroupDatum>.from(
                json['group_data']!.map((x) => GroupDatum.fromJson(x)),
              ),
        systemData: json['system_data'] == null
            ? null
            : SystemData.fromJson(json['system_data']),
        productgroupQuantity: json['productgroup_quantity'],
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'code': code,
        'system': system,
        'account': account,
        'group': group == null ? [] : List<dynamic>.from(group!.map((x) => x)),
        'product':
            product == null ? [] : List<dynamic>.from(product!.map((x) => x)),
        'group_data': groupData == null
            ? []
            : List<dynamic>.from(groupData!.map((x) => x.toJson())),
        'system_data': systemData?.toJson(),
        'productgroup_quantity': productgroupQuantity,
        'created_at': createdAt?.toIso8601String(),
      };
}

class GroupDatum {
  final int? id;
  final String? title;
  final String? code;
  final int? account;
  final int? system;
  final List<dynamic>? product;
  final List<dynamic>? productData;
  final int? productQuantity;
  final DateTime? createdAt;

  GroupDatum({
    this.id,
    this.title,
    this.code,
    this.account,
    this.system,
    this.product,
    this.productData,
    this.productQuantity,
    this.createdAt,
  });

  GroupDatum copyWith({
    int? id,
    String? title,
    String? code,
    int? account,
    int? system,
    List<dynamic>? product,
    List<dynamic>? productData,
    int? productQuantity,
    DateTime? createdAt,
  }) =>
      GroupDatum(
        id: id ?? this.id,
        title: title ?? this.title,
        code: code ?? this.code,
        account: account ?? this.account,
        system: system ?? this.system,
        product: product ?? this.product,
        productData: productData ?? this.productData,
        productQuantity: productQuantity ?? this.productQuantity,
        createdAt: createdAt ?? this.createdAt,
      );

  factory GroupDatum.fromJson(Map<String, dynamic> json) => GroupDatum(
        id: json['id'],
        title: json['title'],
        code: json['code'],
        account: json['account'],
        system: json['system'],
        product: json['product'] == null
            ? []
            : List<dynamic>.from(json['product']!.map((x) => x)),
        productData: json['product_data'] == null
            ? []
            : List<dynamic>.from(json['product_data']!.map((x) => x)),
        productQuantity: json['product_quantity'],
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'code': code,
        'account': account,
        'system': system,
        'product':
            product == null ? [] : List<dynamic>.from(product!.map((x) => x)),
        'product_data': productData == null
            ? []
            : List<dynamic>.from(productData!.map((x) => x)),
        'product_quantity': productQuantity,
        'created_at': createdAt?.toIso8601String(),
      };
}

class SystemData {
  final int? id;
  final String? title;
  final String? code;

  SystemData({
    this.id,
    this.title,
    this.code,
  });

  SystemData copyWith({
    int? id,
    String? title,
    String? code,
  }) =>
      SystemData(
        id: id ?? this.id,
        title: title ?? this.title,
        code: code ?? this.code,
      );

  factory SystemData.fromJson(Map<String, dynamic> json) => SystemData(
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
