import 'package:injectable/injectable.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/domain/usecase/base/future/base_future_use_case.dart';

import '../../data/models/product_Group_model.dart';
import '../repository/product_group_repository.dart';
import 'base/io/base_input.dart';
import 'base/io/base_output.dart';

@injectable
class ProductGroupUseCase
    extends BaseFutureUseCase<ProductGroupInput, ProductGroupOutput> {
  final ProductGroupRepository _productGroupRepository;

  ProductGroupUseCase(this._productGroupRepository);

  @override
  Future<ProductGroupOutput> buildUseCase(ProductGroupInput input) async {
    final res = await _productGroupRepository.getList();

    return ProductGroupOutput(
      BaseResponseModel<List<ProductGroupModel>>(
        code: res.statusCode,
        message: res.statusMessage,
        data: (res.data['data'] as List)
            .map((e) => ProductGroupModel.fromJson(e))
            .toList(),
      ),
    );
  }
}

class ProductGroupInput extends BaseInput {}

class ProductGroupOutput extends BaseOutput {
  final BaseResponseModel<List<ProductGroupModel>> response;

  ProductGroupOutput(this.response);
}
