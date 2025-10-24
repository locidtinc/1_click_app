import 'package:injectable/injectable.dart';
import 'package:one_click/data/mapper/variant_detail_mapper.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/domain/entity/variant_entity.dart';
import 'package:one_click/domain/repository/variant_repository.dart';
import 'package:one_click/domain/usecase/base/future/base_future_use_case.dart';
import 'package:one_click/domain/usecase/base/io/base_input.dart';
import 'package:one_click/domain/usecase/base/io/base_output.dart';

@injectable
class GetListVariantPromotionUseCase extends BaseFutureUseCase<
    GetListVariantPromotionInput, GetListVariantPromotionOutput> {
  final VariantRepository _variantRepository;
  final VariantDetailMapper _variantDetailMapper;
  GetListVariantPromotionUseCase(
    this._variantRepository,
    this._variantDetailMapper,
  );

  @override
  Future<GetListVariantPromotionOutput> buildUseCase(
    GetListVariantPromotionInput input,
  ) async {
    final res = await _variantRepository.getListPromotion(
      page: input.page,
      limit: input.limit,
      searchKey: input.keySearch,
    );
    return GetListVariantPromotionOutput(
      BaseResponseModel<List<VariantEntity>>(
        code: res.code,
        message: res.message,
        data: _variantDetailMapper.mapToListEntity(res.data),
      ),
    );
  }
}

class GetListVariantPromotionInput extends BaseInput {
  final int page;
  final int limit;
  final String keySearch;
  GetListVariantPromotionInput({
    required this.page,
    required this.limit,
    required this.keySearch,
  });
}

class GetListVariantPromotionOutput extends BaseOutput {
  final BaseResponseModel<List<VariantEntity>> response;
  GetListVariantPromotionOutput(this.response);
}
