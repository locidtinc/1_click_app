import 'package:injectable/injectable.dart';
import 'package:one_click/data/models/store_model/bank_data.dart';
import 'package:one_click/domain/repository/bank_repository.dart';
import 'package:one_click/domain/usecase/base/base_use_case.dart';

@injectable
class GetListBankUseCase extends BaseUseCaseInput<BankInput, List<BankData>> {
  GetListBankUseCase(this._repository);

  final BankRepository _repository;

  @override
  Future<List<BankData>> execute(BankInput input) async {
    final res = await _repository.getListBank(token: input.token);
    return res;
  }
}

class BankInput {
  BankInput(this.token);

  String? token;
}
