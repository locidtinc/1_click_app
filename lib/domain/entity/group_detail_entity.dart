import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:one_click/domain/entity/product_preview.dart';

part 'group_detail_entity.freezed.dart';

@freezed
class GroupDetailEntity with _$GroupDetailEntity {
  const factory GroupDetailEntity({
    int? id,
    @Default('') String title,
    @Default('') String code,
    @Default(0) int account,
    @Default(false) bool isAdminCreated,
    List<String>? category,
    @Default(1) int productCategory,
    @Default(<ProductPreviewEntity>[]) List<ProductPreviewEntity> products,
  }) = _GroupDetailEntity;
}
