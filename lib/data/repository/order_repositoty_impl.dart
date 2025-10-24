import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:one_click/data/apis/base_dio.dart';
import 'package:one_click/data/apis/end_point.dart';
import 'package:one_click/data/models/order_count_model.dart';
import 'package:one_click/data/models/order_model.dart';
import 'package:one_click/data/models/payload/order/payload_order.dart';
import 'package:one_click/data/models/qr_code_model.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/domain/repository/order_repository.dart';

import '../models/order_detail_model.dart';

@LazySingleton(as: OrderRepository)
class OrderRepositoryImpl extends OrderRepository {
  final BaseDio baseDio;

  OrderRepositoryImpl(this.baseDio);

  @override
  Future<BaseResponseModel<OrderDetailModel>> createOrderExport(
    PayloadOrderModel payload,
  ) async {
    try {
      final res = await baseDio.dio().post(Api.order, data: payload.toJson());
      var resModel = BaseResponseModel<OrderDetailModel>(
        code: res.data['code'],
        message: res.data['message'],
        data: null,
      );
      if (res.data['code'] == 200) {
        resModel = resModel.copyWith(
          data: OrderDetailModel.fromJson(res.data['data']['order']),
        );
      }
      return resModel;
    } catch (e) {
      return BaseResponseModel<OrderDetailModel>(
        code: 400,
        message: e.toString(),
        data: null,
      );
    }
  }

  @override
  Future<BaseResponseModel<OrderDetailModel>> createOrderImport(
    Map<String, dynamic> payload,
  ) async {
    final res = await baseDio.dio().post(Api.orderSystem, data: payload);
    var resModel = BaseResponseModel<OrderDetailModel>(
      code: res.data['code'],
      message: res.data['message'],
      data: null,
    );
    if (res.data['code'] == 200) {
      resModel = resModel.copyWith(
        data: OrderDetailModel.fromJson(res.data['data']),
      );
    }

    return resModel;
  }

  @override
  Future<BaseResponseModel<List<OrderModel>>> getList({
    required int limit,
    required int page,
    required String searchKey,
    int? customer,
    int? status,
    bool? isOnline,
  }) async {
    final res = await baseDio.dio().get(
          '${Api.order}?page=$page&limit=$limit&title__icontains=$searchKey${customer == null ? '' : '&customer=$customer'}${status == null ? '' : '&status=$status'}${isOnline == null ? '' : '&is_online__icontains=$isOnline'}',
        );
    // return res;
    return BaseResponseModel<List<OrderModel>>(
      code: res.statusCode,
      message: res.statusMessage,
      data: (res.data['data'] as List)
          .map((e) => OrderModel.fromJson(e))
          .toList(),
    );
  }

  @override
  Future<BaseResponseModel<List<OrderCountModel>>> count({
    bool? isOnline,
    int? customer,
    bool? status,
    int? shop,
  }) async {
    final res =
        await baseDio.dio().get('${Api.orderCount}?customer=${customer ?? ''}');
    // final res = await baseDio.dio().get('${Api.orderCount}?is_online=${isOnline ?? 'True'}&customer=${customer ?? ''}&status=${status ?? 'True'}&shop=${shop ?? ''}');
    return BaseResponseModel(
      code: res.statusCode,
      message: res.statusMessage,
      data: (res.data['data'] as List)
          .map((e) => OrderCountModel.fromJson(e))
          .toList(),
    );
  }

  @override
  Future<BaseResponseModel<List<OrderModel>>> getListImport({
    required int limit,
    required int page,
    required String searchKey,
    int? status,
  }) async {
    final res = await baseDio.dio().get(
          '${Api.orderSystem}?page=$page&limit=$limit&search=$searchKey${status == null ? '' : '&status=$status'}',
        );
    return BaseResponseModel<List<OrderModel>>(
      code: res.statusCode,
      message: res.statusMessage,
      data: (res.data['data'] as List)
          .map((e) => OrderModel.fromJson(e))
          .toList(),
    );
  }

