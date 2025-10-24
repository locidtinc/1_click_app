import 'package:injectable/injectable.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/domain/repository/order_repository.dart';
import 'package:one_click/domain/usecase/base/io/base_input.dart';
import 'package:one_click/domain/usecase/base/io/base_output.dart';

import 'base/future/base_future_use_case.dart';

@injectable
class UpdateStatusPaymentOrderUseCase extends BaseFutureUseCase<
    UpdateStatusPaymentOrderInput, UpdateStatusPaymentOrderOutput> {
  final OrderRepository _orderRepository;
  UpdateStatusPaymentOrderUseCase(this._orderRepository);
  @override
  Future<UpdateStatusPaymentOrderOutput> buildUseCase(
    UpdateStatusPaymentOrderInput input,
  ) async {
    final res = await _orderRepository.updateStatusPayment(
      status: input.status,
      orderId: input.orderId,
    );
    return UpdateStatusPaymentOrderOutput(res);
  }
}

class UpdateStatusPaymentOrderInput extends BaseInput {
  final bool status;
  final int orderId;
  UpdateStatusPaymentOrderInput(this.orderId, this.status);
}

class UpdateStatusPaymentOrderOutput extends BaseOutput {
  final BaseResponseModel response;
  UpdateStatusPaymentOrderOutput(this.response);
}
