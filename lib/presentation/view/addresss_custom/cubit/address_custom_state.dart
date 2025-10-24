import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../domain/entity/store_information_payload.dart';

part 'address_custom_state.freezed.dart';


@freezed
class AddressCustomState with _$AddressCustomState {
  const factory AddressCustomState({
    @Default(null) AddressPayload? addressPayload,
    @Default('') String addressDetail,
  }) = _AddressCustomState;
}
