
import 'package:freezed_annotation/freezed_annotation.dart';
part 'warehouse_entity.freezed.dart';
@freezed
class WarehouseEntity with _$WarehouseEntity {
  const WarehouseEntity._();
  const factory WarehouseEntity({
    @Required() int? id,
  }) = _WarehouseEntity;
}