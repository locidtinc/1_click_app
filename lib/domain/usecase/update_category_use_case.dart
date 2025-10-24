import 'package:injectable/injectable.dart';
import 'package:one_click/data/models/category_model.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/domain/repository/product_category_repository.dart';
import 'package:one_click/domain/usecase/base/base_use_case.dart';

@injectable
class UpdateCategoryUseCase extends BaseUseCaseInput<UpdateCategoryInput,
    BaseResponseModel<CategoryDetailModel>> {
  UpdateCategoryUseCase(this._repository);

  final ProductCategoryRepository _repository;

  @override
  Future<BaseResponseModel<CategoryDetailModel>> execute(
    UpdateCategoryInput input,
  ) async {
    final res = await _repository.updateProductCategory(
      input.id,
      input.title,
      input.groups,
    );
    return res;
  }
}

class UpdateCategoryInput {
  UpdateCategoryInput(this.id, this.title, this.groups);

  int id;
  String title;
  List<int> groups;
}
