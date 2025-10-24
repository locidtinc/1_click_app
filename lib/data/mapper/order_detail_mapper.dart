import 'package:injectable/injectable.dart';
import 'package:one_click/data/mapper/base/base_data_mapper.dart';
import 'package:one_click/data/mapper/customer_mapper.dart';
import 'package:one_click/domain/entity/order_detail.dart';
import 'package:one_click/domain/entity/qr_code_payment.dart';

import '../../domain/entity/order_status.dart';
import '../../shared/constants/enum/status_payment_order.dart';
import '../../shared/constants/format/time.dart';
import '../models/order_detail_model.dart';

@injectable
class OrderDetailEntityMapper
    extends BaseDataMapper<OrderDetailModel, OrderDetailEntity> {
  final CustomerEntityMapper _customerEntityMapper;
  final FormatTime _formatTime;

  OrderDetailEntityMapper(this._customerEntityMapper, this._formatTime);

  @override
  OrderDetailEntity mapToEntity(OrderDetailModel? data) {
    return OrderDetailEntity(
      id: data?.id,
      title: data?.title ?? '',
      note: data?.note ?? '',
      noteCancel: (data?.cancelReasonData?.isEmpty ?? true)
          ? ''
          : data?.cancelReasonData?.firstOrNull?.reasonData?.title ?? '',
      code: data?.code,
      total: (data?.total ?? 0.0).toDouble().round(),
      discount: (data?.discount ?? 0.0).toDouble().round(),
      createAt: _formatTime.convertToVietnamDatetime(
        data?.createdAt ?? DateTime.now(),
      ),
      isOnline: data?.isOnline ?? false,
      customerData: _customerEntityMapper.mapToEntity(data?.customerData),
      orderStatus: OrderStatusEntity(
        id: data?.statusOrderData?.id ?? data?.statusData?.id ?? 0,
        title: data?.statusOrderData?.title ?? data?.statusData?.title ?? '',
        code: data?.statusOrderData?.code ?? data?.statusData?.code ?? '',
      ),
      shopData: ShopDataEnity(
        name: data?.shopData?.title,
        phone: data?.shopData?.accountData?.phone,
        address: data?.shopData?.addressData?.title ?? '',
      ),
      statusPayment: data?.settings?.vietqr == null
          ? StatusPayment.cash
          : ((data?.settings?.vietqr?.status ?? false)
              ? StatusPayment.qrCode
              : StatusPayment.unpaid),
      variants: (data?.orderitems ?? data?.orderitemsystem ?? [])
          .map(
            (e) => OrderItemEntity(
              id: e.variant,
              name: e.variantData?.title ?? '',
              amount: (e.quantity ?? 0.0).round(),
              priceSell: (e.price ?? 0.0).round(),
              quantity: (e.variantData?.quantity ?? 0.0).round(),
              quantityInStock: (e.variantData?.quantityInStock ?? 0.0).round(),
              image: e.variantData?.image,
              models: (e.variantData?.optionsData ?? []).fold('', (model, e) {
                model = model! + (model.isEmpty ? '' : ', ') + (e.values ?? '');
                return model;
              }),
              unitSell: e.variantData?.unitSell,
            ),
          )
          .toList(),
      qrCodePayment: data?.settings?.vietqr == null
          ? null
          : QrCodePayment(
              qrCode: data?.settings?.vietqr?.data?.qrCode,
              amount: data?.settings?.vietqr?.data?.amount,
              content: data?.settings?.vietqr?.data?.content,
              qrLink: data?.settings?.vietqr?.data?.qrLink,
            ),
    );
  }
}
