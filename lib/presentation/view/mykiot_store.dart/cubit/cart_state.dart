import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../domain/entity/cart_entity.dart';
part 'cart_state.freezed.dart';


@freezed
class CartState with _$CartState {
  const factory CartState({
    @Default(<CartEntity>[]) List<CartEntity> carts,
    @Default(0) int countCart,
  }) = _CartState;
}
