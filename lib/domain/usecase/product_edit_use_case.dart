import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/domain/repository/product_repository.dart';
import 'package:one_click/domain/usecase/base/future/base_future_use_case.dart';
import 'package:one_click/domain/usecase/base/io/base_input.dart';
import 'package:one_click/domain/usecase/base/io/base_output.dart';

@injectable
class ProductEditUseCase
    extends BaseFutureUseCase<ProductEditInput, ProductEditOutput> {
  final ProductRepository _productRepository;

  ProductEditUseCase(this._productRepository);

  @override
  Future<ProductEditOutput> buildUseCase(ProductEditInput input) async {
    final res = await _productRepository.editProduct(
      input.productPayloadEntity,
      input.id,
    );
    return ProductEditOutput(res);
  }
}

class ProductEditInput extends BaseInput {
  final FormData productPayloadEntity;
  final int id;
  ProductEditInput(this.productPayloadEntity, this.id);
}

class ProductEditOutput extends BaseOutput {
  final BaseResponseModel res;
  ProductEditOutput(this.res);
}
