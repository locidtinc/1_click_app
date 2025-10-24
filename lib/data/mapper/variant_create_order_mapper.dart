import 'package:injectable/injectable.dart';
import 'package:one_click/data/mapper/base/base_data_mapper.dart';
import 'package:one_click/data/models/variant_model.dart';
import 'package:one_click/domain/entity/option_data.dart';
import 'package:one_click/domain/entity/variant_create_order.dart';
import 'package:one_click/domain/entity/variant_entity.dart';

import '../models/promotion_item_model.dart';

@injectable
class VariantCreateOrderMapper
    extends BaseDataMapper<VariantModel, VariantCreateOrderEntity> {
  @override
  VariantCreateOrderEntity mapToEntity(VariantModel? data) {
    final PromotionItemModel? promotion =
        (data?.promotionItemSystem?.isNotEmpty ?? false)
            ? data?.promotionItemSystem![0]
            : null;

    return VariantCreateOrderEntity(
      image: data?.image,
      title: data?.title ?? '',
      code: data?.code ?? '',
      amount: 1,
      priceSellDefault: data?.priceSell!.round() ?? 0,
      priceSell: promotion?.typeDiscount == 1
          ? ((data?.priceSell ?? 0) - (promotion?.discount ?? 0)).round()
          : ((data?.priceSell ?? 0) * (100 - (promotion?.discount ?? 0)) / 100)
              .round(), // data?.priceSell!.round() ?? 0,
      id: data?.id,
      inventory: (data?.quantityInStock ?? 0.0).round(),
      optionsData: (data?.optionsData ?? [])
          .map(
            (e) => OptionDataEntity(
              id: e.id ?? 0,
              title: e.title ?? '',
              code: e.code,
              values: e.values ?? '',
              status: e.status ?? false,
            ),
          )
          .toList(),
      promotionItem: (data?.promotionItemData?.isNotEmpty ?? false)
          ? PromotionItemEntity(
              promotion: promotion?.promotion ?? 0,
              discount: (promotion?.discount ?? 0).toDouble(),
              quantity: promotion?.quantity ?? 0,
              typeDiscount: promotion?.typeDiscount ?? 0,
            )
          : null,
    );
  }
}
