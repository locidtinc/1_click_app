import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/data/models/store_model/address/type_data.dart';
import 'package:one_click/domain/entity/store_information_payload.dart';
import 'package:one_click/domain/usecase/get_district_use_case.dart';
import 'package:one_click/domain/usecase/get_list_ward_use_case.dart';
import 'package:one_click/domain/usecase/get_province_use_case.dart';
import 'package:one_click/presentation/shared_view/address/cubit/address_state.dart';

@injectable
class AddressCubit extends Cubit<AddressState> {
  AddressCubit(
    this._getProvinceUseCase,
    this._getDistrictUseCase,
    this._getListWardUseCase,
  ) : super(const AddressState());

  final GetProvinceUseCase _getProvinceUseCase;
  final GetDistrictUseCase _getDistrictUseCase;
  final GetListWardUseCase _getListWardUseCase;

  void getListProvince() async {
    emit(state.copyWith(isLoading: true));
    final res = await _getProvinceUseCase.execute();
    res.sort((a, b) => a.title!.compareTo(b.title!));
    emit(state.copyWith(listAddress: res, isLoading: false));
  }

  void getListDistrict(int provinceId) async {
    emit(state.copyWith(title: 'Danh sách Quận / Huyện', isLoading: true));
    for (final province in state.listAddress) {
      if (province.id == provinceId) {
        emit(state.copyWith(province: province.title, provinceId: provinceId));
      }
    }
    final res = await _getDistrictUseCase.execute(provinceId);
    res.sort((a, b) => a.title!.compareTo(b.title!));
    emit(state.copyWith(listAddress: res, isLoading: false));
  }

  void getListWard(int districtId) async {
    emit(state.copyWith(title: 'Danh sách Phường / Xã', isLoading: true));
    for (final district in state.listAddress) {
      if (district.id == districtId) {
        emit(state.copyWith(district: district.title, districtId: districtId));
      }
    }
    final res = await _getListWardUseCase.execute(districtId);
    res.sort((a, b) => a.title!.compareTo(b.title!));
    emit(state.copyWith(listAddress: res, isLoading: false));
  }

  void onTapItem(BuildContext context, TypeData address) {
    if (state.province != null && state.ward == null) {
      if (state.district == null) {
        getListWard(
          address.id!,
        );
        return;
      }
      _onSelectWard(context, address);
      return;
    }
    if (state.district == null) {
      getListDistrict(
        address.id!,
      );
      return;
    }
    _onSelectWard(context, address);
    return;
  }

  void onChangeStreet(String value) {
    emit(state.copyWith(street: value));
  }

  void onSearchChange({
    String? city,
    String? district,
    String? ward,
  }) {
    emit(
      state.copyWith(
        citySearch: city ?? state.citySearch,
        districtSearch: district ?? state.districtSearch,
        wardsSearch: ward ?? state.wardsSearch,
      ),
    );
  }

  Future<AddressPayload> onTapDone() async {
    emit(state.copyWith(isLoadingComplete: true));
    final address =
        '${state.street != null ? '${state.street}, ' : ''}${state.ward}, ${state.district}, ${state.province}';
    final List<Location> locations = await locationFromAddress(address);
    final addressPayload = AddressPayload(
      title: address,
      province: state.provinceId,
      district: state.districtId,
      ward: state.wardId,
      // provinceName: state.province ?? '',
      // districtName: state.district ?? '',
      // wardName: state.ward ?? '',
      lat: locations.first.latitude,
      long: locations.first.longitude,
    );
    return addressPayload;
  }

  void onTapReselectProvince(BuildContext context) {
    emit(
      state.copyWith(
        province: null,
        district: null,
        ward: null,
        title: 'Danh sách Tỉnh / Thành phố',
        heightBottomSheet: MediaQuery.of(context).size.height * 0.7,
        citySearch: '',
        districtSearch: '',
        wardsSearch: '',
      ),
    );
    getListProvince();
  }

  void onTapReselectDistrict(BuildContext context) {
    emit(
      state.copyWith(
        district: null,
        ward: null,
        heightBottomSheet: MediaQuery.of(context).size.height * 0.7,
        districtSearch: '',
        wardsSearch: '',
      ),
    );
    getListDistrict(state.provinceId);
  }

  void onTapReselectWard(BuildContext context) {
    emit(
      state.copyWith(
        ward: null,
        heightBottomSheet: MediaQuery.of(context).size.height * 0.7,
        wardsSearch: '',
      ),
    );
    getListWard(state.districtId);
  }

  void _onSelectWard(BuildContext context, TypeData data) {
    emit(
      state.copyWith(
        ward: data.title,
        wardId: data.id ?? 1,
        title: '',
        listAddress: [],
        heightBottomSheet: MediaQuery.of(context).size.height * 0.37,
      ),
    );
  }
}
