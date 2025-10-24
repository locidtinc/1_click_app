import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:one_click/domain/entity/variant_entity.dart';

import 'option_data.dart';
part 'variant_create_order.freezed.dart';
part 'variant_create_order.g.dart';

@freezed
class VariantCreateOrderEntity with _$VariantCreateOrderEntity {
  const VariantCreateOrderEntity._();

  const factory VariantCreateOrderEntity({
    @Required() int? id,
    @Default('') String? image,
    @Default('') String title,
    @Default('') String code,
    @Default('') String price,
    @Default(0) int amount,
    @Default(0) int inventory,
    @Default(false) bool isChoose,
    @Default(0) int priceSell,
    @Default(0) int priceSellDefault,
    @Default(<OptionDataEntity>[]) List<OptionDataEntity> optionsData,
    @Default(null) PromotionItemEntity? promotionItem,
    @Default(true) bool status,
  }) = _VariantCreateOrderEntity;

  factory VariantCreateOrderEntity.fromJson(Map<String, dynamic> json) =>
      _$VariantCreateOrderEntityFromJson(json);
}
