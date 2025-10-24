import 'package:injectable/injectable.dart';
import 'package:one_click/domain/entity/store_entity.dart';
import 'package:one_click/domain/repository/store_repository.dart';
import 'package:one_click/domain/usecase/base/future/base_future_use_case.dart';
import 'package:one_click/domain/usecase/base/io/base_input.dart';
import 'package:one_click/domain/usecase/base/io/base_output.dart';

@injectable
class GetStoreInfoUseCase
    extends BaseFutureUseCase<StoreInfoInput, StoreInfoOutput> {
  GetStoreInfoUseCase(this._repository);

  final StoreRepository _repository;

  @override
  Future<StoreInfoOutput> buildUseCase(StoreInfoInput input) async {
    final res = await _repository.getStoreInfo(input.storeId);
    return StoreInfoOutput(res);
  }
}

class StoreInfoInput extends BaseInput {
  StoreInfoInput(this.storeId);

  int storeId;
}

class StoreInfoOutput extends BaseOutput {
  StoreEntity storeEntity;

  StoreInfoOutput(this.storeEntity);
}
