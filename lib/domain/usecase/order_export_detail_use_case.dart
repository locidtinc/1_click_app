import 'package:injectable/injectable.dart';
import 'package:one_click/data/mapper/order_detail_mapper.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/domain/entity/order_detail.dart';
import 'package:one_click/domain/repository/order_repository.dart';
import 'package:one_click/domain/usecase/base/future/base_future_use_case.dart';
import 'package:one_click/domain/usecase/base/io/base_input.dart';

import 'base/io/base_output.dart';

@injectable
class OrderExportDetailUseCase
    extends BaseFutureUseCase<OrderExportDetailInput, OrderExportDetailOutput> {
  final OrderRepository _orderRepository;
  final OrderDetailEntityMapper _orderDetailEntityMapper;

  OrderExportDetailUseCase(
    this._orderRepository,
    this._orderDetailEntityMapper,
  );

  @override
  Future<OrderExportDetailOutput> buildUseCase(
    OrderExportDetailInput input,
  ) async {
    final res = await _orderRepository.getDetailExport(
        isNotiOderdata: input.isNotiOderdata, id: input.id);
    return OrderExportDetailOutput(
      BaseResponseModel<OrderDetailEntity>(
        code: res.code,
        message: res.message,
        data: _orderDetailEntityMapper.mapToEntity(res.data),
      ),
    );
  }
}

class OrderExportDetailInput extends BaseInput {
  final int id;
  final bool? isNotiOderdata;
  OrderExportDetailInput(this.id, {this.isNotiOderdata});
}

class OrderExportDetailOutput extends BaseOutput {
  final BaseResponseModel<OrderDetailEntity> response;
  OrderExportDetailOutput(this.response);
}
