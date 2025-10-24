import 'package:injectable/injectable.dart';
import 'package:one_click/domain/entity/product_preview.dart';
import 'package:one_click/domain/usecase/base/future/base_future_use_case.dart';
import 'package:one_click/domain/usecase/base/io/base_input.dart';

import '../repository/product_repository.dart';
import 'base/io/base_output.dart';

@injectable
class ProductPreviewUseCase
    extends BaseFutureUseCase<ProductPreviewInput, ProductPreviewOutput> {
  ProductPreviewUseCase(this._productRepository);

  final ProductRepository _productRepository;

  @override
  Future<ProductPreviewOutput> buildUseCase(ProductPreviewInput input) async {
    final res = await _productRepository.getList(
      page: input.page,
      limit: input.limit,
      keySearch: input.keySearch,
      barcode: input.barcode,
      account: input.account,
      brandIsnull: input.brandIsnull,
      systemCode: input.systemCode,
      statusOnline: input.statusOnline,
      statusProduct: input.statusProduct,
      variantAmountWarehouse: input.variantAmountWarehouse,
      excludeVariantAmountWarehouse: input.excludeVariantAmountWarehouse,
      warehouseId: input.warehouseId,
    );
    return ProductPreviewOutput(res);
  }

  Future<ProductPreviewOutput> prdSuggest(ProductPreviewInput input) async {
    final res = await _productRepository.getProductSuggest(
      page: input.page,
      limit: input.limit,
      keySearch: input.keySearch,
      barcode: input.barcode,
      search: input.search,
      account: input.account,
      brandIsnull: input.brandIsnull,
      systemCode: input.systemCode,
      statusOnline: input.statusOnline,
      statusProduct: input.statusProduct,
      variantAmountWarehouse: input.variantAmountWarehouse,
      excludeVariantAmountWarehouse: input.excludeVariantAmountWarehouse,
      warehouseId: input.warehouseId,
    );
    return ProductPreviewOutput(res);
  }
}

class ProductPreviewInput extends BaseInput {
  final int page;
  final int limit;
  final String keySearch;
  final String? barcode;
  final int? account;
  final bool? brandIsnull;
  final String? systemCode;
  final String? search;

  ///id warehouse account
  final int? variantAmountWarehouse;
  final int? warehouseId;
  final int? excludeVariantAmountWarehouse;
  final String? statusOnline;
  final bool? statusProduct;
  ProductPreviewInput({
    required this.keySearch,
    required this.limit,
    required this.page,
    this.account,
    this.barcode,
    this.brandIsnull,
    this.systemCode,
    this.variantAmountWarehouse,
    this.excludeVariantAmountWarehouse,
    this.statusOnline,
    this.statusProduct,
    this.warehouseId,
    this.search,
  });
}

class ProductPreviewOutput extends BaseOutput {
  ProductPreviewOutput(this.listProduct);
  final List<ProductPreviewEntity> listProduct;
}
