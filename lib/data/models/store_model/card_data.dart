import 'package:freezed_annotation/freezed_annotation.dart';

import 'bank_data.dart';
import 'card_type_data.dart';

part 'card_data.g.dart';

@JsonSerializable()
class CardData {
  CardData({
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

  int? id;
  @JsonKey(name: 'full_name')
  String? fullName;
  @JsonKey(name: 'card_number')
  String? cardNumber;
  bool? status;
  dynamic qrcode;
  @JsonKey(name: 'expriry_date')
  String? expriryDate;
  String? cvv;
  @JsonKey(name: 'card_type')
  int? cardType;
  int? bank;
  int? account;
  @JsonKey(name: 'bank_data')
  BankData? bankData;
  @JsonKey(name: 'card_type_data')
  CardTypeData? cardTypeData;

  factory CardData.fromJson(Map<String, dynamic> json) =>
      _$CardDataFromJson(json);

  Map<String, dynamic> toJson() => _$CardDataToJson(this);
}
