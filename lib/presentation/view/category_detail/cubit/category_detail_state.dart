import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:one_click/domain/entity/category_detail_entity.dart';

part 'category_detail_state.freezed.dart';

@freezed
class CategoryDetailState with _$CategoryDetailState {
  const factory CategoryDetailState({
    @Default(CategoryDetailEntity()) CategoryDetailEntity category,
    String? productGroup,
  }) = _CategoryDetailState;
}
