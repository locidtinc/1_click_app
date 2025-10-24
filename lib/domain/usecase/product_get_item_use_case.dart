import 'package:injectable/injectable.dart';
import 'package:one_click/domain/entity/product_detail_entity.dart';
import 'package:one_click/domain/repository/product_repository.dart';
import 'package:one_click/domain/usecase/base/future/base_future_use_case.dart';

import 'base/io/base_input.dart';
import 'base/io/base_output.dart';

@injectable
class ProductGetItemUseCase
    extends BaseFutureUseCase<ProductDetailInput, ProductDetailOutput> {
  ProductGetItemUseCase(this._productRepository);

  final ProductRepository _productRepository;

  @override
  Future<ProductDetailOutput> buildUseCase(ProductDetailInput input) async {
    final response =
        await _productRepository.getProductDetailV2(productId: input.productId);
    return ProductDetailOutput(response);
  }
}

class ProductDetailInput extends BaseInput {
  ProductDetailInput(this.productId);

  final int productId;
}

class ProductDetailOutput extends BaseOutput {
  ProductDetailOutput(this.productDetailEntity);

  ProductDetailEntity productDetailEntity;
}
