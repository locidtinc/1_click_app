import 'package:injectable/injectable.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/domain/entity/store_information_payload.dart';
import 'package:one_click/domain/repository/store_repository.dart';
import 'package:one_click/domain/usecase/base/future/base_future_use_case.dart';
import 'package:one_click/domain/usecase/base/io/base_input.dart';
import 'package:one_click/domain/usecase/base/io/base_output.dart';

@injectable
class UpdateStoreUseCase
    extends BaseFutureUseCase<UpdateStoreInput, UpdateStoreOutput> {
  UpdateStoreUseCase(this._repository);

  final StoreRepository _repository;

  @override
  Future<UpdateStoreOutput> buildUseCase(input) async {
    final res = await _repository.updateStore(input.storeId, input.payload);
    return UpdateStoreOutput(res);
  }
}

@injectable
class UpdateStoreUseCaseToken
    extends BaseFutureUseCase<UpdateStoreInput, UpdateStoreOutput> {
  UpdateStoreUseCaseToken(this._repository);

  final StoreRepository _repository;

  @override
  Future<UpdateStoreOutput> buildUseCase(UpdateStoreInput input) async {
    final res = await _repository.updateStore(
      input.storeId,
      input.payload,
      token: input.token,
    );
    return UpdateStoreOutput(res);
  }
}

class UpdateStoreInput extends BaseInput {
  UpdateStoreInput(this.storeId, this.payload, {this.token});

  String? token;
  int storeId;
  StoreInformationPayload payload;
}

class UpdateStoreOutput extends BaseOutput {
  UpdateStoreOutput(this.res);

  final BaseResponseModel res;
}
