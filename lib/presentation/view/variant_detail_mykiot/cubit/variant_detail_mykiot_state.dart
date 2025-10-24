import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../domain/entity/variant_entity.dart';

part 'variant_detail_mykiot_state.freezed.dart';

@freezed
class VariantDetailMykiotState with _$VariantDetailMykiotState {
  const factory VariantDetailMykiotState({
    @Default(VariantEntity()) VariantEntity? variantEntity,
  }) = _VariantDetailMykiotState;
}
