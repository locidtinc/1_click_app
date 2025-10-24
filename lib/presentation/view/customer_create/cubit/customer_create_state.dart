import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../data/models/store_model/address/type_data.dart';
import '../../../../domain/entity/store_information_payload.dart';
import '../../authen/models/confirm_account_payload.dart';

part 'customer_create_state.freezed.dart';

@freezed
class CustomerCreateState with _$CustomerCreateState {
  const factory CustomerCreateState({
    @Default(null) int? gender,
    @Default('') String birthday,
    @Default('') String fullName,
    @Default('') String phone,
    @Default('') String email,
    @Default(null) File? avatar,
    @Default(null) AddressDataPayload? addressPayload,
  }) = _CustomerCreateState;
}
