import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:one_click/domain/entity/variant_entity.dart';

part 'cart_entity.freezed.dart';

part 'cart_entity.g.dart';

@freezed
class CartEntity with _$CartEntity {
  const factory CartEntity({
    @Default(0) int quantity,
    @Default(VariantEntity()) VariantEntity variant,
    @Default(0) int discount,
    @Default(false) bool chose,
  }) = _CartEntity;

  factory CartEntity.fromJson(Map<String, dynamic> json) =>
      _$CartEntityFromJson(json);
}
