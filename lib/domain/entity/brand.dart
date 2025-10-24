import 'package:freezed_annotation/freezed_annotation.dart';

part 'brand.freezed.dart';

@freezed
class BrandEntity with _$BrandEntity {
  const BrandEntity._();

  const factory BrandEntity({
    @Required() int? id,
    @Default(null) String? image,
    @Default('') String title,
    @Default(false) bool isSystem,
    @Default('') String code,
    @Default(<int>[]) List<int> products,
    @Default(<int>[]) List<int> groups,
    @Default(0) int productGroupQuantity,
  }) = _BrandEntity;
}
