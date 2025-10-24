import 'package:injectable/injectable.dart';
import 'package:one_click/domain/entity/product_detail_entity.dart';
import 'package:one_click/domain/repository/product_repository.dart';
import 'package:one_click/domain/usecase/base/future/base_future_use_case.dart';

import 'base/io/base_input.dart';
import 'base/io/base_output.dart';

@injectable
class ProductGetBarcodeItemUseCase extends BaseFutureUseCase<
    ProductBarcodeDetailInput, ProductBarcodeDetailOutput> {
  ProductGetBarcodeItemUseCase(this._productRepository);

  final ProductRepository _productRepository;

  @override
  Future<ProductBarcodeDetailOutput> buildUseCase(
      ProductBarcodeDetailInput input) async {
    final response =
        await _productRepository.getProductDetailV2(productId: input.productId);
    return ProductBarcodeDetailOutput(response);
  }
}

class ProductBarcodeDetailInput extends BaseInput {
  ProductBarcodeDetailInput(this.productId);

  final int productId;
}

class ProductBarcodeDetailOutput extends BaseOutput {
  ProductBarcodeDetailOutput(this.productDetailEntity);

  ProductDetailEntity productDetailEntity;
}
