import 'package:injectable/injectable.dart';
import 'package:one_click/data/mapper/base/base_data_mapper.dart';
import 'package:one_click/data/models/gms_model/geocode_model.dart';
import 'package:one_click/domain/entity/gms_geocode_entity.dart';

@injectable
class GMSGeocodeEntityMapper
    extends BaseDataMapper<GeocodeModel, GMSGeocodeEntity> {
  @override
  GMSGeocodeEntity mapToEntity(GeocodeModel? data) {
    return GMSGeocodeEntity(
      lat: data?.geometry?.location?.lat,
      lng: data?.geometry?.location?.lng,
      addressName: data?.formattedAddress,
      addressComponent: data?.formattedAddress
          ?.split(',')
          .map(
            (e) => AddressComponentEntity(
              value: e,
            ),
          )
          .toList()
          .reversed
          .toList(),
    );
  }
}
