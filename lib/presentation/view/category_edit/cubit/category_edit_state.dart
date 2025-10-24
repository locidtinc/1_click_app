import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:one_click/domain/entity/category_detail_entity.dart';

part 'category_edit_state.freezed.dart';

@freezed
class CategoryEditState with _$CategoryEditState {
  const factory CategoryEditState({
    CategoryDetailEntity? category,
    String? productGroup,
  }) = _CategoryEditState;
}
