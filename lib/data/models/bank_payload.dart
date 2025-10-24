import 'package:json_annotation/json_annotation.dart';

part 'bank_payload.g.dart';

@JsonSerializable()
class BankPayload {
  BankPayload(
    this.cardNumber,
    this.cardName,
    this.bankId, {
    this.status = true,
    this.cardType = 1,
    this.cvv,
    this.expiryDate,
  });

  @JsonKey(name: 'card_number')
  String cardNumber;
  @JsonKey(name: 'full_name')
  String cardName;
  @JsonKey(name: 'bank')
  int bankId;
  bool? status;
  int? cvv;
  @JsonKey(name: 'expriry_date')
  String? expiryDate;
  @JsonKey(name: 'card_type')
  int? cardType;

  factory BankPayload.fromJson(Map<String, dynamic> json) => _$BankPayloadFromJson(json);

  Map<String, dynamic> toJson() => _$BankPayloadToJson(this);
}
