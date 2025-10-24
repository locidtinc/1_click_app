import 'package:injectable/injectable.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/domain/entity/group_detail_entity.dart';
import 'package:one_click/domain/repository/product_group_repository.dart';
import 'package:one_click/domain/usecase/base/base_use_case.dart';
import 'package:one_click/domain/usecase/group_create_use_case.dart';

@injectable
class UpdateProductGroupUseCase extends BaseUseCaseInput<UpdateGroupInput,
    BaseResponseModel<GroupDetailEntity>> {
  UpdateProductGroupUseCase(this._repository);

  final ProductGroupRepository _repository;

  @override
  Future<BaseResponseModel<GroupDetailEntity>> execute(
      UpdateGroupInput input) async {
    final res = await _repository.updateProductGroup(input.id, input.payload);
    return res;
  }
}

class UpdateGroupInput {
  UpdateGroupInput(this.id, this.payload);

  int id;
  GroupCreateInput payload;
}
