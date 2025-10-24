import 'package:injectable/injectable.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/domain/repository/category_repository.dart';
import 'package:one_click/domain/usecase/base/base_use_case.dart';

@injectable
class DeleteProductItemUseCase
    extends BaseUseCaseInput<ProductItemInput, BaseResponseModel<bool>> {
  DeleteProductItemUseCase(this._repository);

  final CategoryRepository _repository;

  @override
  Future<BaseResponseModel<bool>> execute(ProductItemInput input) async {
    final res = await _repository.deleteProductItem(input.id, input.endPoint);
    return res;
  }
}

class ProductItemInput {
  ProductItemInput(this.id, this.endPoint);

  int id;
  String endPoint;
}
