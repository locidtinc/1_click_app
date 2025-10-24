import 'package:injectable/injectable.dart';
import 'package:one_click/data/mapper/base/base_data_mapper.dart';
import 'package:one_click/data/models/payload/order/payload_order.dart';
import 'package:one_click/domain/entity/order_create.dart';

@injectable
class OrderCreateEntityMapper
    extends BaseDataMapper<OrderCreateEntity, PayloadOrderModel> {
  @override
  PayloadOrderModel mapToEntity(OrderCreateEntity? data) {
    final json = data!.toJson();
    return PayloadOrderModel.fromJson(json);
  }
}
