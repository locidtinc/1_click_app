import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:one_click/data/models/store_model/address/type_data.dart';
import 'package:one_click/data/models/store_model/warehouse_data.dart';
import 'package:one_click/data/models/warehouse_data_model.dart';
import 'package:one_click/domain/entity/parent_account_entity.dart';

part 'store_entity.freezed.dart';
part 'store_entity.g.dart';

@freezed
class StoreEntity with _$StoreEntity {
  const factory StoreEntity({
    @Default(0) int id,
    @Default('') String storeCode,
    @Default('') String deputyName,
    @Default('') String nameStore,
    @Default('') String phoneNumber,
    @Default('') String? website,
    @Default('') String? representative,
    @Default('') String? contact,
    @Default('') String? email,
    @Default(AddressEntity()) AddressEntity? address,
    @Default(AddressEntity()) AddressEntity? addressShop,
    @Default(null) TypeData? businessType,
    @Default('') String? openTime,
    @Default('') String? closeTime,
    @Default('') String? description,
    @Default(null) UserCreatedData? userCreatedData,
    @Default('') String? keyAccount,
    @Default('') String? settings,
    @Default('') String? fullName,
    @Default('') String? taxCode,
    @Default('') String? businessCode,
    @Default('') String? warehouseArea,
    @Default('') String? createdAt,
    @Default('') String? updatedAt,
    @Default('') String? referralCode,
    @Default(null) String? avatar,
    @Default(null) ParentAccountEntity? parentAccount,
    int? business,
    @Default(CardDataEntity()) CardDataEntity? cardData,
    @Default(WarehouseModel()) WarehouseModel? warehouseData,
    @Default(0) int? storeId,
  }) = _StoreEntity;

  factory StoreEntity.fromJson(Map<String, dynamic> json) =>
      _$StoreEntityFromJson(json);
}

@freezed
class CardDataEntity with _$CardDataEntity {
  const factory CardDataEntity({
    int? cardId,
    int? bankId,
    String? bin,
    @Default('') String nameCard,
    @Default('') String cardNumber,
    @Default('') String bankName,
    @Default('') String shortName,
  }) = _CardDataEntity;

  factory CardDataEntity.fromJson(Map<String, dynamic> json) =>
      _$CardDataEntityFromJson(json);
}

@freezed
class AddressEntity with _$AddressEntity {
  const factory AddressEntity({
    @Default(1) int id,
    @Default(0) double lat,
    @Default(0) double long,
    @Default('') String? address,
    @Default(1) int province,
    @Default(1) int district,
    @Default(1) int ward,
    @Default(1) int area,
    @Default('') String title,
  }) = _AddressEntity;

  factory AddressEntity.fromJson(Map<String, dynamic> json) =>
      _$AddressEntityFromJson(json);
}

@freezed
class UserCreatedData with _$UserCreatedData {
  const factory UserCreatedData({
    @Default(null) int? id,
    @Default(null) String? fullName,
    @Default(null) String? keyAccount,
    @Default(null) String? settings,
  }) = _UserCreatedData;

  factory UserCreatedData.fromJson(Map<String, dynamic> json) =>
      _$UserCreatedDataFromJson(json);
}
