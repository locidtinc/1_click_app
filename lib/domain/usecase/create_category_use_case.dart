import 'package:injectable/injectable.dart';
import 'package:one_click/data/mapper/category_detail_mapper.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/domain/entity/category_detail.dart';
import 'package:one_click/domain/repository/product_category_repository.dart';
import 'package:one_click/domain/usecase/base/base_use_case.dart';

@injectable
class CreateCategoryUseCase extends BaseUseCaseInput<CreateCategoryUseCaseInput,
    BaseResponseModel<CategoryDetailEntity>> {
  CreateCategoryUseCase(
    this._repository,
    this._categoryDetailEntityMapper,
  );

  final ProductCategoryRepository _repository;
  final CategoryDetailEntityMapper _categoryDetailEntityMapper;

  @override
  Future<BaseResponseModel<CategoryDetailEntity>> execute(
    CreateCategoryUseCaseInput input,
  ) async {
    final res =
        await _repository.createProductCategory(input.title, input.groups);
    return BaseResponseModel<CategoryDetailEntity>(
      code: res.code,
      message: res.message,
      data: _categoryDetailEntityMapper.mapToEntity(res.data),
    );
  }
}

class CreateCategoryUseCaseInput {
  CreateCategoryUseCaseInput(this.title, this.groups);

  String title;
  List<int> groups;
}
