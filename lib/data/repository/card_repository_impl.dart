import 'package:injectable/injectable.dart';
import 'package:one_click/data/apis/base_dio.dart';
import 'package:one_click/data/apis/end_point.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/data/models/card_model.dart';

import '../../domain/repository/card_repository.dart';

@LazySingleton(as: CardRepository)
class CardRepositoryImpl extends CardRepository {
  final BaseDio _basedio;

  CardRepositoryImpl(this._basedio);

  @override
  Future<BaseResponseModel<CardModel>> getCard() async {
    final res = await _basedio.dio().get(Api.card);
    return BaseResponseModel<CardModel>(
      code: res.data['code'],
      message: res.data['message'],
      data: res.data['data'].isNotEmpty
          ? CardModel.fromJson(res.data['data'][0])
          : null,
    );
  }
}
