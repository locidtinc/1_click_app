import 'package:injectable/injectable.dart';
import 'package:one_click/data/mapper/base/base_data_mapper.dart';
import 'package:one_click/data/models/variant_model.dart';
import 'package:one_click/domain/entity/unit_entity.dart';
import 'package:one_click/domain/entity/variant_entity.dart';

@injectable
class VariantDetailMapper extends BaseDataMapper<VariantModel, VariantEntity> {
  @override
  VariantEntity mapToEntity(VariantModel? data) {
    final listPromotionActive = (data?.promotionItemData?.where(
      (element) => (element.promotionData?.status == true &&
          element.promotionData?.statusStop == false),
    ));
    return VariantEntity(
      id: data?.id ?? 0,
      title: data?.title ?? '',
      code: data?.code ?? '',
      barCode: data?.barcode ?? '',
      priceSell: (listPromotionActive?.isEmpty == true)
          ? data?.priceSell ?? 0
          : (listPromotionActive!.first.typeDiscountData?.code == 'GTP')
              ? (data?.priceSell ?? 0) *
                  (100 - (listPromotionActive.first.discount ?? 0)) /
                  100
              : (data?.priceSell ?? 0) -
                  (listPromotionActive.first.discount ?? 0),
      priceSellDefault: data?.priceSell ?? 0,
      priceImport: data?.priceImport ?? 0,
      amount: (data?.quantityInStock ?? 0).round(),
      productData: ProductDataEntity(
        id: data?.productData?.id ?? 0,
        code: data?.productData?.code ?? '',
        title: data?.productData?.title ?? '',
        image: (data?.productData?.image?.isNotEmpty ?? false)
            ? (data?.productData?.image?.first.image ?? '')
            : '',
        brand: data!.productData?.brandData != null &&
                data.productData!.brandData!.isNotEmpty
            ? data.productData!.brandData!.first.title
            : '',
        category: data.productData?.productCategory != null &&
                data.productData!.productCategory!.isNotEmpty
            ? data.productData!.productCategory!.first.title
            : '',
        group: data.productData?.productGroup != null &&
                data.productData!.productGroup!.isNotEmpty
            ? data.productData!.productGroup!.first.title
            : '',
        priceSell: data.productData?.priceSell ?? 0,
      ),
      image: data.image ?? '',
      status: data.status ?? false,
      promotion: (listPromotionActive?.isNotEmpty ?? false)
          ? PromotionItemEntity(
              promotion: listPromotionActive?.firstOrNull?.promotion ?? 1,
              quantity: listPromotionActive?.firstOrNull?.quantity ?? 0,
              discount: listPromotionActive?.firstOrNull?.discount ?? 0,
              typeDiscount:
                  listPromotionActive?.firstOrNull?.typeDiscountData?.code ==
                          'GTP'
                      ? 2
                      : 1,
            )
          : null,
      variantMykios: data.variantMykios ?? false,
      quantityInStock: data.quantityInStock,
      unit: data.unit != null
          ? data.unit!
              .map(
                (e) => UnitEntity(
                  id: e.id,
                  conversionValue: e.conversionValue?.toInt(),
                  level: e.level,
                  sellUnit: e.sellUnit,
                  storageUnit: e.storageUnit,
                  title: e.title,
                ),
              )
              .toList()
          : <UnitEntity>[],
    );
  }
}
