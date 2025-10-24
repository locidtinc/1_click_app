import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../domain/entity/promotion_type.dart';

part 'promotion_state.freezed.dart';


@freezed
class PromotionState with _$PromotionState {
  const factory PromotionState({
    @Default(<PromotionTypeEntity>[]) List<PromotionTypeEntity> listType,
  }) = _PromotionState;
}
