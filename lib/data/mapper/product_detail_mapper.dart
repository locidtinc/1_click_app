import 'package:injectable/injectable.dart';
import 'package:one_click/data/mapper/base/base_data_mapper.dart';
import 'package:one_click/data/models/product_model.dart';
import 'package:one_click/domain/entity/product_detail_entity.dart';
import 'package:one_click/shared/constants/pref_keys.dart';

import '../../domain/entity/product_payload.dart';

@injectable
class ProductDetailMapper
    extends BaseDataMapper<ProductModel, ProductDetailEntity> {
  @override
  ProductDetailEntity mapToEntity(ProductModel? data) {
    return ProductDetailEntity(
      id: data?.id,
      title: data?.title ?? '',
      code: data?.code ?? '',
      barcode: data?.barcode ?? '',
      priceImport: data?.priceImport ?? 0,
      priceSell: data?.priceSell ?? 0,
      isAdminCreated: data?.systemData?.code == 'ADMIN' ? true : false,
      brand: data?.brandData != null && data!.brandData!.isNotEmpty
          ? data.brandData!.first.title
          : '',
      brandId: data?.brandData != null && data!.brandData!.isNotEmpty
          ? data.brandData!.first.id
          : null,
      description: data?.description ?? '',
      images: data?.mediaData != null && data!.mediaData!.isNotEmpty
          ? data.mediaData!.map((e) => e.image ?? '').toList()
          : [],
      mediaData: (data?.mediaData ?? [])
          .map(
            (e) => MediaDataEntity(
              id: e.id,
              image: e.image ?? PrefKeys.imgProductDefault,
              alt: e.alt ?? '',
            ),
          )
          .toList(),
      productCategory:
          data?.productCategory != null && data!.productCategory!.isNotEmpty
              ? data.productCategory!.first.title
              : '',
      categoryId:
          data?.productCategory != null && data!.productCategory!.isNotEmpty
              ? data.productCategory!.first.id
              : null,
      productGroup: data?.productGroup != null && data!.productGroup!.isNotEmpty
          ? data.productGroup!.first.title
          : '',
      groupId: data?.productGroup != null && data!.productGroup!.isNotEmpty
          ? data.productGroup!.first.id
          : null,
      codeSystemData:
          data?.systemData != null ? data!.systemData!.code ?? '' : '',
      properties: data?.properties() ?? [],
      statusOnline: data?.statusOnline ?? true,
      statusProduct: data?.statusProduct ?? true,
      variant: data?.variantData != null
          ? data!.variantData!
              .map(
                (variant) => VariantResponseEntity(
                  id: variant.id ?? 0,
                  priceSell: variant.priceSell ?? 0,
                  priceImport: variant.priceImport ?? 0,
                  code: variant.code ?? '',
                  title: variant.title ?? '',
                  options: variant.optionsData != null
                      ? variant.optionsData!
                          .map(
                            (option) => OptionPayloadEntity(
                              title: option.title ?? '',
                              values: option.values ?? '',
                            ),
                          )
                          .toList()
                      : [],
                  quantity: variant.quantity?.round() ?? 0,
                  status: variant.status ?? false,
                  image: variant.image ?? '',
                  variant_mykios: variant.variantMykios ?? false,
                ),
              )
              .toList()
          : [],
    );
  }
}
