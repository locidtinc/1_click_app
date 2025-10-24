import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/domain/entity/cart_entity.dart';
import 'package:one_click/domain/entity/order_import_create.dart';
import 'package:one_click/domain/usecase/order_create_use_case.dart';
import 'package:one_click/presentation/routers/router.gr.dart';
import 'package:one_click/presentation/view/order_create/cubit/order_create_state.dart';
import 'package:one_click/presentation/view/shopping_cart/cubit/shopping_cart_state.dart';
import 'package:one_click/shared/constants/local_storage/app_shared_preference.dart';
import 'package:one_click/shared/constants/pref_keys.dart';
import 'package:one_click/shared/ext/index.dart';

import '../../../../domain/entity/order_create.dart';

@injectable
class ShoppingCartCubit extends Cubit<ShoppingCartState> {
  ShoppingCartCubit(this._orderCreateUseCase)
      : super(const ShoppingCartState());

  final OrderCreateUseCase _orderCreateUseCase;

  void getListProduct() async {
    final List<String>? carts =
        AppSharedPreference.instance.getStringList(PrefKeys.cart);
    final listCart =
        carts?.map((item) => CartEntity.fromJson(json.decode(item))).toList() ??
            [];
    emit(state.copyWith(listCart: listCart));
  }

  int countCart() {
    final List<String>? carts =
        AppSharedPreference.instance.getStringList(PrefKeys.cart);
    final listCart =
        carts?.map((item) => CartEntity.fromJson(json.decode(item))).toList() ??
            [];
    emit(state.copyWith(listCart: listCart));
    return listCart.length;
  }

  void addToCart(CartEntity cart) {
    final List<String>? carts =
        AppSharedPreference.instance.getStringList(PrefKeys.cart);
    final listCart =
        carts?.map((item) => CartEntity.fromJson(json.decode(item))).toList() ??
            [];
    final index =
        listCart.indexWhere((e) => e.variant.code == cart.variant.code);
    switch (index) {
      case -1:
        listCart.add(cart);
        _saveDB(listCart);
        break;
      default:
        listCart.removeAt(index);
        final cartNew = CartEntity(
          quantity: cart.quantity + listCart[index].quantity,
          discount: cart.discount,
          variant: cart.variant,
        );
        listCart.add(cartNew);
        _saveDB(listCart);
    }
    // print(listCart.length);
    // if (listCart.isEmpty) {
    //   listCart.add(cart);
    //   _saveDB(listCart);
    //   return;
    // }
    // if (listCart.isNotEmpty) {
    // for (var i = 0; i < listCart.length; i++) {
    //   final item = listCart[i];
    //   if (cart.variant.code == item.variant.code) {
    //     print(cart.variant.code);
    //     print(item.variant.code);
    //     listCart.remove(item);
    //     print(item);
    //     final cartNew = CartEntity(
    //       quantity: cart.quantity + item.quantity,
    //       discount: cart.discount,
    //       variant: cart.variant,
    //     );
    //     listCart.add(cartNew);
    //   } else {
    //     listCart.add(cart);
    //   }
    // }
    // }
    print(listCart.length);
    _saveDB(listCart);
    emit(state.copyWith(listCart: listCart));
  }

  void _saveDB(List<CartEntity> listCart) async {
    final List<String> usrList =
        listCart.map((item) => jsonEncode(item.toJson())).toList();
    await AppSharedPreference.instance.setStringList(PrefKeys.cart, usrList);
  }

  void deleteVariant(int index) {
    final List<String>? carts =
        AppSharedPreference.instance.getStringList(PrefKeys.cart);
    final listCart =
        carts?.map((item) => CartEntity.fromJson(json.decode(item))).toList() ??
            [];
    listCart.removeAt(index);
    emit(state.copyWith(listCart: listCart));
    _saveDB(listCart);
    _calculateTotal();
  }

