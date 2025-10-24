import 'package:injectable/injectable.dart';
import 'package:one_click/domain/entity/group_detail_entity.dart';
import 'package:one_click/domain/repository/product_group_repository.dart';
import 'package:one_click/domain/usecase/base/base_use_case.dart';

@injectable
class GetGroupDetailUseCase extends BaseUseCaseInput<int, GroupDetailEntity> {
  GetGroupDetailUseCase(this._repository);

  final ProductGroupRepository _repository;

  @override
  Future<GroupDetailEntity> execute(int input) async {
    final res = await _repository.getProductGroupDetail(input);
    return res;
  }
}
