import 'package:injectable/injectable.dart';
import 'package:one_click/data/mapper/order_detail_mapper.dart';
import 'package:one_click/data/models/payload/order/payload_order.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/domain/entity/order_create.dart';
import 'package:one_click/domain/entity/order_detail.dart';
import 'package:one_click/domain/entity/order_import_create.dart';
import 'package:one_click/domain/repository/order_repository.dart';
import 'package:one_click/domain/usecase/base/future/base_future_use_case.dart';
import 'package:one_click/domain/usecase/base/io/base_input.dart';

import '../../data/models/order_detail_model.dart';
import 'base/io/base_output.dart';

@injectable
class OrderCreateUseCase
    extends BaseFutureUseCase<OrderCreateInput, OrderCreateOutput> {
  final OrderRepository _orderRepository;
  final OrderDetailEntityMapper _orderDetailEntityMapper;

  OrderCreateUseCase(this._orderRepository, this._orderDetailEntityMapper);

  @override
  Future<OrderCreateOutput> buildUseCase(OrderCreateInput input) async {
    late BaseResponseModel<OrderDetailModel> res;
    if (input.orderCreateEntity != null) {
      final payload =
          PayloadOrderModel.fromJson(input.orderCreateEntity!.toJson());
      res = await _orderRepository.createOrderExport(payload);
    } else {
      res = await _orderRepository
          .createOrderImport(input.orderImportCreateEntity!.toJson());
    }
    var resModel = BaseResponseModel<OrderDetailEntity>(
      code: res.code,
      message: res.message,
      data: null,
    );
    if (res.code == 200) {
      resModel = resModel.copyWith(
        data: _orderDetailEntityMapper.mapToEntity(res.data),
      );
    }
    return OrderCreateOutput(resModel);
  }
}

class OrderCreateInput extends BaseInput {
  final OrderCreateEntity? orderCreateEntity;
  final OrderImportCreateEntity? orderImportCreateEntity;
  OrderCreateInput({
    this.orderCreateEntity,
    this.orderImportCreateEntity,
  });
}

class OrderCreateOutput extends BaseOutput {
  final BaseResponseModel<OrderDetailEntity> response;

  OrderCreateOutput(this.response);
}
