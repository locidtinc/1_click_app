import 'package:injectable/injectable.dart';
import 'package:one_click/data/mapper/variant_create_order_mapper.dart';
import 'package:one_click/data/mapper/variant_detail_mapper.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/domain/entity/variant_create_order.dart';
import 'package:one_click/domain/entity/variant_entity.dart';
import 'package:one_click/domain/usecase/base/future/base_future_use_case.dart';

import '../repository/variant_repository.dart';
import 'base/io/base_input.dart';
import 'base/io/base_output.dart';

@injectable
class VariantGetListUseCase
    extends BaseFutureUseCase<VariantGetListInput, VariantGetListOutput> {
  VariantGetListUseCase(
    this._variantRepository,
    this._variantCreateOrderMapper,
    this._variantDetailMapper,
  );
  final VariantRepository _variantRepository;
  final VariantCreateOrderMapper _variantCreateOrderMapper;
  final VariantDetailMapper _variantDetailMapper;
  @override
  Future<VariantGetListOutput> buildUseCase(VariantGetListInput input) async {
    final res = await _variantRepository.getList(
      input.page,
      input.limit,
      input.searchKey,
      input.accountSystemCode,
      input.status,
    );
    final dataCreateOrderEntity =
        _variantCreateOrderMapper.mapToListEntity(res.data);
    final dataEntity = _variantDetailMapper.mapToListEntity(res.data);
    return VariantGetListOutput(
      BaseResponseModel(
        code: res.code,
        message: res.message,
        data: dataCreateOrderEntity,
      ),
      BaseResponseModel(
        code: res.code,
        message: res.message,
        data: dataEntity,
      ),
    );
  }
}

class VariantGetListInput extends BaseInput {
  final int page;
  final int limit;
  final String searchKey;
  final String? accountSystemCode;
  final bool? status;
  VariantGetListInput({
    required this.limit,
    required this.page,
    required this.searchKey,
    this.accountSystemCode,
    this.status,
  });
}

class VariantGetListOutput extends BaseOutput {
  final BaseResponseModel<List<VariantCreateOrderEntity>> response;
  final BaseResponseModel<List<VariantEntity>> responseEntity;
  VariantGetListOutput(this.response, this.responseEntity);
}
