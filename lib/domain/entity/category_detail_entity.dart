import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:one_click/domain/entity/group_entity.dart';

part 'category_detail_entity.freezed.dart';

@freezed
class CategoryDetailEntity with _$CategoryDetailEntity {
  const factory CategoryDetailEntity({
    @Default(0) int id,
    @Default('') String title,
    @Default(0) int account,
    @Default(false) bool isSystem,
    @Default(<GroupEntity>[]) List<GroupEntity> groups,
  }) = _CategoryDetailEntity;
}
