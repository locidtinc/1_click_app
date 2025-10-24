import 'package:injectable/injectable.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/domain/repository/gms_repository.dart';
import 'package:one_click/domain/usecase/base/future/base_future_use_case.dart';
import 'package:one_click/domain/usecase/base/io/base_input.dart';

import '../../data/mapper/gms_places_auto_complete_mapper.dart';
import '../entity/gms_places_auto_complete_entity.dart';
import 'base/io/base_output.dart';

@injectable
class GMSPlaceAutoCompleteUseCase extends BaseFutureUseCase<
    GMSPlaceAutoCompleteInput, GMSPlaceAutoCompleteOutput> {
  final GMSRepository _gmsRepository;
  final GMSPlaceAutoCompleteEntityMapper _gmsPlaceAutoCompleteEntityMapper;

  GMSPlaceAutoCompleteUseCase(
      this._gmsRepository, this._gmsPlaceAutoCompleteEntityMapper);

  @override
  Future<GMSPlaceAutoCompleteOutput> buildUseCase(
      GMSPlaceAutoCompleteInput input) async {
    final res = await _gmsRepository.placesAutocomplete(
        address: input.addressName ?? '');

    return GMSPlaceAutoCompleteOutput(
      BaseResponseModel<List<GMSPlaceAutoCompleteEntity>>(
        code: res.code,
        message: res.message,
        data: _gmsPlaceAutoCompleteEntityMapper.mapToListEntity(res.data),
      ),
    );
  }
}

class GMSPlaceAutoCompleteInput extends BaseInput {
  final String? addressName;

  GMSPlaceAutoCompleteInput({
    this.addressName,
  });
}

class GMSPlaceAutoCompleteOutput extends BaseOutput {
  final BaseResponseModel<List<GMSPlaceAutoCompleteEntity>> response;

  GMSPlaceAutoCompleteOutput(
    this.response,
  );
}
