import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/domain/repository/gms_repository.dart';
import 'package:one_click/domain/usecase/gms_geocode_use_case.dart';
import 'package:one_click/presentation/view/map_picker.dart/map_picker_page.dart';

import '../../../../data/models/store_model/address/type_data.dart';
import '../../../../domain/usecase/get_district_use_case.dart';
import '../../../../domain/usecase/get_list_ward_use_case.dart';
import '../../../../domain/usecase/get_province_use_case.dart';
import '../../../../domain/usecase/gms_places_auto_complete_use_case.dart';
import '../../../../shared/services/geolocator/geolocator.dart';
import '../../../../shared/utils/event.dart';
import 'map_picker_state.dart';

@injectable
class MapPickerCubit extends Cubit<MapPickerState> {
  MapPickerCubit(
      this._gmsGeocodeUseCase,
      this._gmsPlaceAutoCompleteUseCase,
      this._getProvinceUseCase,
      this._getDistrictUseCase,
      this._getListWardUseCase)
      : super(const MapPickerState());

  final GMSGeocodeUseCase _gmsGeocodeUseCase;
  final GMSPlaceAutoCompleteUseCase _gmsPlaceAutoCompleteUseCase;
  final GetProvinceUseCase _getProvinceUseCase;
  final GetDistrictUseCase _getDistrictUseCase;
  final GetListWardUseCase _getListWardUseCase;

  late GoogleMapController gmsController;
  Timer? timer;

  void initGMSController(GoogleMapController controller) {
    gmsController = controller;
    geocode(
        addressName:
            '${state.addressInit?.title ?? ''}, ${state.addressInit?.wardName ?? ''}, ${state.addressInit?.districtName ?? ''}, ${state.addressInit?.provinceName ?? ''}');
  }

  void onFieldChange({
    String? addressSeerch,
    AddressPickerEntity? addressInit,
  }) {
    emit(
      state.copyWith(
        addressSearch: addressSeerch ?? state.addressSearch,
        addressInit: addressInit ?? state.addressInit,
      ),
    );
  }

  Future<void> getMyLocation() async {
    final geolocationService = GeolocationService();
    final Position location = await geolocationService.determinePosition();
    emit(
      state.copyWith(
        myLocation: LatLng(location.latitude, location.longitude),
        isLoading: false,
      ),
    );
  }

  void searchEvent(String value) {
    emit(state.copyWith(addressSearch: value));
    if (timer != null) {
      timer!.cancel();
    }

    timer = Timer(const Duration(seconds: 1), () {
      placesAutoComplete();
    });
  }

  Future<void> addressPickerHandle(
    AddressPickerEntity address,
    LatLng latLng,
  ) async {
    if (address.provinceName == null) return;
    emit(state.copyWith(addressTitle: address.title ?? '', latLng: latLng));
    final listProvince = await _getProvinceUseCase.execute();
    final province = listProvince.cast<TypeData?>().firstWhere((e) =>
        convertToUnsigned(e?.title ?? '').contains(replaceStringAddress(
            convertToUnsigned(address.provinceName ?? ''))));
    if (province == null) return;
    emit(state.copyWith(province: province));
    final listDistrict = await _getDistrictUseCase.execute(province.id!);
    final district = listDistrict.cast<TypeData?>().firstWhere((e) =>
        convertToUnsigned(e?.title ?? '').contains(replaceStringAddress(
            convertToUnsigned(address.districtName ?? ''))));
    emit(state.copyWith(district: district));
    if (district == null) return;
    final listWard = await _getListWardUseCase.execute(district.id!);
    final ward = listWard.cast<TypeData?>().firstWhere((e) =>
        convertToUnsigned(e?.title ?? '').contains(
            replaceStringAddress(convertToUnsigned(address.wardName ?? ''))));
    emit(state.copyWith(ward: ward));
    emit(
      state.copyWith(
        addressInit: AddressPickerEntity(
          provinceName: province.title,
          provinceId: province.id,
          districtName: district.title,
          districtId: district.id,
          wardName: ward?.title,
          wardId: ward?.id,
          title: address.title,
        ),
      ),
    );
  }
}

extension GMSApi on MapPickerCubit {
  Future<void> geocode({
    String? addressName,
    String? placeId,
  }) async {
    final input = GMSGeocodeInput(addressName: addressName, placeId: placeId);
    final res = await _gmsGeocodeUseCase.execute(input);
    emit(
      state.copyWith(
        locationPicked: res.response.data,
        listPlaceSearch: [],
        markers: {
          Marker(
            markerId: MarkerId('${res.response.data?.addressName}'),
            position: LatLng(
              res.response.data?.lat ?? 21.028187811841452,
              res.response.data?.lng ?? 105.85230421415994,
            ),
          )
        },
      ),
    );
    final latLng = LatLng(
      state.locationPicked?.lat ?? 21.028187811841452,
      state.locationPicked?.lng ?? 105.85230421415994,
    );
    gmsController.moveCamera(
      CameraUpdate.newLatLng(latLng),
    );

    final addressPicker = AddressPickerEntity(
      provinceName: res.response.data?.addressComponent?[1].value,
      districtName: res.response.data?.addressComponent?[2].value,
      wardName: res.response.data?.addressComponent?[3].value,
      title: res.response.data?.addressComponent?[4].value,
    );
    addressPickerHandle(
      addressPicker,
      latLng,
    );
  }

  Future<void> placesAutoComplete() async {
    final input = GMSPlaceAutoCompleteInput(addressName: state.addressSearch);
    final res = await _gmsPlaceAutoCompleteUseCase.execute(input);
    emit(state.copyWith(listPlaceSearch: res.response.data ?? []));
  }
}
