// To parse this JSON data, do
//
//     final categoryDetailModelCategoryDetailModel = categoryDetailModelCategoryDetailModelFromJson(jsonString);

import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

import 'product_category_model.dart';

part 'category_model.g.dart';

CategoryDetailModel categoryDetailModelCategoryDetailModelFromJson(
  String str,
) =>
    CategoryDetailModel.fromJson(json.decode(str));

String categoryDetailModelCategoryDetailModelToJson(CategoryDetailModel data) =>
    json.encode(data.toJson());

@JsonSerializable()
class CategoryDetailModel {
  final int? id;
  final String? title;
  final String? code;
  final int? system;
  final int? account;
  final List<int>? group;
  final List<int>? product;
  @JsonKey(name: 'group_data')
  final List<GroupDatum>? groupData;
  @JsonKey(name: 'system_data')
  final SystemData? systemData;
  @JsonKey(name: 'productgroup_quantity')
  final int? productgroupQuantity;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  CategoryDetailModel({
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

  CategoryDetailModel copyWith({
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
      CategoryDetailModel(
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

  factory CategoryDetailModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryDetailModelToJson(this);
}

@JsonSerializable()
class GroupDatum {
  final int? id;
  final String? title;
  final String? code;
  final int? account;
  final int? system;
  @JsonKey(name: 'product_quantity')
  final int? productQuantity;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  GroupDatum({
    this.id,
    this.title,
    this.code,
    this.account,
    this.system,
    this.productQuantity,
    this.createdAt,
  });

  GroupDatum copyWith({
    int? id,
    String? title,
    String? code,
    int? account,
    int? system,
    int? productQuantity,
    DateTime? createdAt,
  }) =>
      GroupDatum(
        id: id ?? this.id,
        title: title ?? this.title,
        code: code ?? this.code,
        account: account ?? this.account,
        system: system ?? this.system,
        productQuantity: productQuantity ?? this.productQuantity,
        createdAt: createdAt ?? this.createdAt,
      );

  factory GroupDatum.fromJson(Map<String, dynamic> json) =>
      _$GroupDatumFromJson(json);

  Map<String, dynamic> toJson() => _$GroupDatumToJson(this);
}
