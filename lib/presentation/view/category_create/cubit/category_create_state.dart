import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_create_state.freezed.dart';

@freezed
class CategoryCreateState with _$CategoryCreateState {
  const factory CategoryCreateState({
    @Default('') String title,
  }) = _CategoryCreateState;
}
