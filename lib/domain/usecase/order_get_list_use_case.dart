import 'package:injectable/injectable.dart';
import 'package:one_click/data/mapper/order_preview_mapper.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/domain/entity/order_preview.dart';
import 'package:one_click/domain/usecase/base/future/base_future_use_case.dart';
import 'package:one_click/domain/usecase/base/io/base_input.dart';
import 'package:one_click/domain/usecase/base/io/base_output.dart';

import '../repository/order_repository.dart';

@injectable
class OrderGetListUseCase
    extends BaseFutureUseCase<OrderGetListInput, OrderGetListOutput> {
  final OrderRepository _orderRepository;
  final OrderPreviewMapper _orderPreviewMapper;

  OrderGetListUseCase(this._orderRepository, this._orderPreviewMapper);

  @override
  Future<OrderGetListOutput> buildUseCase(OrderGetListInput input) async {
    final res = await _orderRepository.getList(
      page: input.page,
      limit: input.limit,
      searchKey: input.searchKey,
      status: input.status,
      customer: input.customer,
      isOnline: input.isOnline,
    );
    return OrderGetListOutput(
      BaseResponseModel<List<OrderPreviewEntity>>(
        code: res.code,
        message: res.message,
        data: _orderPreviewMapper.mapToListEntity(res.data),
      ),
    );
  }
}

class OrderGetListInput extends BaseInput {
  final int page;
  final int limit;
  final int? customer;
  final int? status;
  final bool? isOnline;
  final String searchKey;
  OrderGetListInput({
    required this.page,
    required this.limit,
    required this.searchKey,
    this.customer,
    this.status,
    this.isOnline,
  });
}

class OrderGetListOutput extends BaseOutput {
  final BaseResponseModel<List<OrderPreviewEntity>> response;
  OrderGetListOutput(this.response);
}
