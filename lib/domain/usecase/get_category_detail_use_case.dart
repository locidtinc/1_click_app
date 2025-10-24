import 'package:injectable/injectable.dart';
import 'package:one_click/domain/entity/category_detail_entity.dart';
import 'package:one_click/domain/repository/product_category_repository.dart';
import 'package:one_click/domain/usecase/base/base_use_case.dart';

@injectable
class GetCategoryDetailUseCase
    extends BaseUseCaseInput<int, CategoryDetailEntity> {
  GetCategoryDetailUseCase(this._repository);

  final ProductCategoryRepository _repository;

  @override
  Future<CategoryDetailEntity> execute(int input) async {
    final res = await _repository.getProductCategoryDetail(input);
    return res;
  }
}
