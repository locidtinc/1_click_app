import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:one_click/domain/entity/customer.dart';
import 'package:one_click/domain/entity/order_detail.dart';
import 'package:one_click/domain/entity/variant_create_order.dart';

part 'order_create_state.freezed.dart';

@freezed
class OrderCreateState with _$OrderCreateState {
  const factory OrderCreateState({
    @Default(true) bool loadingInit,
    @Default(<VariantCreateOrderEntity>[])
    List<VariantCreateOrderEntity> listVariantSelect,
    @Default(0) int totalPrice,
    @Default(0) int totalPriceDefault,
    @Default('') String note,
    @Default([]) List<CustomerEntity> listCustomer,
    CustomerEntity? selectedCustomer,
    @Default(null) int? customer,
    @Default(10) int limit,
    @Default('') String searchKey,
    @Default(TypeOrder.cHTH) TypeOrder typeOrder,
    @Default(null) FailureCreateOrder? failureCreateOrder,
    @Default(null) OrderDetailEntity? orderDetailEntity,
    @Default(TypePayment.cash) TypePayment typePayment,
  }) = _OrderCreateState;
}

enum TypeOrder { cHTH, ad }

enum FailureCreateOrder {
  inventoryEmpty('Số lượng tồn kho không đủ'),
  inventoryNotEnough('Số lượng tồn kho không đủ'),
  quantity('Số lượng sản phẩm đặt bằng 0');

  const FailureCreateOrder(this.errMsg);

  final String? errMsg;
}

enum TypePayment {
  cash('Tiền mặt'),
  qrCode('QR thanh toán');

  const TypePayment(this.title);

  final String title;
}
