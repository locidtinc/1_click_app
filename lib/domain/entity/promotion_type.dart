

import 'package:freezed_annotation/freezed_annotation.dart';
part 'promotion_type.freezed.dart';
@freezed
class PromotionTypeEntity with _$PromotionTypeEntity {
  const PromotionTypeEntity._();
  const factory PromotionTypeEntity({
    @Required() int? id,
    @Default('') String title,
    @Default('') String code,
  }) = _PromotionTypeEntity;
}