import 'package:injectable/injectable.dart';
import 'package:one_click/data/models/bank_payload.dart';
import 'package:one_click/data/models/card_model.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/domain/repository/bank_repository.dart';
import 'package:one_click/domain/usecase/base/base_use_case.dart';

@injectable
class UpdateCardUseCase
    extends BaseUseCaseInput<UpdateCardInput, BaseResponseModel<CardModel>> {
  UpdateCardUseCase(this._repository);

  final BankRepository _repository;

  @override
  Future<BaseResponseModel<CardModel>> execute(UpdateCardInput input) async {
    final res = await _repository.updateCard(input.cardId, input.bankPayload);
    return res;
  }
}

class UpdateCardInput {
  UpdateCardInput(this.cardId, this.bankPayload);

  int cardId;
  BankPayload bankPayload;
}
