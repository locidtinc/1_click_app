import 'package:one_click/data/models/order_count_model.dart';
import 'package:one_click/data/models/order_detail_model.dart';
import 'package:one_click/data/models/payload/order/payload_order.dart';
import 'package:one_click/data/models/response/base_response.dart';

import '../../data/models/order_model.dart';
import '../../data/models/qr_code_model.dart';

abstract class OrderRepository {
  Future<BaseResponseModel<List<OrderModel>>> getList({
    required int limit,
    required int page,
    required String searchKey,
    int? status,
    int? customer,
    bool? isOnline,
  });

  Future<BaseResponseModel<List<OrderModel>>> getListImport({
    required int limit,
    required int page,
    required String searchKey,
    int? status,
  });

  Future<BaseResponseModel<OrderDetailModel>> getDetailExport({
    bool? isNotiOderdata,
    required int id,
  });

  Future<BaseResponseModel<OrderDetailModel>> getDetailImport({
    required int id,
  });

  Future<BaseResponseModel<OrderDetailModel>> createOrderExport(
    PayloadOrderModel payload,
  );

  Future<BaseResponseModel<OrderDetailModel>> createOrderImport(
    Map<String, dynamic> payload,
  );

  Future<BaseResponseModel<List<OrderCountModel>>> count({
    bool? isOnline,
    int? customer,
    bool? status,
    int? shop,
  });

  /// Dành cho đơn đặt lên tổng
  Future<BaseResponseModel> updateStatusSystem({
    required int id,
    required int status,
  });

  /// Dành cho đơn đặt lên tổng
  Future<BaseResponseModel> cancelOrderSystem({
    required String tile,
    required int order,
    required int reason,
  });

  /// Dành cho đơn online và đơn bán trực tiếp
  Future<BaseResponseModel> updateStatus({
    required int id,
    required int status,
  });

  Future<BaseResponseModel<QrCodeModel>> qrCodePayment({
    required int cardId,
    required int orderId,
  });

  Future<BaseResponseModel> updateStatusPayment({
    required bool status,
    required int orderId,
  });
  Future<BaseResponseModel> getDailyOrder(
    DateTime? dateStart,
    DateTime? dateEnd,
  );
}
