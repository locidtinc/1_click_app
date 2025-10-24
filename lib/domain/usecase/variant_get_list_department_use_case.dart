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
class VariantGetListDepartmentUseCase extends BaseFutureUseCase<
    VariantGetListDepartmentInput, VariantGetListDepartmentOutput> {
  VariantGetListDepartmentUseCase(
    this._variantRepository,
    this._variantCreateOrderMapper,
    this._variantDetailMapper,
  );
  final VariantRepository _variantRepository;
  final VariantCreateOrderMapper _variantCreateOrderMapper;
  final VariantDetailMapper _variantDetailMapper;
  @override
  Future<VariantGetListDepartmentOutput> buildUseCase(
      VariantGetListDepartmentInput input) async {
    final res = await _variantRepository.getListDepartment(
      input.page,
      input.limit,
      input.searchKey,
      input.accountSystemCode,
      input.status,
    );
    final dataCreateOrderEntity =
        _variantCreateOrderMapper.mapToListEntity(res.data);
    final dataEntity = _variantDetailMapper.mapToListEntity(res.data);
    return VariantGetListDepartmentOutput(
      BaseResponseModel(
        code: res.code,
        message: res.message,
        data: dataCreateOrderEntity,
        extra: res.extra,
      ),
      BaseResponseModel(
        code: res.code,
        message: res.message,
        data: dataEntity,
        extra: res.extra,
      ),
    );
  }
}

class VariantGetListDepartmentInput extends BaseInput {
  final int page;
  final int limit;
  final String searchKey;
  final String? accountSystemCode;
  final bool? status;
  VariantGetListDepartmentInput({
    required this.limit,
    required this.page,
    required this.searchKey,
    this.accountSystemCode,
    this.status,
  });
}

class VariantGetListDepartmentOutput extends BaseOutput {
  final BaseResponseModel<List<VariantCreateOrderEntity>> response;
  final BaseResponseModel<List<VariantEntity>> responseEntity;
  VariantGetListDepartmentOutput(this.response, this.responseEntity);
}
