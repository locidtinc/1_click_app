
import 'package:freezed_annotation/freezed_annotation.dart';
part 'gms_geocode_entity.freezed.dart';
@freezed
class GMSGeocodeEntity with _$GMSGeocodeEntity {
  const GMSGeocodeEntity._();

  const factory GMSGeocodeEntity({
    double? lat,
    double? lng,
    String? addressName,
    List<AddressComponentEntity>? addressComponent,
  }) = _GMSGeocodeEntity;
}

@freezed
class AddressComponentEntity with _$AddressComponentEntity {
  const AddressComponentEntity._();

  const factory AddressComponentEntity({
    String? value,
  }) = _AddressComponentEntity;
}