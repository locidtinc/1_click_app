import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:one_click/domain/entity/brand_detail_entity.dart';

part 'brand_detail_state.freezed.dart';

@freezed
class BrandDetailState with _$BrandDetailState {
  const factory BrandDetailState({
    @Default(BrandDetailEntity()) BrandDetailEntity brandDetail,
  }) = _BrandDetailState;
}
