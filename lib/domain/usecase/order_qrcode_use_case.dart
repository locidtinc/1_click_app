import 'package:injectable/injectable.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/domain/repository/order_repository.dart';
import 'package:one_click/domain/usecase/base/future/base_future_use_case.dart';
import 'package:one_click/domain/usecase/base/io/base_input.dart';

import '../entity/qr_code_payment.dart';
import 'base/io/base_output.dart';

@injectable
class OrderQrcodeUseCase
    extends BaseFutureUseCase<OrderQrcodeInput, OrderQrcodeOutput> {
  final OrderRepository _orderRepository;

  OrderQrcodeUseCase(this._orderRepository);

  @override
  Future<OrderQrcodeOutput> buildUseCase(OrderQrcodeInput input) async {
    final res = await _orderRepository.qrCodePayment(
      cardId: input.cardId,
      orderId: input.orderId,
    );
    return OrderQrcodeOutput(
      BaseResponseModel<QrCodePayment>(
        code: res.code,
        message: res.message,
        data: res.code == 200
            ? QrCodePayment(
                qrCode: res.data?.qrCode,
                amount: res.data?.amount,
                content: res.data?.content,
              )
            : null,
      ),
    );
  }
}

class OrderQrcodeInput extends BaseInput {
  final int cardId;
  final int orderId;
  OrderQrcodeInput({
    required this.cardId,
    required this.orderId,
  });
}

class OrderQrcodeOutput extends BaseOutput {
  final BaseResponseModel<QrCodePayment> response;
  OrderQrcodeOutput(this.response);
}
