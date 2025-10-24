import 'package:injectable/injectable.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/domain/repository/product_category_repository.dart';
import 'package:one_click/domain/usecase/base/future/base_future_use_case.dart';

import '../../data/models/product_category_model.dart';
import 'base/io/base_input.dart';
import 'base/io/base_output.dart';

@injectable
class ProductCategoryUseCase
    extends BaseFutureUseCase<ProductCategoryInput, ProductCategoryOutput> {
  final ProductCategoryRepository _productCategoryRepository;

  ProductCategoryUseCase(this._productCategoryRepository);

  @override
  Future<ProductCategoryOutput> buildUseCase(ProductCategoryInput input) async {
    final res = await _productCategoryRepository.getList(
        page: input.page, search: input.search);

    return ProductCategoryOutput(
      BaseResponseModel<List<ProductCategoryModel>>(
        code: res.statusCode,
        message: res.statusMessage,
        data: (res.data['data'] as List)
            .map((e) => ProductCategoryModel.fromJson(e))
            .toList(),
      ),
    );
  }
}

class ProductCategoryInput extends BaseInput {
  final int? page;
  final String? search;
  ProductCategoryInput({
    this.page,
    this.search,
  });
}

class ProductCategoryOutput extends BaseOutput {
  final BaseResponseModel<List<ProductCategoryModel>> response;

  ProductCategoryOutput(this.response);
}
