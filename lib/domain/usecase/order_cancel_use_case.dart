import 'package:injectable/injectable.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/domain/repository/order_repository.dart';
import 'package:one_click/domain/usecase/base/future/base_future_use_case.dart';
import 'package:one_click/domain/usecase/base/io/base_input.dart';
import 'package:one_click/domain/usecase/base/io/base_output.dart';

@injectable
class OrderCancelUseCase
    extends BaseFutureUseCase<OrderCancelInput, OrderCancelOutput> {
  final OrderRepository _orderRepository;

  OrderCancelUseCase(this._orderRepository);

  @override
  Future<OrderCancelOutput> buildUseCase(OrderCancelInput input) async {
    final res = await _orderRepository.cancelOrderSystem(
      tile: input.title,
      order: input.order,
      reason: input.reason,
    );
    return OrderCancelOutput(res);
  }
}

class OrderCancelInput extends BaseInput {
  final String title;
  final int order;
  final int reason;

  OrderCancelInput({
    required this.order,
    required this.reason,
    required this.title,
  });
}

class OrderCancelOutput extends BaseOutput {
  final BaseResponseModel response;
  OrderCancelOutput(this.response);
}
