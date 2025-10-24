import 'package:freezed_annotation/freezed_annotation.dart';
part 'product_edit_properties.freezed.dart';

@freezed
class ProductEditPropertiesEntity with _$ProductEditPropertiesEntity {
  const ProductEditPropertiesEntity._();

  const factory ProductEditPropertiesEntity({
    @Default('') String name,
    @Default([]) List<String> value,
    @Default([]) List<String> newValue,
  }) = _ProductEditPropertiesEntity;
}
