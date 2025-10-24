import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
part 'customer_create.freezed.dart';

@freezed
class CustomerCreateEntity with _$CustomerCreateEntity {
  const CustomerCreateEntity._();

  const factory CustomerCreateEntity({
    @Default(null) File? image,
    @Default(null) int? gender,
    @Default('') String birthday,
    @Default('') String fullName,
    @Default('') String phone,
    @Default('') String address,
    @Default('') String email,
    @Default(null) LatLng? latLng,
    @Default(null) int? province,
    @Default(null) int? district,
    @Default(null) int? ward,
    @Default(null) int? area,
    
  }) = _CustomerCreateEntity;
}
