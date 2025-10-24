import 'package:injectable/injectable.dart';
import 'package:one_click/domain/entity/variant_entity.dart';
import 'package:one_click/domain/repository/variant_repository.dart';
import 'package:one_click/domain/usecase/base/future/base_future_use_case.dart';
import 'package:one_click/domain/usecase/base/io/base_input.dart';
import 'package:one_click/domain/usecase/base/io/base_output.dart';

@injectable
class GetProductManagerDetailUseCase extends BaseFutureUseCase<
    ProductManagerDetailInput, ProductManagerDetailOutput> {
  GetProductManagerDetailUseCase(this._repository);

  final VariantRepository _repository;

  @override
  Future<ProductManagerDetailOutput> buildUseCase(
      ProductManagerDetailInput input) async {
    final res = await _repository.getVariantDetail(input.id);
    return ProductManagerDetailOutput(res.data);
  }
}

class ProductManagerDetailInput extends BaseInput {
  ProductManagerDetailInput(this.id);

  int id;
}

class ProductManagerDetailOutput extends BaseOutput {
  ProductManagerDetailOutput(this.variantEntity);

  VariantEntity? variantEntity;
}
