import 'package:injectable/injectable.dart';
import 'package:one_click/data/mapper/order_detail_mapper.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/domain/entity/order_detail.dart';
import 'package:one_click/domain/repository/order_repository.dart';
import 'package:one_click/domain/usecase/base/future/base_future_use_case.dart';
import 'package:one_click/domain/usecase/base/io/base_input.dart';

import 'base/io/base_output.dart';

@injectable
class OrderImportDetailUseCase
    extends BaseFutureUseCase<OrderImportDetailInput, OrderImportDetailOutput> {
  final OrderRepository _orderRepository;
  final OrderDetailEntityMapper _orderDetailEntityMapper;

  OrderImportDetailUseCase(
    this._orderRepository,
    this._orderDetailEntityMapper,
  );

  @override
  Future<OrderImportDetailOutput> buildUseCase(
    OrderImportDetailInput input,
  ) async {
    final res = await _orderRepository.getDetailImport(id: input.id);
    return OrderImportDetailOutput(
      BaseResponseModel<OrderDetailEntity>(
        code: res.code,
        message: res.message,
        data: _orderDetailEntityMapper.mapToEntity(res.data),
      ),
    );
  }
}

class OrderImportDetailInput extends BaseInput {
  final int id;
  OrderImportDetailInput(this.id);
}

class OrderImportDetailOutput extends BaseOutput {
  final BaseResponseModel<OrderDetailEntity> response;
  OrderImportDetailOutput(this.response);
}
