import 'package:injectable/injectable.dart';
import 'package:one_click/domain/entity/store_information_payload.dart';
import 'package:one_click/domain/repository/store_repository.dart';
import 'package:one_click/domain/usecase/base/future/base_future_use_case.dart';
import 'package:one_click/domain/usecase/base/io/base_input.dart';
import 'package:one_click/domain/usecase/base/io/base_output.dart';

@injectable
class UpdateAddressStoreUseCase
    extends BaseFutureUseCase<UpdateAddressInput, UpdateAddressOutput> {
  UpdateAddressStoreUseCase(this._repository);

  final StoreRepository _repository;

  @override
  Future<UpdateAddressOutput> buildUseCase(UpdateAddressInput input) async {
    final res =
        await _repository.updateAddressStore(input.storeId, input.payload);
    return UpdateAddressOutput(res);
  }
}

class UpdateAddressInput extends BaseInput {
  UpdateAddressInput(this.storeId, this.payload);

  int storeId;
  AddressPayload payload;
}

class UpdateAddressOutput extends BaseOutput {
  UpdateAddressOutput(this.output);

  bool? output;
}
