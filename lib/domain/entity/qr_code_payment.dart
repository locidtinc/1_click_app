import 'package:freezed_annotation/freezed_annotation.dart';
part 'qr_code_payment.freezed.dart';
part 'qr_code_payment.g.dart';

@freezed
class QrCodePayment with _$QrCodePayment {
  const QrCodePayment._();

  const factory QrCodePayment({
    @Required() String? qrCode,
    @Required() String? amount,
    @Required() String? content,
    @Required() String? qrLink,

  }) = _QrCodePayment;

  factory QrCodePayment.fromJson(Map<String, dynamic> json) => _$QrCodePaymentFromJson(json);
}
