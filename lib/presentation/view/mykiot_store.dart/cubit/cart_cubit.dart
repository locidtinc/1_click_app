import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../domain/entity/cart_entity.dart';
import '../../../../shared/constants/local_storage/app_shared_preference.dart';
import '../../../../shared/constants/pref_keys.dart';
import 'cart_state.dart';

@lazySingleton
class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState());

  void initData() {
    final List<String>? carts =
        AppSharedPreference.instance.getStringList(PrefKeys.cart);
    print(carts);
    final listCart =
        carts?.map((item) => CartEntity.fromJson(json.decode(item))).toList() ??
            [];
    print(state.carts);
    emit(state.copyWith(carts: listCart));
  }
}
