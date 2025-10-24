import 'package:injectable/injectable.dart';
import 'package:one_click/data/mapper/base/base_data_mapper.dart';
import 'package:one_click/data/models/order_count_model.dart';
import 'package:one_click/domain/entity/order_count.dart';

@injectable
class OrderCountEntityMapper
    extends BaseDataMapper<OrderCountModel, OrderCountEntity> {
  @override
  OrderCountEntity mapToEntity(OrderCountModel? data) {
    return OrderCountEntity(
      id: data?.id,
      type: data?.type,
      count: data?.count,
    );
  }
}
