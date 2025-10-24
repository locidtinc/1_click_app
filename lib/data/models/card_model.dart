// To parse this JSON data, do
//
//     final cardModel = cardModelFromJson(jsonString);

import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
part 'card_model.g.dart';

CardModel cardModelFromJson(String str) => CardModel.fromJson(json.decode(str));

String cardModelToJson(CardModel data) => json.encode(data.toJson());

@JsonSerializable()
class CardModel {
  final int? id;
  @JsonKey(name: 'full_name')
  final String? fullName;
  @JsonKey(name: 'card_number')
  final String? cardNumber;
  final bool? status;
  final dynamic qrcode;
  @JsonKey(name: 'expriry_date')
  final dynamic expriryDate;
  final dynamic cvv;
  @JsonKey(name: 'card_type')
  final int? cardType;
  final int? bank;
  final int? account;
  @JsonKey(name: 'bank_data')
  final BankData? bankData;
  @JsonKey(name: 'card_type_data')
  final CardTypeData? cardTypeData;

  CardModel({
    this.id,
    this.fullName,
    this.cardNumber,
    this.status,
    this.qrcode,
    this.expriryDate,
    this.cvv,
    this.cardType,
    this.bank,
    this.account,
    this.bankData,
    this.cardTypeData,
  });

  CardModel copyWith({
    int? id,
    String? fullName,
    String? cardNumber,
    bool? status,
    dynamic qrcode,
    dynamic expriryDate,
    dynamic cvv,
    int? cardType,
    int? bank,
    int? account,
    BankData? bankData,
    CardTypeData? cardTypeData,
  }) =>
      CardModel(
        id: id ?? this.id,
        fullName: fullName ?? this.fullName,
        cardNumber: cardNumber ?? this.cardNumber,
        status: status ?? this.status,
        qrcode: qrcode ?? this.qrcode,
        expriryDate: expriryDate ?? this.expriryDate,
        cvv: cvv ?? this.cvv,
        cardType: cardType ?? this.cardType,
        bank: bank ?? this.bank,
        account: account ?? this.account,
        bankData: bankData ?? this.bankData,
        cardTypeData: cardTypeData ?? this.cardTypeData,
      );

  factory CardModel.fromJson(Map<String, dynamic> json) =>
      _$CardModelFromJson(json);

  Map<String, dynamic> toJson() => _$CardModelToJson(this);
}

@JsonSerializable()
class BankData {
  final int? id;
  final String? title;
  final String? code;
  @JsonKey(name: 'short_name')
  final String? shortName;
  @JsonKey(name: 'img_url')
  final String? imgUrl;
  final String? bin;
  final String? swiftCode;

  BankData({
    this.id,
    this.title,
    this.code,
    this.shortName,
    this.imgUrl,
    this.bin,
    this.swiftCode,
  });

  BankData copyWith({
    int? id,
    String? title,
    String? code,
    String? shortName,
    String? imgUrl,
    String? bin,
    String? swiftCode,
  }) =>
      BankData(
        id: id ?? this.id,
        title: title ?? this.title,
        code: code ?? this.code,
        shortName: shortName ?? this.shortName,
        imgUrl: imgUrl ?? this.imgUrl,
        bin: bin ?? this.bin,
        swiftCode: swiftCode ?? this.swiftCode,
      );

  factory BankData.fromJson(Map<String, dynamic> json) =>
      _$BankDataFromJson(json);

  Map<String, dynamic> toJson() => _$BankDataToJson(this);
}

@JsonSerializable()
class CardTypeData {
  final int? id;
  final String? title;
  final String? code;

  CardTypeData({
    this.id,
    this.title,
    this.code,
  });

  CardTypeData copyWith({
    int? id,
    String? title,
    String? code,
  }) =>
      CardTypeData(
        id: id ?? this.id,
        title: title ?? this.title,
        code: code ?? this.code,
      );

  factory CardTypeData.fromJson(Map<String, dynamic> json) =>
      _$CardTypeDataFromJson(json);

  Map<String, dynamic> toJson() => _$CardTypeDataToJson(this);
}
