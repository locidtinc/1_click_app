import 'package:injectable/injectable.dart';
import 'package:one_click/data/models/bank_payload.dart';
import 'package:one_click/data/models/card_model.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/domain/repository/bank_repository.dart';
import 'package:one_click/domain/usecase/base/base_use_case.dart';

@injectable
class AddCardUseCase
    extends BaseUseCaseInput<AddBankInput, BaseResponseModel<CardModel>> {
  AddCardUseCase(this._repository);

  final BankRepository _repository;

  @override
  Future<BaseResponseModel<CardModel>> execute(AddBankInput input) async {
    final res = await _repository.addCard(input.payload, token: input.token);
    return res;
  }
}

class AddBankInput {
  AddBankInput(this.token, this.payload);

  String? token;
  BankPayload payload;
}
