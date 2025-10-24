import 'package:injectable/injectable.dart';
import 'package:one_click/domain/entity/brand_detail_entity.dart';
import 'package:one_click/domain/repository/product_brand_repository.dart';
import 'package:one_click/domain/usecase/base/base_use_case.dart';

@injectable
class GetBrandDetailUseCase extends BaseUseCaseInput<int, BrandDetailEntity> {
  GetBrandDetailUseCase(this._repository);

  final ProductBrandRepository _repository;

  @override
  Future<BrandDetailEntity> execute(int input) async {
    final res = await _repository.getBrandDetail(input);
    return res;
  }
}
