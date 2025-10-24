import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/domain/entity/order_detail.dart';
import 'package:one_click/domain/usecase/order_export_detail_use_case.dart';

import '../../../../data/models/response/base_response.dart';
import '../../../../domain/usecase/update_status_payment_order_use_case.dart';
import 'qr_code_payment_state.dart';

@injectable
class QrCodePaymentCubit extends Cubit<QrCodePaymentState> {
  QrCodePaymentCubit(
    this._updateStatusPaymentOrderUseCase,
    this._orderExportDetailUseCase,
  ) : super(const QrCodePaymentState());

  final UpdateStatusPaymentOrderUseCase _updateStatusPaymentOrderUseCase;
  final OrderExportDetailUseCase _orderExportDetailUseCase;

  Future<BaseResponseModel> updatePayment() async {
    final input = UpdateStatusPaymentOrderInput(
      state.orderDetailEntity?.id ?? 0,
      true,
    );
    final res = await _updateStatusPaymentOrderUseCase.execute(input);
    return res.response;
  }

  /// After create order type [StatusPayment] in [OrderDetailEntity] is null
  ///
  /// Because After we call Api create QRcode for this order this type will change
  ///
  /// After Call API we need get detail order again to update [StatusPayment]
  Future<void> getDetailOrder(OrderDetailEntity order) async {
    final input = OrderExportDetailInput(order.id!);
    final res = await _orderExportDetailUseCase.execute(input);
    emit(
      state.copyWith(
        orderDetailEntity: res.response.data,
        isLoading: false,
      ),
    );
  }
}
