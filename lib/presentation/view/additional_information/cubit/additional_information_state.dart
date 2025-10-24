import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:one_click/data/models/store_model/address/type_data.dart';
import 'package:one_click/domain/entity/store_entity.dart';

part 'additional_information_state.freezed.dart';

@freezed
class AdditionalInformationState with _$AdditionalInformationState {
  const factory AdditionalInformationState({
    @Default(false) bool isLoading,
    String? email,
    @Default('') String? deputy,
    String? contact,
    String? referralCode,
    String? openTime,
    String? closeTime,
    String? description,
    String? business,
    int? businessType,
    @Default(<TypeData>[]) List<TypeData> listBusinessType,
    CardDataEntity? cardData,
    @Default(false) bool enableButton,
  }) = _AdditionalInformationState;
}
