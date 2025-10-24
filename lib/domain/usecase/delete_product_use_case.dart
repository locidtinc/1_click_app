import 'package:injectable/injectable.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/domain/repository/product_repository.dart';
import 'package:one_click/domain/usecase/base/base_use_case.dart';
import 'package:one_click/domain/usecase/base/io/base_input.dart';

@injectable
class DeleteProductUseCase
    extends BaseUseCaseInput<DeleteProductInput, BaseResponseModel<bool>> {
  DeleteProductUseCase(this._productRepository);

  final ProductRepository _productRepository;

  @override
  Future<BaseResponseModel<bool>> execute(DeleteProductInput input) async {
    final result = await _productRepository.deleteProduct(input.productId);
    return result;
  }
}

class DeleteProductInput extends BaseInput {
  int productId;

  DeleteProductInput(this.productId);
}
