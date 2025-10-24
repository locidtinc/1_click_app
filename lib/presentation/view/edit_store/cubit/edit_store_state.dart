import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:one_click/data/models/store_model/address/type_data.dart';
import 'package:one_click/domain/entity/store_entity.dart';
import 'package:one_click/domain/entity/store_information_payload.dart';

part 'edit_store_state.freezed.dart';

@freezed
class EditStoreState with _$EditStoreState {
  const factory EditStoreState({
    @Default(false) bool isLoading,
    @Default(StoreInformationPayload()) StoreInformationPayload payload,
    @Default(StoreEntity()) StoreEntity? store,
    String? phoneNumber,
    String? deputyName,
    String? nameStore,
    String? contact,
    String? email,
    String? openTime,
    String? closeTime,
    String? description,
    String? business,
    int? businessType,
    String? website,
    String? businessCode,
    String? taxCode,
    String? wareHouseArena,
    String? keyAccount,
    String? referralCode,
    @Default(false) bool? isCheckReferralCode,
    @Default(<TypeData>[]) List<TypeData> listBusinessType,
  }) = _EditStoreState;
}
