import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:one_click/domain/entity/order_detail.dart';
part 'qr_code_payment_state.freezed.dart';

@freezed
class QrCodePaymentState with _$QrCodePaymentState {
  const factory QrCodePaymentState({
    @Default(null) OrderDetailEntity? orderDetailEntity,
    @Default(true) bool isLoading,
  }) = _QrCodePaymentState;
}
