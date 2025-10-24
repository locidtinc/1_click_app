// To parse this JSON data, do
//
//     final typeDiscountModel = typeDiscountModelFromJson(jsonString);

import 'dart:convert';

TypeDiscountModel typeDiscountModelFromJson(String str) => TypeDiscountModel.fromJson(json.decode(str));

String typeDiscountModelToJson(TypeDiscountModel data) => json.encode(data.toJson());

class TypeDiscountModel {
    final int? id;
    final String? title;
    final String? code;

    TypeDiscountModel({
        this.id,
        this.title,
        this.code,
    });

    TypeDiscountModel copyWith({
        int? id,
        String? title,
        String? code,
    }) => 
        TypeDiscountModel(
            id: id ?? this.id,
            title: title ?? this.title,
            code: code ?? this.code,
        );

    factory TypeDiscountModel.fromJson(Map<String, dynamic> json) => TypeDiscountModel(
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
