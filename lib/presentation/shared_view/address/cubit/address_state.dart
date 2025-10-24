import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:one_click/data/models/store_model/address/type_data.dart';

part 'address_state.freezed.dart';

@freezed
class AddressState with _$AddressState {
  const factory AddressState({
    @Default(false) bool isLoadingComplete,
    @Default(true) bool isLoading,
    @Default(<TypeData>[]) List<TypeData> listAddress,
    String? province,
    String? district,
    String? ward,
    @Default(1) int provinceId,
    @Default(1) int districtId,
    @Default(1) int wardId,
    String? street,
    String? title,
    double? heightBottomSheet,
    @Default('') String citySearch,
    @Default('') String districtSearch,
    @Default('') String wardsSearch,
  }) = _AddressState;
}
