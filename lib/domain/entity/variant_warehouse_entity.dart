import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:one_click/domain/entity/batch_entity.dart';
import 'package:one_click/shared/constants/pref_keys.dart';

part 'variant_warehouse_entity.freezed.dart';

@freezed
class VariantWarehouseEntity with _$VariantWarehouseEntity {
  const VariantWarehouseEntity._();

  const factory VariantWarehouseEntity({
    @Default(0) int id,
    @Default('') String code,
    @Default('') String name,
    @Default(PrefKeys.imgProductDefault) String image,
    @Default(0) int amount,
    @Default(0) int priceImport,
    @Default([]) List<BatchEntity> batchs,
  }) = _VariantWarehouseEntity;
}
