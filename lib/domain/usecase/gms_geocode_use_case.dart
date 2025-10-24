import 'package:injectable/injectable.dart';
import 'package:one_click/data/mapper/gms_geocode_mapper.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/domain/entity/gms_geocode_entity.dart';
import 'package:one_click/domain/repository/gms_repository.dart';
import 'package:one_click/domain/usecase/base/future/base_future_use_case.dart';
import 'package:one_click/domain/usecase/base/io/base_input.dart';

import 'base/io/base_output.dart';

@injectable
class GMSGeocodeUseCase
    extends BaseFutureUseCase<GMSGeocodeInput, GMSGeocodeOutput> {
  final GMSRepository _gmsRepository;
  final GMSGeocodeEntityMapper _gmsGeocodeEntityMapper;

  GMSGeocodeUseCase(this._gmsRepository, this._gmsGeocodeEntityMapper);

  @override
  Future<GMSGeocodeOutput> buildUseCase(GMSGeocodeInput input) async {
    final res = await _gmsRepository.geocoding(
        address: input.addressName, placeId: input.placeId);

    return GMSGeocodeOutput(
      BaseResponseModel<GMSGeocodeEntity>(
        code: res.code,
        message: res.message,
        data: _gmsGeocodeEntityMapper.mapToEntity(res.data),
      ),
    );
  }
}

class GMSGeocodeInput extends BaseInput {
  final String? addressName;
  final String? placeId;

  GMSGeocodeInput({
    this.addressName,
    this.placeId,
  });
}

class GMSGeocodeOutput extends BaseOutput {
  final BaseResponseModel<GMSGeocodeEntity> response;

  GMSGeocodeOutput(
    this.response,
  );
}
