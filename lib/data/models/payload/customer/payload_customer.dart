import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:one_click/shared/ext/index.dart';

import '../../../../shared/utils/event.dart';

class PayloadCustomerModel {
  final int? id;
  final String? fullName;
  final String? phone;
  final String? email;
  final String? birthday;
  final File? image;
  final int? gender;
  final LatLng? latLng;
  final String? address;
  final int? province;
  final int? district;
  final int? ward;
  final int? area;

  PayloadCustomerModel({
    this.id,
    this.fullName,
    this.phone,
    this.email,
    this.address,
    this.birthday,
    this.image,
    this.gender,
    this.latLng,
    this.province,
    this.district,
    this.ward,
    this.area,
  });

  PayloadCustomerModel copyWith({
    int? id,
    String? fullName,
    String? phone,
    String? email,
    String? address,
    String? birthday,
    File? image,
    int? gender,
    int? area,
  }) =>
      PayloadCustomerModel(
        id: id ?? this.id,
        fullName: fullName ?? this.fullName,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        address: address ?? this.address,
        birthday: birthday ?? this.birthday,
        image: image ?? this.image,
        gender: gender ?? this.gender,
        area: area ?? this.area,
      );

  Future<FormData> toFormData() async {
    final accountJson = {
      'full_name': fullName,
      'phone': phone,
      'email': email,
      'birthday': birthday == null || birthday == ''
          ? null
          : DateFormat('y-MM-dd')
              .format(DateTime.parse(formatDateTimeString(birthday!))),
      'gender': gender,
    };
    accountJson.removeWhere((key, value) => value == null || value == '');

    final addressJson = {
      'title': address,
      'lat': latLng?.latitude,
      'long': latLng?.longitude,
      'province': province,
      'district': district,
      'ward': ward,
      'area': area,
    };
    addressJson.removeWhere((key, value) => value == null || value == '');

    final json = {
      'data': jsonEncode({
        'customer': accountJson,
        'address': addressJson,
      }),
    };
    jsonEncode(json).copy;
    final formData = FormData.fromMap(json);
    if (image != null) {
      formData.files
          .add(MapEntry('image', await MultipartFile.fromFile(image!.path)));
    }
    return formData;
  }
}
