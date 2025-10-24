// To parse this JSON data, do
//
//     final qrCodeModel = qrCodeModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
part 'qr_code_model.g.dart';

@JsonSerializable()
class QrCodeModel {
  final String? bankCode;
  final String? bankName;
  final String? bankAccount;
  final String? userBankName;
  final String? amount;
  final String? content;
  final String? qrCode;
  final String? imgId;
  final int? existing;

  QrCodeModel({
    this.bankCode,
    this.bankName,
    this.bankAccount,
    this.userBankName,
    this.amount,
    this.content,
    this.qrCode,
    this.imgId,
    this.existing,
  });

  QrCodeModel copyWith({
    String? bankCode,
    String? bankName,
    String? bankAccount,
    String? userBankName,
    String? amount,
    String? content,
    String? qrCode,
    String? imgId,
    int? existing,
  }) =>
      QrCodeModel(
        bankCode: bankCode ?? this.bankCode,
        bankName: bankName ?? this.bankName,
        bankAccount: bankAccount ?? this.bankAccount,
        userBankName: userBankName ?? this.userBankName,
        amount: amount ?? this.amount,
        content: content ?? this.content,
        qrCode: qrCode ?? this.qrCode,
        imgId: imgId ?? this.imgId,
        existing: existing ?? this.existing,
      );

  factory QrCodeModel.fromJson(Map<String, dynamic> json) =>
      _$QrCodeModelFromJson(json);

  Map<String, dynamic> toJson() => _$QrCodeModelToJson(this);
}
