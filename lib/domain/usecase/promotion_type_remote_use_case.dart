import 'package:injectable/injectable.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/domain/entity/promotion_type.dart';
import 'package:one_click/domain/repository/promotion_repository.dart';
import 'package:one_click/domain/usecase/base/future/base_future_use_case.dart';
import 'package:one_click/domain/usecase/base/io/base_input.dart';

import '../../data/mapper/promotion_type_mapper.dart';
import 'base/io/base_output.dart';

@injectable
class PromotionTypeRemoteUseCase extends BaseFutureUseCase<
    PromotionTypeRemoteInput, PromotionTypeRemoteOutput> {
  final PromotionRepository _promotionRepository;
  final PromotionTypeEntityMapper _promotionTypeEntityMapper;
  PromotionTypeRemoteUseCase(
      this._promotionRepository, this._promotionTypeEntityMapper);
  @override
  Future<PromotionTypeRemoteOutput> buildUseCase(
    PromotionTypeRemoteInput input,
  ) async {
    final res = await _promotionRepository.typeDiscount();
    return PromotionTypeRemoteOutput(
      BaseResponseModel<List<PromotionTypeEntity>>(
        code: res.code,
        message: res.message,
        data: _promotionTypeEntityMapper.mapToListEntity(res.data),
      ),
    );
  }
}

class PromotionTypeRemoteInput extends BaseInput {}

class PromotionTypeRemoteOutput extends BaseOutput {
  final BaseResponseModel<List<PromotionTypeEntity>> response;
  PromotionTypeRemoteOutput(this.response);
}
