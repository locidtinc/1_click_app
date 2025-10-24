import 'package:injectable/injectable.dart';
import 'package:one_click/data/mapper/variant_create_order_mapper.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/domain/entity/variant_create_order.dart';
import 'package:one_click/domain/repository/variant_repository.dart';
import 'package:one_click/domain/usecase/base/future/base_future_use_case.dart';

import 'base/io/base_input.dart';
import 'base/io/base_output.dart';

@injectable
class VariantGetByScanBarcodeUseCase extends BaseFutureUseCase<
    VariantGetByScanBarcodeInput, VariantGetByScanBarcodeOutput> {
  final VariantRepository _variantRepository;
  final VariantCreateOrderMapper _variantCreateOrderMapper;

  VariantGetByScanBarcodeUseCase(
    this._variantRepository,
    this._variantCreateOrderMapper,
  );

  @override
  Future<VariantGetByScanBarcodeOutput> buildUseCase(
    VariantGetByScanBarcodeInput input,
  ) async {
    final res = await _variantRepository.getByScanBarcode(input.barcode);
    return VariantGetByScanBarcodeOutput(
      BaseResponseModel<List<VariantCreateOrderEntity>>(
        code: res.code,
        message: res.message,
        data: _variantCreateOrderMapper.mapToListEntity(res.data),
      ),
    );
  }
}

class VariantGetByScanBarcodeInput extends BaseInput {
  final String barcode;
  VariantGetByScanBarcodeInput(this.barcode);
}

class VariantGetByScanBarcodeOutput extends BaseOutput {
  final BaseResponseModel<List<VariantCreateOrderEntity>> response;
  VariantGetByScanBarcodeOutput(this.response);
}
