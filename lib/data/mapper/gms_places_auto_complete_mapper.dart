import 'package:injectable/injectable.dart';
import 'package:one_click/data/mapper/base/base_data_mapper.dart';
import 'package:one_click/data/models/gms_model/place_auto_complete_model.dart';
import 'package:one_click/domain/entity/gms_places_auto_complete_entity.dart';

@injectable
class GMSPlaceAutoCompleteEntityMapper
    extends BaseDataMapper<PlaceAutoCompleteModel, GMSPlaceAutoCompleteEntity> {
  @override
  GMSPlaceAutoCompleteEntity mapToEntity(PlaceAutoCompleteModel? data) {
    return GMSPlaceAutoCompleteEntity(
      placeId: data?.placeId,
      description: data?.description,
    );
  }
}
