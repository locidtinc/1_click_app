import 'package:injectable/injectable.dart';
import 'package:one_click/domain/entity/variant_entity.dart';
import 'package:one_click/domain/repository/variant_repository.dart';
import 'package:one_click/domain/usecase/base/future/base_future_use_case.dart';
import 'package:one_click/domain/usecase/base/io/base_input.dart';
import 'package:one_click/domain/usecase/base/io/base_output.dart';

@injectable
class GetVariantDetailUseCase
    extends BaseFutureUseCase<VariantDetailInput, VariantDetailOutput> {
  GetVariantDetailUseCase(this._repository);

  final VariantRepository _repository;

  @override
  Future<VariantDetailOutput> buildUseCase(VariantDetailInput input) async {
    final res = await _repository.getVariantDetail(input.id);
    return VariantDetailOutput(res.data);
  }
}

class VariantDetailInput extends BaseInput {
  VariantDetailInput(this.id);

  int id;
}

class VariantDetailOutput extends BaseOutput {
  VariantDetailOutput(this.variantEntity);

  VariantEntity? variantEntity;
}
