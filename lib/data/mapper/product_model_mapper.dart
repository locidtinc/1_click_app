import 'package:injectable/injectable.dart';
import 'package:one_click/data/mapper/base/base_data_mapper.dart';
import 'package:one_click/data/models/product_model.dart';
import 'package:one_click/domain/entity/product_preview.dart';

@injectable
class ProductModelMapper
    extends BaseDataMapper<ProductModel, ProductPreviewEntity> {
  @override
  ProductPreviewEntity mapToEntity(ProductModel? data) {
    return ProductPreviewEntity(
      id: data?.id ?? 0,
      imageUrl: data?.mediaData != null && data!.mediaData!.isNotEmpty
          ? data.mediaData!.first.image!
          : '',
      barcode: data?.barcode ?? '',
      productName: data?.title ?? '',
      productCode: data?.code ?? '',
      productPrice: data?.priceSell?.round() ?? 1,
      priceImport: data?.priceImport?.round() ?? 1,
      isAdminCreated: data?.systemData?.code == 'ADMIN' ? true : false,
      brandName: (data?.brandData?.isNotEmpty ?? false)
          ? data?.brandData![0].title
          : null,
      brandId: (data?.brandData?.isNotEmpty ?? false)
          ? data?.brandData![0].id
          : null,
      groupName: (data?.productGroup?.isNotEmpty ?? false)
          ? data?.productGroup![0].title
          : null,
      groupId: (data?.productGroup?.isNotEmpty ?? false)
          ? data?.productGroup![0].id
          : null,
    );
  }
}
