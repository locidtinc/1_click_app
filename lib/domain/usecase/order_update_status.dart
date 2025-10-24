import 'package:injectable/injectable.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/domain/repository/order_repository.dart';
import 'package:one_click/domain/usecase/base/future/base_future_use_case.dart';
import 'package:one_click/domain/usecase/base/io/base_input.dart';
import 'package:one_click/domain/usecase/base/io/base_output.dart';

@injectable
class OrderUpdateStatusUseCase
    extends BaseFutureUseCase<OrderUpdateStatusInput, OrderUpdateStatusOutput> {
  final OrderRepository _orderRepository;

  OrderUpdateStatusUseCase(this._orderRepository);

  @override
  Future<OrderUpdateStatusOutput> buildUseCase(
    OrderUpdateStatusInput input,
  ) async {
    final res = await _orderRepository.updateStatus(
      id: input.id,
      status: input.status,
    );
    return OrderUpdateStatusOutput(res);
  }
}

class OrderUpdateStatusInput extends BaseInput {
  final int id;
  final int status;
  OrderUpdateStatusInput({required this.id, required this.status});
}

class OrderUpdateStatusOutput extends BaseOutput {
  final BaseResponseModel response;
  OrderUpdateStatusOutput(this.response);
}
