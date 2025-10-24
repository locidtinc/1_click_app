import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:one_click/domain/entity/cart_entity.dart';

part 'shopping_cart_state.freezed.dart';

@freezed
class ShoppingCartState with _$ShoppingCartState {
  const factory ShoppingCartState({
    @Default(<CartEntity>[]) List<CartEntity> listCart,
    @Default(0) double total,
    @Default(0) double totalDefault,
    @Default(false) bool checkAll,
  }) = _ShoppingCartState;
}
