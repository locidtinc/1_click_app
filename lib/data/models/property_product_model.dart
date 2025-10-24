import 'package:freezed_annotation/freezed_annotation.dart';
part 'property_product_model.freezed.dart';
part 'property_product_model.g.dart';

@freezed
class ProductProperty with _$ProductProperty {
  const factory ProductProperty({
    @Default('') String title,
    @Default([]) List<String> childProperties,
  }) = _ProductProperty;

  factory ProductProperty.fromJson(Map<String, dynamic> json) =>
      _$ProductPropertyFromJson(json);
}
