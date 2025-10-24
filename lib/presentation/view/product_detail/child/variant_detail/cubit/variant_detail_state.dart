import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:one_click/domain/entity/product_shipments_entity.dart';
import 'package:one_click/domain/entity/shipments_infor_entity.dart';
import 'package:one_click/domain/entity/variant_entity.dart';

part 'variant_detail_state.freezed.dart';

@freezed
class VariantDetailState with _$VariantDetailState {
  const factory VariantDetailState({
    @Default(VariantEntity()) VariantEntity? variantEntity,
    @Default(ShipmentsInforEntity()) ShipmentsInforEntity? shipmentsInfor,
    @Default([]) List<ProductShipmentsEntity>? listProductShipments,
  }) = _VariantDetailState;
}
