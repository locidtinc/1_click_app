import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/domain/entity/order_detail.dart';
import 'package:one_click/domain/usecase/order_export_detail_use_case.dart';
import 'package:one_click/domain/usecase/order_import_detail_use_case.dart';
import 'package:one_click/domain/usecase/order_system_update_status_use_case.dart';
import 'package:one_click/presentation/di/di.dart';
import 'package:one_click/presentation/view/card_bank/cubit/card_bank_cubit.dart';
import 'package:one_click/presentation/view/order_create/cubit/order_create_state.dart';
import 'package:one_click/shared/constants/local_storage/app_shared_preference.dart';
import 'package:one_click/shared/constants/pref_keys.dart';

import '../../../../domain/usecase/order_cancel_use_case.dart';
import '../../../../domain/usecase/order_detail_draf_use_case.dart';
import '../../../../domain/usecase/order_qrcode_use_case.dart';
import '../../../../domain/usecase/order_update_status.dart';
import '../../../routers/router.gr.dart';
import '../../order_create/widgets/confirm_payment.dart';
import 'order_detail_state.dart';

@injectable
class OrderDetailCubit extends Cubit<OrderDetailState> {
  OrderDetailCubit(
    this._orderExportDetailUseCase,
    this._orderImportDetailUseCase,
    this._orderSystemUpdateStatusUseCase,
    this._orderDetailDrafUseCase,
    this._orderUpdateStatusUseCase,
    this._orderCancelUseCase,
    this._orderQrcodeUseCase,
  ) : super(const OrderDetailState());

  final OrderExportDetailUseCase _orderExportDetailUseCase;
  final OrderImportDetailUseCase _orderImportDetailUseCase;
  final OrderSystemUpdateStatusUseCase _orderSystemUpdateStatusUseCase;
  final OrderUpdateStatusUseCase _orderUpdateStatusUseCase;
  final OrderDetailDrafUseCase _orderDetailDrafUseCase;
  final OrderCancelUseCase _orderCancelUseCase;
  final OrderQrcodeUseCase _orderQrcodeUseCase;

  final List<DropdownMenuItem> listReaseon = [
    const DropdownMenuItem(
      value: 1,
      child: Text('Sản phẩm lỗi/hỏng'),
    ),
    const DropdownMenuItem(
      value: 2,
      child: Text('Giao hàng không đúng số lượng'),
    ),
    const DropdownMenuItem(
      value: 3,
      child: Text('Khác'),
    ),
  ];

  void reasonChange(value) {
    final reason = listReaseon.firstWhere((e) => e.value == value);
    late String titleReason;
    switch (reason.value) {
      case 1:
        titleReason = 'Sản phẩm lỗi/hỏng';
        break;
      case 2:
        titleReason = 'Giao hàng không đúng số lượng';
        break;
      default:
        titleReason = '';
    }
    emit(state.copyWith(idReasonDeny: value, titleReason: titleReason));
  }

  void titleReasonChange(String value) {
    emit(state.copyWith(titleReason: value));
  }

  Future<void> initData(
    data,
    TypeOrder typeOrder,
    bool isDrafOrder, {
    bool? isNotiOderdata,
  }) async {
    emit(
      state.copyWith(
        typeOrder: typeOrder,
        data: data,
        isDrafOrder: isDrafOrder,
      ),
    );
    if (data is OrderDetailEntity) {
      emit(state.copyWith(orderDetail: data));
    } else if (data is int && isDrafOrder) {
      getDetailDrafOrder(id: data, typeOrder: typeOrder);
    } else if (data is int) {
      switch (state.typeOrder) {
        case TypeOrder.cHTH:
          await getDetailExportOrder(data, isNotiOderdata: isNotiOderdata);
          break;
        default:
          await getDetailImportOrder(data);
          break;
      }
    }

    emit(state.copyWith(isLoading: false));
  }

  void getDetailDrafOrder({
    required int id,
    required TypeOrder typeOrder,
  }) {
    final input = OrderDetailDrafInput(id: id, typeOrder: typeOrder);
    final res = _orderDetailDrafUseCase.buildUseCase(input);
    emit(state.copyWith(orderDetail: res.order));
  }

  /// Delete Order has TypeOrder is Draf [TypeOrder]
  ///
  /// Delete Order by get list from local [AppSharedPreference]
  ///
  /// After Delete, set new list to local [AppSharedPreference]
  void deleteOrderDraf() {
    final shared = AppSharedPreference.instance;
    final json = shared.getValue(PrefKeys.orderDrafExport);
    if (json == null) return;
    final listJson = jsonDecode(json as String);
    final listOrder = (listJson as List)
        .map((item) => OrderDetailEntity.fromJson(item))
        .toList();
    listOrder.removeWhere((e) => e.id == state.orderDetail?.id);
    shared.setValue(
      PrefKeys.orderDrafExport,
      jsonEncode(listOrder.map((e) => e.toJson()).toList()),
    );
  }

