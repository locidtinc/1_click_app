import 'package:injectable/injectable.dart';
import 'package:one_click/domain/repository/bank_repository.dart';
import 'package:one_click/domain/usecase/base/future/base_future_use_case.dart';
import 'package:one_click/domain/usecase/base/io/base_input.dart';
import 'package:one_click/domain/usecase/base/io/base_output.dart';

@injectable
class CheckCardUseCase extends BaseFutureUseCase<CardInput, CardOutput> {
  CheckCardUseCase(this._repository);

  final BankRepository _repository;

  @override
  Future<CardOutput> buildUseCase(CardInput input) async {
    final res = await _repository.checkCard(
      input.bin,
      input.accountNumber,
      input.transferType,
    );
    return CardOutput(res);
  }
}

class CardInput extends BaseInput {
  CardInput(this.bin, this.accountNumber, this.transferType);

  String bin;
  String accountNumber;
  String transferType;
}

class CardOutput extends BaseOutput {
  CardOutput(this.accountName);

  String? accountName;
}
