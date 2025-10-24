import 'package:injectable/injectable.dart';
import 'package:one_click/data/mapper/brand_mapper.dart';
import 'package:one_click/data/models/brand_model.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/domain/entity/brand.dart';
import 'package:one_click/domain/usecase/base/future/base_future_use_case.dart';
import 'package:one_click/domain/usecase/base/io/base_input.dart';
import 'package:one_click/domain/usecase/base/io/base_output.dart';
import 'package:one_click/presentation/view/product_manager/child/category/cubit/category_state.dart';

import '../repository/category_repository.dart';

@injectable
class CategoryGetListUseCase
    extends BaseFutureUseCase<CategoryGetListInput, CategoryGetListOutput> {
  final BrandEntityMapper _brandEntityMapper;
  final CategoryRepository _categoryRepository;
  CategoryGetListUseCase(this._brandEntityMapper, this._categoryRepository);

  @override
  Future<CategoryGetListOutput> buildUseCase(CategoryGetListInput input) async {
    switch (input.typeCategory) {
      case TypeCategory.brand:
        final res = await _categoryRepository.getListCategory<BrandModel>(
          data: input.typeCategory,
          page: input.page,
          limit: input.limit,
          searchKey: input.searchKey,
          code: input.code,
        );
        final response = CategoryGetListOutput<List<BrandEntity>>(
          BaseResponseModel(
            code: res.code,
            message: res.message,
            data: _brandEntityMapper.mapToListEntity(res.data),
          ),
        );
        return response;
      // case TypeCategory.category:
      //   break;
      // case TypeCategory.group:
      //   break;
      default:
        final res = await _categoryRepository.getListCategory<BrandModel>(
          data: input.typeCategory,
          page: input.page,
          limit: input.limit,
          searchKey: input.searchKey,
          code: input.code,
        );
        final response = CategoryGetListOutput<List<BrandEntity>>(
          BaseResponseModel(
            code: res.code,
            message: res.message,
            data: _brandEntityMapper.mapToListEntity(res.data),
          ),
        );
        return response;
    }
  }
}

class CategoryGetListInput extends BaseInput {
  final TypeCategory typeCategory;
  final int page;
  final int limit;
  final String searchKey;

  /// code is system code
  ///
  /// if code is [ADMIN] -> category create by ADMIN
  ///
  /// if code is [cHTH] -> create by CHTH
  ///
  /// if code is [ALL] -> get all
  final String code;
  CategoryGetListInput({
    required this.typeCategory,
    required this.page,
    required this.limit,
    required this.searchKey,
    required this.code,
  });
}

class CategoryGetListOutput<T> extends BaseOutput {
  final BaseResponseModel<T> response;
  CategoryGetListOutput(this.response);
}