  void onConfirmHandle(BuildContext context, {required int status}) {
    if (state.orderDetail?.isOnline ?? false) {
      if (!validateOrderOnline) {
        DialogUtils.showErrorDialog(
          context,
          content:
              'Có sản phẩm không đủ số lượng bán.\n Hoặc chưa chọn khách hàng.\nVui lòng cập nhật lại đơn hàng\nhoặc số lượng tồn kho của sản phẩm',
        );
        return;
      }
      confirmOrderOnline(context);
      return;
    }
    updateStatus(status);
  }

  bool get validateOrderOnline {
    for (final item in (state.orderDetail?.variants ?? <OrderItemEntity>[])) {
      if ((item.quantityInStock ?? 0) < (item.amount ?? 0)) {
        return false;
      }
    }
    return true;
  }
}

extension ApiEvent on OrderDetailCubit {
  Future<void> getDetailExportOrder(
    int id, {
    bool? isNotiOderdata,
  }) async {
    final input = OrderExportDetailInput(
      id,
      isNotiOderdata: isNotiOderdata,
    );
    final res = await _orderExportDetailUseCase.execute(input);
    emit(state.copyWith(orderDetail: res.response.data, isLoading: false));
  }

  Future<void> getDetailImportOrder(int id) async {
    final input = OrderImportDetailInput(id);
    final res = await _orderImportDetailUseCase.execute(input);
    emit(state.copyWith(orderDetail: res.response.data, isLoading: false));
  }

  /// update status by status id
  /// Status id system is:
  /// 1. Chờ xác nhận
  /// 2. Chờ NPT xác nhận
  /// 3. NPT từ chối
  /// 4. Đã xác nhận
  /// 5. Hoàn thành
  /// 6. Từ chối
  /// 7. Từ chối nhận
  ///
  /// Response is [OrderSystemUpdateStatusOutput]
  Future<void> updateStatus(int status) async {
    if (state.typeOrder == TypeOrder.cHTH) {
      final input = OrderUpdateStatusInput(
        id: state.orderDetail?.id ?? 0,
        status: status,
      );
      final res = await _orderUpdateStatusUseCase.execute(input);
      if (res.response.code == 200) {
        emit(state.copyWith(isLoading: true));
        await initData(
          state.data,
          state.typeOrder!,
          state.isDrafOrder,
        );
      }
      return;
    }
    final input = OrderSystemUpdateStatusInput(
      id: state.orderDetail?.id ?? 0,
      status: status,
    );
    final res = await _orderSystemUpdateStatusUseCase.execute(input);
    if (res.response.code == 200) {
      emit(state.copyWith(isLoading: true));
      await initData(
        state.data,
        state.typeOrder!,
        state.isDrafOrder,
      );
    }
  }

  Future<void> confirmOrderOnline(BuildContext context) async {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => ConfirmPaymentBts(
        onConfirm: (TypePayment typePayment) async {
          switch (typePayment) {
            case TypePayment.qrCode:
              renderQrCode(context);
              break;
            default:
              Navigator.of(context).pop();
              updateStatus(4);
          }
        },
        totalPrice: state.orderDetail?.total ?? 0,
      ),
    );
  }

  Future<void> renderQrCode(BuildContext context) async {
    final cardBank = await getIt.get<CardBankCubit>().getCard();
    if (cardBank == null || state.orderDetail?.id == null) {
      return;
    }
    final input = OrderQrcodeInput(
      cardId: cardBank.id ?? 0,
      orderId: state.orderDetail!.id!,
    );
    final res = await _orderQrcodeUseCase.execute(input);
    if (state.orderDetail != null && context.mounted) {
      context.router.push(
        QrCodePaymentRoute(
          qrcodeInfo: res.response.data,
          cardEntity: cardBank,
          orderDetailEntity: state.orderDetail!,
          onConfirm: () {
            updateStatus(4);
            context.router.push(
              OrderDetailRoute(
                order: state.orderDetail!.id!,
                typeOrder: TypeOrder.cHTH,
              ),
            );
          },
        ),
      );
    }
  }

  Future<void> cancelOrder(BuildContext context) async {
    DialogUtils.showLoadingDialog(
      context,
      content: 'Đang huỷ đơn, vui lòng đợi',
    );
    if (state.typeOrder == TypeOrder.ad) {
      final input = OrderCancelInput(
        order: state.orderDetail?.id ?? 0,
        reason: state.idReasonDeny ?? 1,
        title: state.titleReason,
      );
      final res = await _orderCancelUseCase.execute(input);
      if (res.response.code == 200) {
        emit(state.copyWith(isLoading: true));
        await initData(
          state.data,
          state.typeOrder!,
          state.isDrafOrder,
        );
        Navigator.of(context).pop();
      }
      return;
    }
  }
}
