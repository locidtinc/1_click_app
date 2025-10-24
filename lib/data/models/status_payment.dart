// To parse this JSON data, do
//
//     final statusPaymentModel = statusPaymentModelFromJson(jsonString);

import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
part 'status_payment.g.dart';

StatusPaymentModel statusPaymentModelFromJson(String str) => StatusPaymentModel.fromJson(json.decode(str));

String statusPaymentModelToJson(StatusPaymentModel data) => json.encode(data.toJson());

@JsonSerializable()
class StatusPaymentModel {
  @JsonKey(name: 'VIETQR')
  final Vietqr? vietqr;

  StatusPaymentModel({
    @JsonKey(name: 'VIETQR') this.vietqr,
  });

  StatusPaymentModel copyWith({
    Vietqr? vietqr,
  }) =>
      StatusPaymentModel(
        vietqr: vietqr ?? this.vietqr,
      );

  factory StatusPaymentModel.fromJson(Map<String, dynamic> json) => _$StatusPaymentModelFromJson(json);

  Map<String, dynamic> toJson() => _$StatusPaymentModelToJson(this);
}

@JsonSerializable()
class Vietqr {
  final Data? data;
  final bool? status;

  Vietqr({
    this.data,
    this.status,
  });

  Vietqr copyWith({
    Data? data,
    bool? status,
  }) =>
      Vietqr(
        data: data ?? this.data,
        status: status ?? this.status,
      );

  factory Vietqr.fromJson(Map<String, dynamic> json) => _$VietqrFromJson(json);

  Map<String, dynamic> toJson() => _$VietqrToJson(this);
}

@JsonSerializable()
class Data {
  final String? qrLink;
  final String? amount;
  final String? qrCode;
  final String? content;
  final String? bankCode;
  final String? bankName;
  final int? existing;
  final String? bankAccount;
  final String? userBankName;

  Data({
    this.qrLink,
    this.amount,
    this.qrCode,
    this.content,
    this.bankCode,
    this.bankName,
    this.existing,
    this.bankAccount,
    this.userBankName,
  });

  Data copyWith({
    String? qrLink,
    String? amount,
    String? qrCode,
    String? content,
    String? bankCode,
    String? bankName,
    int? existing,
    String? bankAccount,
    String? userBankName,
  }) =>
      Data(
        qrLink: qrLink ?? this.qrLink,
        amount: amount ?? this.amount,
        qrCode: qrCode ?? this.qrCode,
        content: content ?? this.content,
        bankCode: bankCode ?? this.bankCode,
        bankName: bankName ?? this.bankName,
        existing: existing ?? this.existing,
        bankAccount: bankAccount ?? this.bankAccount,
        userBankName: userBankName ?? this.userBankName,
      );

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}
