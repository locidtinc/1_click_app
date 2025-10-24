import 'package:one_click/data/models/bank_payload.dart';
import 'package:one_click/data/models/card_model.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/data/models/store_model/bank_data.dart' as bank;

abstract class BankRepository {
  Future<List<bank.BankData>> getListBank({String? token});

  Future<String?> checkCard(
    String bin,
    String accountNumber,
    String transferType,
  );

  Future<BaseResponseModel<CardModel>> addCard(
    BankPayload payload, {
    String? token,
  });

  Future<BaseResponseModel<CardModel>> updateCard(
    int cardId,
    BankPayload payload,
  );
}
