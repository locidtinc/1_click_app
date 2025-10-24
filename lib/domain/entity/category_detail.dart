import 'package:freezed_annotation/freezed_annotation.dart';
part 'category_detail.freezed.dart';

@freezed
class CategoryDetailEntity with _$CategoryDetailEntity {
  const CategoryDetailEntity._();

  const factory CategoryDetailEntity({
    @Required() int? id,
    @Default('') String title,
    @Default('') String code,
    @Default(null) int? system,
    @Default(null) int? account,
    @Default([]) List<int> group,
    @Default([]) List<int> product,
    @Default([]) List<GroupCategoryEntity>? groupData,
    @Default(false) bool isSystemAd,
    final int? productgroupQuantity,
    final DateTime? createdAt,
  }) = _CategoryDetailEntity;
}

@freezed
class GroupCategoryEntity with _$GroupCategoryEntity {
  const GroupCategoryEntity._();

  const factory GroupCategoryEntity({
    @Required() int? id,
    @Default('') String title,
    @Default('') String code,
    @Default(0) int productQuantity,
  }) = _GroupCategoryEntity;
}
