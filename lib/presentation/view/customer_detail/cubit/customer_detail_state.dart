import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:one_click/domain/entity/customer.dart';
import 'package:one_click/domain/entity/order_count.dart';
part 'customer_detail_state.freezed.dart';

@freezed
class CustomerDetailState with _$CustomerDetailState {
  const factory CustomerDetailState({
    @Default(null) CustomerEntity? customerEntity,
    @Default(<OrderCountEntity>[
      OrderCountEntity(id: 1, type: 'Chờ xác nhận', count: 0),
      OrderCountEntity(id: 3, type: 'Từ chối', count: 0),
      OrderCountEntity(id: 2, type: 'Đang xử lý', count: 0),
      OrderCountEntity(id: 4, type: 'Hoàn thành', count: 0),
    ])
    List<OrderCountEntity> listOrderCount,
  }) = _CustomerDetailState;
}
