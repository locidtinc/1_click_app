import 'package:injectable/injectable.dart';
import 'package:one_click/data/mapper/card_mapper.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/domain/entity/card.dart';
import 'package:one_click/domain/repository/card_repository.dart';
import 'package:one_click/domain/usecase/base/future/base_future_use_case.dart';
import 'package:one_click/domain/usecase/base/io/base_input.dart';
import 'package:one_click/domain/usecase/base/io/base_output.dart';

@injectable
class GetCardRemoteUseCase
    extends BaseFutureUseCase<GetCardRemoteInput, GetCardRemoteOutput> {
  final CardRepository _cardRepository;
  final CardEntityMapper _cardEntityMapper;

  GetCardRemoteUseCase(
    this._cardRepository,
    this._cardEntityMapper,
  );

  @override
  Future<GetCardRemoteOutput> buildUseCase(GetCardRemoteInput input) async {
    final res = await _cardRepository.getCard();
    return GetCardRemoteOutput(
      BaseResponseModel<CardEntity>(
        code: res.code,
        message: res.message,
        data: _cardEntityMapper.mapToEntity(res.data),
      ),
    );
  }
}

class GetCardRemoteInput extends BaseInput {}

class GetCardRemoteOutput extends BaseOutput {
  final BaseResponseModel<CardEntity> response;
  GetCardRemoteOutput(this.response);
}