  @override
  Future<BaseResponseModel<OrderDetailModel>> getDetailExport({
    bool? isNotiOderdata,
    required int id,
  }) async {
    final res = await baseDio.dio().get(isNotiOderdata == true
        ? '${Api.orderSystem}' '$id'
        : '${Api.order}' '$id');
    var resModel = BaseResponseModel<OrderDetailModel>(
      code: res.data['code'],
      message: res.data['message'],
      data: null,
    );
    if (res.data['code'] == 200) {
      resModel = resModel.copyWith(
        data: OrderDetailModel.fromJson(res.data['data']),
      );
    }
    return resModel;
  }

  @override
  Future<BaseResponseModel<OrderDetailModel>> getDetailImport({
    required int id,
  }) async {
    final res = await baseDio.dio().get('${Api.orderSystem}$id');
    var resModel = BaseResponseModel<OrderDetailModel>(
      code: res.data['code'],
      message: res.data['message'],
      data: null,
    );
    if (res.data['code'] == 200) {
      resModel = resModel.copyWith(
        data: OrderDetailModel.fromJson(res.data['data']),
      );
    }
    return resModel;
  }

  @override
  Future<BaseResponseModel> updateStatusSystem({
    required int id,
    required int status,
  }) async {
    final res = await baseDio.dio().put(
      '${Api.orderSystemUpdateStatus}$id/',
      data: {'status': status.toString()},
    );
    return BaseResponseModel(
      code: res.statusCode,
      message: res.statusMessage,
    );
  }

  @override
  Future<BaseResponseModel<QrCodeModel>> qrCodePayment({
    required int cardId,
    required int orderId,
  }) async {
    try {
      final res = await baseDio
          .dio()
          .put('${Api.orderQRCodePayment}$orderId/', data: {'card': cardId});
      return BaseResponseModel<QrCodeModel>(
        code: res.data['code'],
        message: res.data['message'],
        data: res.data['code'] == 200
            ? QrCodeModel.fromJson(res.data['data'])
            : null,
      );
    } catch (e) {
      return BaseResponseModel<QrCodeModel>(
        code: 400,
        message: e.toString(),
        data: null,
      );
    }
  }

  @override
  Future<BaseResponseModel> updateStatusPayment({
    required bool status,
    required int orderId,
  }) async {
    final res = await baseDio
        .dio()
        .patch('${Api.orderQRCodePayment}$orderId/', data: {'status': status});
    return BaseResponseModel(
      code: res.data['code'],
      message: res.data['message'],
    );
  }

  @override
  Future<BaseResponseModel> updateStatus({
    required int id,
    required int status,
  }) async {
    final res = await baseDio.dio().put(
      '${Api.orderUpdateStatus}$id/',
      data: {'status': status.toString()},
    );
    return BaseResponseModel(
      code: res.statusCode,
      message: res.statusMessage,
    );
  }

  @override
  Future<BaseResponseModel> cancelOrderSystem({
    required String tile,
    required int order,
    required int reason,
  }) async {
    final res = await baseDio.dio().post(
      Api.orderSystemCancel,
      data: {
        'reason': {'title': tile},
        'cancel_order': {'order': order, 'reason': reason},
      },
    );
    return BaseResponseModel(
      code: res.statusCode,
      message: res.statusMessage,
    );
  }

  @override
  Future<BaseResponseModel> getDailyOrder(
    DateTime? dateStart,
    DateTime? dateEnd,
  ) async {
    final Map<String, dynamic> params = {};
    if (dateStart != null) {
      params['start_date'] = DateFormat('y-MM-dd').format(dateStart);
    }
    if (dateEnd != null) {
      params['end_date'] = DateFormat('y-MM-dd').format(dateEnd);
    }
    final res = await baseDio.dio().get(
          Api.dailyOrders,
          queryParameters: params,
        );
    return BaseResponseModel(
      code: res.statusCode,
      message: res.statusMessage,
      data: res.data,
    );
  }
}
