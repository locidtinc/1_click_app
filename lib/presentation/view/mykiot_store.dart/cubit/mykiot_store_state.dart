import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../domain/entity/variant_entity.dart';

part 'mykiot_store_state.freezed.dart';

@freezed
class MykiotStoreState with _$MykiotStoreState {
  const factory MykiotStoreState({
    @Default(10) int limit,
    @Default('') String keySearchPromotion,
    @Default([]) List<VariantEntity> listVariantPromotion,
    @Default([]) List<VariantEntity> listVariantPromotionSearch,
    @Default([]) List<VariantEntity> listVariants,
    @Default([]) List<VariantEntity> listSearch,
    @Default(true) bool isLoadingProductPromotion,
    @Default(true) bool isLoadingProduct,
    @Default(false) bool isLoadingSearch,
    @Default(1) int page,
    @Default(1) int pagePromotion,
  }) = _MykiotStoreState;
}
