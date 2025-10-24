import 'package:one_click/data/models/store_model/address/type_data.dart';
import 'package:one_click/domain/repository/location_repository.dart';
import 'package:one_click/domain/usecase/get_list_ward_use_case.dart';
import 'package:one_click/domain/usecase/get_province_use_case.dart';
import 'package:one_click/presentation/di/di.dart';
import 'package:one_click/presentation/view/authen/models/confirm_account_payload.dart';
import 'package:one_click/shared/ext/index.dart';

import '../../../../domain/usecase/get_district_use_case.dart';
import '../../../config/bloc/bloc_status.dart';
import '../../../config/bloc/init_state.dart';

class LocationBloc extends Cubit<CubitState> {
  LocationBloc() : super(CubitState());
  final _repo = getIt<LocationRepository>();

  final List<TypeData> provinces = [];
  final List<TypeData> districts = [];
  final List<TypeData> wards = [];
  final List<TypeData> areas = [];

  TypeData? province;
  TypeData? district;
  TypeData? ward;
  TypeData? area;
  String? address;

  getDataDefault({
    AddressDataPayload? value,
  }) async {
    emit(
      state.copyWith(
        status: BlocStatus.loading,
        total: 0,
        isFirst: true,
      ),
    );
    provinces.clear();
    districts.clear();
    wards.clear();

    final resProvince = await _repo.getListProvince();
    final resArea = await _repo.getListArea();
    provinces.addAll(resProvince);
    areas.addAll(resArea);

    if (value?.province != null) {
      final resDistrict = await _repo.getListDistrict(value!.province!);
      districts.addAll(resDistrict);
    }

    if (value?.district != null) {
      final resWard = await _repo.getListWard(value!.district!);
      wards.addAll(resWard);
    }
    if (areas.isNotEmpty && value?.area != null) {
      area = areas.firstBy(
        (element) => element.id == value?.area,
        orElse: () {
          return null;
        },
      );
    }

    if (provinces.isNotEmpty && value?.province != null) {
      province = provinces.firstBy(
        (element) => element.id == value?.province,
        orElse: () {
          return null;
        },
      );
    }

    if (districts.isNotEmpty && value?.district != null) {
      district = districts.firstBy(
        (element) => element.id == value?.district,
        orElse: () {
          return null;
        },
      );
    }

    if (wards.isNotEmpty && value?.ward != null) {
      ward = wards.firstBy(
        (element) => element.id == value?.ward,
        orElse: () {
          return null;
        },
      );
    }
    if (value?.address != null) {
      address = value?.address;
    }

    emit(
      state.copyWith(
        status: BlocStatus.success,
        isFirst: false,
      ),
    );
  }

  getProvinces() async {
    provinces.clear();
    emit(
      state.copyWith(
        status: BlocStatus.loading,
        total: 1,
      ),
    );
    final resProvince = await _repo.getListProvince();
    provinces.addAll(resProvince);

    emit(
      state.copyWith(
        status: BlocStatus.success,
      ),
    );
  }

  getDistricts(int id) async {
    districts.clear();
    emit(
      state.copyWith(
        status: BlocStatus.loading,
        total: 2,
      ),
    );
    final resDistrict = await _repo.getListDistrict(id);
    districts.addAll(resDistrict);
    emit(
      state.copyWith(
        status: BlocStatus.success,
      ),
    );
  }

  getWards(int id) async {
    wards.clear();
    emit(
      state.copyWith(
        status: BlocStatus.loading,
        data: 3,
      ),
    );
    final resWard = await _repo.getListWard(id);
    wards.addAll(resWard);
    emit(
      state.copyWith(
        status: BlocStatus.success,
      ),
    );
  }

  setProvince(TypeData? value) {
    province = value;
    district = null;
    ward = null;
    address = null;
    districts.clear();
    wards.clear();

    getDistricts(value?.id ?? 0);
  }

  setDistict(TypeData? value) {
    district = value;
    ward = null;
    address = null;
    wards.clear();
    getWards(value?.id ?? 0);
  }

  setWard(TypeData? value) {
    ward = value;
    address = null;
    emit(state.copyWith(status: BlocStatus.success));
  }

  setArea(TypeData? value) {
    area = value;
    emit(state.copyWith(status: BlocStatus.success));
  }

  setAddress(String? value) {
    address = value;
    emit(state.copyWith(status: BlocStatus.success));
  }

  bool get addressOk =>
      province != null &&
      district != null &&
      ward != null &&
      !address.validator.trim().isEmptyOrNull;
}
