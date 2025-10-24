import 'package:injectable/injectable.dart';
import 'package:one_click/data/mapper/order_count_mapper.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/domain/entity/order_count.dart';
import 'package:one_click/domain/repository/order_repository.dart';
import 'package:one_click/domain/usecase/base/future/base_future_use_case.dart';
import 'package:one_click/domain/usecase/base/io/base_input.dart';
import 'package:one_click/domain/usecase/base/io/base_output.dart';

@injectable
class OrderCountUseCase
    extends BaseFutureUseCase<OrderCountInput, OrderCountOutput> {
  final OrderRepository _orderRepository;
  final OrderCountEntityMapper _orderCountEntityMapper;

  OrderCountUseCase(
    this._orderRepository,
    this._orderCountEntityMapper,
  );

  @override
  Future<OrderCountOutput> buildUseCase(OrderCountInput input) async {
    final res = await _orderRepository.count(
      isOnline: input.isOnline,
      customer: input.customer,
      shop: input.shop,
      status: input.status,
    );
    return OrderCountOutput(
      BaseResponseModel<List<OrderCountEntity>>(
        code: res.code,
        message: res.message,
        data: _orderCountEntityMapper.mapToListEntity(res.data),
      ),
    );
  }
}

class OrderCountInput extends BaseInput {
  final bool? isOnline;
  final int? customer;
  final bool? status;
  final int? shop;

  OrderCountInput({this.customer, this.isOnline, this.shop, this.status});
}

class OrderCountOutput extends BaseOutput {
  final BaseResponseModel<List<OrderCountEntity>> response;

  OrderCountOutput(this.response);
}
