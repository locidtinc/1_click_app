import 'package:injectable/injectable.dart';
import 'package:one_click/data/mapper/base/base_data_mapper.dart';
import 'package:one_click/data/models/store_model/store_model.dart';
import 'package:one_click/domain/entity/parent_account_entity.dart';
import 'package:one_click/domain/entity/store_entity.dart';

@injectable
class StoreInformationMapper extends BaseDataMapper<StoreModel, StoreEntity> {
  @override
  StoreEntity mapToEntity(StoreModel? data) {
    final address =
        data?.addressData == null ? null : '${data?.addressData?.title}';
    // '${data?.addressData?.wardData?.title}, '
    // '${data?.addressData?.districtData?.title}, '
    // '${data?.addressData?.provinceData?.title}';
    return StoreEntity(
      id: data?.id ?? 0,

      storeCode: data?.shopData?.code ?? '',
      nameStore: data?.shopData?.title ?? '',
      deputyName: data?.fullName ?? '',
      address: data?.addressData != null
          ? AddressEntity(
              id: data!.addressData!.id ?? 1,
              lat: data.addressData!.lat ?? 0,
              long: data.addressData!.long ?? 0,
              address: address,
              district: data.addressData!.district ?? 0,
              province: data.addressData!.province ?? 0,
              ward: data.addressData!.ward ?? 0,
              area: data.addressData!.area ?? 0,
              title: data.addressData!.title ?? '',
            )
          : null,
      addressShop: data?.shopData?.addressData != null
          ? AddressEntity(
              id: data?.shopData?.addressData?.id ?? 1,
              lat: data?.shopData?.addressData?.lat ?? 0,
              long: data?.shopData?.addressData?.long ?? 0,
              address: data?.shopData?.addressData?.title,
              district: data?.shopData?.addressData!.district ?? 0,
              province: data?.shopData?.addressData!.province ?? 0,
              ward: data?.shopData?.addressData!.ward ?? 0,
              area: data?.shopData?.addressData!.area ?? 0,
              title: data?.shopData?.addressData!.title ?? '0',
            )
          : null,
      description: data?.shopData?.description ?? '',
      // website: data?.shopData?.subdomain ?? '',
      website: data?.shopData?.website ?? '',
      businessType: data?.shopData?.businessTypeData,
      business: data?.shopData?.bussinessType,
      phoneNumber: data?.phone ?? '',
      email: data?.email ?? '',
      representative: data?.fullName ?? '',
      contact: data?.shopData?.settings?.contact ?? '',
      openTime: data?.shopData?.settings?.openTime ?? '',
      closeTime: data?.shopData?.settings?.closeTime ?? '',
      warehouseArea: data?.shopData?.warehouseArea ?? '',
      businessCode: data?.shopData?.businessCode ?? '',
      taxCode: data?.shopData?.taxCode ?? '',
      cardData: data?.cardData != null && data!.cardData!.isNotEmpty
          ? CardDataEntity(
              cardId: data.cardData?.first.id,
              bankId: data.cardData?.first.bankData?.id,
              bin: data.cardData?.first.bankData?.bin,
              nameCard: data.cardData?.first.fullName ?? '',
              cardNumber: data.cardData?.first.cardNumber ?? '',
              bankName: data.cardData?.first.bankData?.title ?? '',
              shortName: data.cardData?.first.bankData?.shortName ?? '',
            )
          : null,
      userCreatedData: data?.userCreatedData != null
          ? UserCreatedData(
              id: data?.userCreatedData?.id,
              fullName: data?.userCreatedData?.fullName,
              settings: data?.userCreatedData?.settings?.npt?.title,
              keyAccount: data?.userCreatedData?.keyAccount,
            )
          : null,
      keyAccount: data?.keyAccount,
      fullName: data?.fullName,
      createdAt: data?.shopData?.createdAt,
      updatedAt: data?.shopData?.updatedAt,
      parentAccount: data?.parentAccountData != null
          ? ParentAccountEntity(
              id: data?.parentAccountData?.id,
              fullName: data?.parentAccountData?.fullName,
              keyAccount: data?.parentAccountData?.keyAccount,
              settings: data?.parentAccountData?.settings,
              systemData: SystemData(
                  code: data?.parentAccountData?.systemData?.code,
                  id: data?.parentAccountData?.systemData?.id,
                  title: data?.parentAccountData?.systemData?.title),
            )
          : null,
      referralCode: data?.referralCode,
      avatar: data?.avatar,
      warehouseData: data?.warehouseData, storeId: data?.shopData?.id,
    );
  }
}
