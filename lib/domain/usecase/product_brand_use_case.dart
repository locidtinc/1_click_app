// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:injectable/injectable.dart';

import 'package:one_click/data/models/product_brand_model.dart';

import '../../data/models/response/base_response.dart';
import '../repository/product_brand_repository.dart';
import 'base/future/base_future_use_case.dart';
import 'base/io/base_input.dart';
import 'base/io/base_output.dart';

@injectable
class ProductBrandUseCase
    extends BaseFutureUseCase<ProductBrandInput, ProductBrandOutput> {
  final ProductBrandRepository _productBrandRepository;

  ProductBrandUseCase(this._productBrandRepository);

  @override
  Future<ProductBrandOutput> buildUseCase(ProductBrandInput input) async {
    final res = await _productBrandRepository.getList(
        page: input.page, search: input.search);
    late List<ProductBrandModel> data;
    if (res.statusCode == 200) {
      data = (res.data['data'] as List)
          .map((e) => ProductBrandModel.fromJson(e))
          .toList();
    }
    final BaseResponseModel<List<ProductBrandModel>> baseResponse =
        BaseResponseModel<List<ProductBrandModel>>(
      code: res.statusCode,
      message: res.statusMessage,
      data: res.statusCode == 200 ? data : <ProductBrandModel>[],
    );

    return ProductBrandOutput(baseResponse);
  }
}

class ProductBrandInput extends BaseInput {
  final int? page;
  final String? search;
  ProductBrandInput({
    this.page,
    this.search,
  });
}

class ProductBrandOutput extends BaseOutput {
  final BaseResponseModel<List<ProductBrandModel>> baseResponseModel;

  ProductBrandOutput(this.baseResponseModel);
}
