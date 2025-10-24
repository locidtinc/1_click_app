import 'package:injectable/injectable.dart';
import 'package:one_click/data/mapper/base/base_data_mapper.dart';
import 'package:one_click/domain/entity/order_detail.dart';
import 'package:one_click/domain/entity/order_preview.dart';
import 'package:one_click/domain/entity/order_status.dart';
import 'package:one_click/shared/constants/enum/status_order.dart';
import 'package:one_click/shared/constants/enum/status_payment_order.dart';

@injectable

/// Use only for [StatusOrder.draft] Order
class OrderDetailToPreviewMapper
    extends BaseDataMapper<OrderDetailEntity, OrderPreviewEntity> {
  @override
  OrderPreviewEntity mapToEntity(OrderDetailEntity? data) {
    return OrderPreviewEntity(
      id: data?.id ?? 0,
      code: data?.code ?? '',
      status: data?.orderStatus ??
          const OrderStatusEntity(id: 0, title: 'Dự thảo', code: 'DRAF'),
      isOnline: data?.isOnline,
      createdAt: data?.createAt ?? 'Chưa có thông tin',
      total: data?.total ?? 0,
      statusPayment: StatusPayment.unpaid,
      customerData: data?.customerData,
    );
  }
}
