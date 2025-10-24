import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:one_click/domain/entity/brand_detail_entity.dart';

part 'brand_edit_state.freezed.dart';

@freezed
class BrandEditState with _$BrandEditState {
  const factory BrandEditState({
    @Default(BrandDetailEntity()) BrandDetailEntity? brand,
  }) = _BrandEditState;
}
