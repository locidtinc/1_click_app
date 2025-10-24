import 'package:one_click/data/models/response/base_response.dart';

import '../../data/models/card_model.dart';

abstract class CardRepository {
  Future<BaseResponseModel<CardModel>> getCard();
}
