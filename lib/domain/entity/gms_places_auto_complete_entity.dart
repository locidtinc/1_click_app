
import 'package:freezed_annotation/freezed_annotation.dart';
part 'gms_places_auto_complete_entity.freezed.dart';
@freezed
class GMSPlaceAutoCompleteEntity with _$GMSPlaceAutoCompleteEntity {
  const GMSPlaceAutoCompleteEntity._();

  const factory GMSPlaceAutoCompleteEntity({
    String? description,
    String? placeId,
  }) = _GMSPlaceAutoCompleteEntity;
}