  void onChangeCheckbox(bool? value, int index) {
    if (value == null) return;
    final List<CartEntity> list = [...state.listCart];
    list[index] = list[index].copyWith(chose: value);
    emit(state.copyWith(listCart: list));
    _calculateTotal();
  }

  void onTapCheckAll(bool? value) {
    if (value == null) return;
    emit(state.copyWith(checkAll: value));
    final List<CartEntity> list = [];
    for (var item in state.listCart) {
      item = item.copyWith(chose: value);
      list.add(item);
    }
    emit(state.copyWith(listCart: list));
    _calculateTotal();
  }

  void onTapReduced(int quantity, int index) {
    final List<CartEntity> list = [...state.listCart];
    list[index] = list[index].copyWith(quantity: quantity);
    emit(state.copyWith(listCart: list));
    _calculateTotal();
  }

  void onTapIncremented(int quantity, int index) {
    final List<CartEntity> list = [...state.listCart];
    list[index] = list[index].copyWith(quantity: quantity);
    emit(state.copyWith(listCart: list));
    _calculateTotal();
  }

  void orderProduct(BuildContext context) async {
    DialogUtils.showLoadingDialog(
      context,
      content: 'Đang tiến hành đặt hàng, vui lòng đợi!',
    );
    final List<CartEntity> listSelected =
        state.listCart.where((element) => element.chose == true).toList();
    final res = await _orderCreateUseCase.execute(
      OrderCreateInput(
        orderImportCreateEntity: OrderImportCreateEntity(
          order: OrderImportInfoCreate(
            discount: (state.totalDefault - state.total).toString(),
            total: state.totalDefault.toString(),
          ),
          orderitem: listSelected
              .map(
                (item) => Orderitem(
                  variant: item.variant.id,
                  price: item.variant.priceSell.toInt(),
                  quantity: item.quantity,
                  discount: item.discount,
                ),
              )
              .toList(),
        ),
      ),
    );
    if (context.mounted) {
      Navigator.of(context).pop();
    }
    if (res.response.code == 200 && context.mounted) {
      for (int i = 0; i < listSelected.length; i++) {
        _deleteItemPaid(listSelected[i]);
      }
      DialogUtils.showSuccessDialog(
        context,
        content: 'Tạo đơn hàng thành công',
        titleConfirm: 'Chi tiết đơn',
        titleClose: 'Danh sách đơn',
        accept: () {
          context.pop();
          context.router.push(const OrderImportRoute());
          context.router.push(
            OrderDetailRoute(
              order: res.response.data!,
              typeOrder: TypeOrder.ad,
            ),
          );
        },
        close: () {
          context.pop();
          context.router.push(const OrderImportRoute());
        },
      );
    } else {
      DialogUtils.showErrorDialog(
        context,
        content: 'Đặt hàng thất bại, vui lòng kiểm tra tồn kho',
      );
    }
  }

  void _calculateTotal() {
    final double totalSell = state.listCart.fold(0, (total, item) {
      if (item.chose) {
        print(item.variant.priceSell);
        total += item.quantity * item.variant.priceSell;
      }
      return total;
    });
    final double totalDefault = state.listCart.fold(0, (total, item) {
      if (item.chose) {
        print(item.variant.priceSellDefault);
        total += item.quantity * item.variant.priceSellDefault;
      }
      return total;
    });
    final checkAll = _checkList();
    print(totalSell);
    print(totalDefault);
    emit(
      state.copyWith(
        total: totalSell,
        totalDefault: totalDefault,
        checkAll: checkAll,
      ),
    );
  }

  bool _checkList() {
    return state.listCart.where((element) => element.chose == true).length ==
        state.listCart.length;
  }

  void _deleteItemPaid(CartEntity listPaid) async {
    try {
      final listCart = List<CartEntity>.from(state.listCart);

      listCart.remove(listPaid);
      emit(state.copyWith(listCart: listCart));

      _saveDB(listCart);
      _calculateTotal();
    } catch (e) {
      print(e);
    }
  }
}
