import 'package:injectable/injectable.dart';
import 'package:one_click/data/mapper/category_detail_mapper.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/domain/entity/category_detail.dart';
import 'package:one_click/domain/repository/category_repository.dart';
import 'package:one_click/domain/usecase/base/future/base_future_use_case.dart';
import 'package:one_click/domain/usecase/base/io/base_input.dart';

import 'base/io/base_output.dart';

@injectable
class CategoryDetailUseCase
    extends BaseFutureUseCase<CategoryDetailInput, CategoryDetailOutput> {
  final CategoryRepository _categoryRepository;
  final CategoryDetailEntityMapper _categoryDetailEntityMapper;

  CategoryDetailUseCase(
    this._categoryRepository,
    this._categoryDetailEntityMapper,
  );

  @override
  Future<CategoryDetailOutput> buildUseCase(CategoryDetailInput input) async {
    final res = await _categoryRepository.categoryDetail(id: input.id);
    return CategoryDetailOutput(
      BaseResponseModel<CategoryDetailEntity>(
        code: res.code,
        message: res.message,
        data: res.code == 200
            ? _categoryDetailEntityMapper.mapToEntity(res.data)
            : null,
      ),
    );
  }
}

class CategoryDetailInput extends BaseInput {
  final int id;
  CategoryDetailInput(this.id);
}

class CategoryDetailOutput extends BaseOutput {
  final BaseResponseModel<CategoryDetailEntity> response;
  CategoryDetailOutput(this.response);
}
