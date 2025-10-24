import 'package:injectable/injectable.dart';
import 'package:one_click/domain/entity/customer.dart';
import 'package:one_click/presentation/view/order_create/cubit/order_create_state.dart';
import 'package:one_click/shared/constants/enum/status_payment_order.dart';
import 'package:one_click/shared/constants/format/time.dart';

import '../../domain/entity/order_preview.dart';
import '../../domain/entity/order_status.dart';
import '../models/order_model.dart';
import 'base/base_data_mapper.dart';

@injectable
class OrderPreviewMapper
    extends BaseDataMapper<OrderModel, OrderPreviewEntity> {
  final FormatTime _formatTime;

  OrderPreviewMapper(this._formatTime);

  @override
  OrderPreviewEntity mapToEntity(OrderModel? data) {
    return OrderPreviewEntity(
      id: data?.id ?? 0,
      code: data?.code ?? '',
      status: OrderStatusEntity(
        id: data!.statusOrderData?.id ?? 0,
        title: data.statusOrderData?.title ?? '',
        code: data.statusOrderData?.code ?? '',
      ),
      isOnline: data.isOnline,
      customerData: CustomerEntity(
          id: data.customerData?.id,
          fullName: data.customerData?.fullName,
          phone: data.customerData?.phone),
      createdAt: _formatTime.convertToVietnamDatetime(
        data.createdAt ?? DateTime.now(),
      ), //'${DateFormat('hh:mm').format(data.createdAt ?? DateTime.now())} - ${DateFormat('dd/MM/y').format(data.createdAt ?? DateTime.now())}',
      total: data.total!.round(),
      discount: data.discount!.round(),
      typeOrder: data.systemBuyData == null ? TypeOrder.cHTH : TypeOrder.ad,
      statusPayment: data.settings?.vietqr == null
          ? StatusPayment.cash
          : ((data.settings?.vietqr?.status ?? false)
              ? StatusPayment.qrCode
              : StatusPayment.unpaid),
    );
  }
}
