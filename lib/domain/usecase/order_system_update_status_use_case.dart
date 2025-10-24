import 'package:injectable/injectable.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/domain/repository/order_repository.dart';
import 'package:one_click/domain/usecase/base/future/base_future_use_case.dart';
import 'package:one_click/domain/usecase/base/io/base_input.dart';
import 'package:one_click/domain/usecase/base/io/base_output.dart';

@injectable
class OrderSystemUpdateStatusUseCase extends BaseFutureUseCase<
    OrderSystemUpdateStatusInput, OrderSystemUpdateStatusOutput> {
  final OrderRepository _orderRepository;

  OrderSystemUpdateStatusUseCase(this._orderRepository);

  @override
  Future<OrderSystemUpdateStatusOutput> buildUseCase(
    OrderSystemUpdateStatusInput input,
  ) async {
    final res = await _orderRepository.updateStatusSystem(
      id: input.id,
      status: input.status,
    );
    return OrderSystemUpdateStatusOutput(res);
  }
}

class OrderSystemUpdateStatusInput extends BaseInput {
  final int id;
  final int status;
  OrderSystemUpdateStatusInput({required this.id, required this.status});
}

class OrderSystemUpdateStatusOutput extends BaseOutput {
  final BaseResponseModel response;
  OrderSystemUpdateStatusOutput(this.response);
}
