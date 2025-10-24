import 'package:injectable/injectable.dart';
import 'package:one_click/data/mapper/base/base_data_mapper.dart';
import 'package:one_click/domain/entity/card.dart';

import '../models/card_model.dart';

@injectable
class CardEntityMapper extends BaseDataMapper<CardModel, CardEntity> {
  @override
  CardEntity mapToEntity(CardModel? data) {
    return CardEntity(
      id: data?.id,
      fullName: data?.fullName ?? '',
      cardNumber: data?.cardNumber ?? '',
      titleBank: data?.bankData?.title ?? '',
      shortNameBank: data?.bankData?.shortName ?? '',
      codeBank: data?.bankData?.code ?? '',
      imgCard: data?.bankData?.imgUrl,
    );
  }
}
