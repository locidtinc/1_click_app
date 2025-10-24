import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:one_click/domain/entity/store_entity.dart';
import 'package:one_click/domain/entity/store_information_payload.dart';
import 'package:one_click/domain/usecase/get_list_business_type_use_case.dart';
import 'package:one_click/domain/usecase/update_address_store_use_case.dart';
import 'package:one_click/domain/usecase/update_store_use_case.dart';
import 'package:one_click/presentation/base/dialog_custom.dart';
import 'package:one_click/presentation/base/select_time_widget.dart';
import 'package:one_click/presentation/routers/router.gr.dart';
import 'package:one_click/presentation/shared_view/address/address_widget.dart';
import 'package:one_click/presentation/view/edit_store/cubit/edit_store_state.dart';
import 'package:one_click/presentation/view/edit_store/widget/select_bottom_sheet.dart';

@injectable
class EditStoreCubit extends Cubit<EditStoreState> {
  EditStoreCubit(
    this._getListBusinessTypeUseCase,
    this._updateStoreUseCase,
    this._updateAddressStoreUseCase,
  ) : super(const EditStoreState());

  final GetListBusinessTypeUseCase _getListBusinessTypeUseCase;
  final UpdateStoreUseCase _updateStoreUseCase;
  final UpdateAddressStoreUseCase _updateAddressStoreUseCase;
  AddressPayload? _addressShop;
  AddressPayload? _address;

  void onChangeStoreName(String value) {
    emit(state.copyWith(nameStore: value));
  }

  void onChangePhoneNumber(String value) {
    emit(state.copyWith(phoneNumber: value));
  }

  void onChangeEmail(String value) {
    emit(state.copyWith(email: value));
  }

  void onChangeContact(String value) {
    emit(state.copyWith(contact: value));
  }

  void onChangeDeputy(String value) {
    emit(state.copyWith(deputyName: value));
  }

  void onChangeWebsite(String value) {
    emit(state.copyWith(website: value));
  }

  void onChangeBusinesssCode(String value) {
    emit(state.copyWith(businessCode: value));
  }

  void onChangeTaxCode(String value) {
    emit(state.copyWith(taxCode: value));
  }

  void onChangeWareHouseArena(String value) {
    emit(state.copyWith(wareHouseArena: value));
  }

  void onChangekeyAccount(String value) {
    emit(state.copyWith(keyAccount: value));
  }

  void onreferralCode(String value) {
    emit(state.copyWith(referralCode: value));
  }

  void isCheck(bool value) {
    emit(state.copyWith(isCheckReferralCode: value));
  }

  void onChangeOpenTime(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(sp12),
        ),
      ),
      builder: (context) {
        return SelectTimeWidget(
          onSelectDate: (date) {
            context.router.pop();
            emit(state.copyWith(openTime: DateFormat('HH:mm').format(date)));
          },
          title: 'Chọn giờ mở cửa',
        );
      },
    );
  }

  void onChangeCloseTime(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(sp12),
        ),
      ),
      builder: (context) {
        return SelectTimeWidget(
          onSelectDate: (date) {
            context.router.pop();
            emit(state.copyWith(closeTime: DateFormat('HH:mm').format(date)));
          },
          title: 'Chọn giờ đóng cửa',
        );
      },
    );
  }

  void onChangeDescription(String value) {
    emit(state.copyWith(description: value));
  }

  void onChangeBusiness(String value) {
    emit(state.copyWith(business: value));
  }

  void onSelectBusinessType(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(sp12),
        ),
      ),
      builder: (context) {
        return SelectBottomSheet(
          title: 'Chọn loại hình kinh doanh',
          listBusinessType: state.listBusinessType,
          onTapItem: (index) {
            Navigator.of(context).pop();
            onChangeBusiness(state.listBusinessType[index].title!);
            emit(
              state.copyWith(
                businessType: state.listBusinessType[index].id!,
              ),
            );
          },
        );
      },
    );
  }

  void onTapCancel(BuildContext context) {
    DialogCustoms.showNotifyDialog(
      context,
      content: const Padding(
        padding: EdgeInsets.only(bottom: 24),
        child: Text('Bạn có muốn thoát không?'),
      ),
      click: () {
        int count = 2;
        context.router.popUntil((route) => count-- <= 0);
      },
    );
  }

  void onTapSave(BuildContext context, StoreEntity store) async {
    DialogUtils.showLoadingDialog(
      context,
      content: 'Đang cập nhật cửa hàng, vui lòng đợi!',
    );
    final StoreInformationPayload storeInformationPayload =
        StoreInformationPayload(
      account: AccountPayload(
        email: state.email ?? store.email,
        fullName: state.deputyName ?? store.deputyName,
        phone: state.phoneNumber ?? store.phoneNumber,
        referralCode: state.isCheckReferralCode == true
            ? state.referralCode ?? store.referralCode
            : null,
      ),
      shop: ShopPayload(
        title: state.nameStore ?? store.nameStore,
        description: state.description ?? store.description,
        businessType: state.businessType ?? store.business,
        settings: SettingShopPayload(
          contact: state.contact ?? store.contact,
          openTime: state.openTime ?? store.openTime,
          closeTime: state.closeTime ?? store.closeTime,
        ),
        businessCode: state.businessType != 3
            ? state.businessCode ?? store.businessCode
            : null,
        taxCode:
            state.businessType != 3 ? state.taxCode ?? store.taxCode : null,
        wareHouseArena: state.wareHouseArena ?? store.warehouseArea,
        website: state.website ?? store.website,
      ),
      address: _address ??
          AddressPayload(
            area: store.address?.area ?? 0,
            district: store.address?.district ?? 0,
            lat: store.address?.lat ?? 0,
            long: store.address?.long ?? 0,
            province: store.address?.province ?? 0,
            title: store.address?.title ?? '',
            ward: store.address?.ward ?? 0,
          ),
      addressShop: _addressShop ??
          AddressPayload(
            area: store.addressShop?.area ?? 0,
            district: store.addressShop?.district ?? 0,
            lat: store.addressShop?.lat ?? 0,
            long: store.addressShop?.long ?? 0,
            province: store.addressShop?.province ?? 0,
            title: store.addressShop?.title ?? '',
            ward: store.addressShop?.ward ?? 0,
          ),
    );
    final res = await _updateStoreUseCase
        .execute(UpdateStoreInput(store.id, storeInformationPayload));
    // if (_addressPayload != null) {
    //   await _updateAddressStoreUseCase.execute(UpdateAddressInput(store.address!.id, _addressPayload!));
    // }
    Navigator.of(context).pop();
    if (res.res.code == 200 && context.mounted) {
      context.router.pop(res.res.code);
    } else if (res.res.code == 400) {
      DialogUtils.showErrorDialog(
        context,
        content: 'Mã giới thiệu đã được thay đổi 1 lần',
        accept: () {
          isCheck(!state.isCheckReferralCode!);
          context.router.pop();
        },
        close: () => context.router.pop(),
      );
    } else {
      DialogUtils.showErrorDialog(
        context,
        content: 'Cập nhật cửa hàng thất bại',
      );
    }
  }

  void getListBusinessType(StoreEntity? storeEntity) async {
    emit(state.copyWith(isLoading: true));
    final listBusinessType = await _getListBusinessTypeUseCase.execute();
    emit(
      state.copyWith(
        business: storeEntity?.businessType?.title ?? '',
        openTime: storeEntity?.openTime ?? '',
        closeTime: storeEntity?.closeTime ?? '',
        listBusinessType: listBusinessType.listBusinessType,
        store: storeEntity,
        isLoading: false,
      ),
    );
  }

  void onTapEditAddress(BuildContext context) async {
    if (context.mounted) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: AddressWidget(
              onDone: (value) async {
                final store = state.store!.copyWith(
                  address: AddressEntity(
                    lat: value.lat,
                    long: value.long,
                    title: value.title,
                    area: value.area,
                    district: value.district,
                    province: value.province,
                    ward: value.ward,
                    address: value.title,
                  ),
                );
                _address = value;
                emit(state.copyWith(store: store));
              },
            ),
          );
        },
      );
    }
  }

  void onTapAddressShop(BuildContext context) async {
    if (context.mounted) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: AddressWidget(
              onDone: (value) async {
                final store = state.store!.copyWith(
                  addressShop: AddressEntity(
                    lat: value.lat,
                    long: value.long,
                    title: value.title,
                    area: value.area,
                    district: value.district,
                    province: value.province,
                    ward: value.ward,
                    address: value.title,
                  ),
                );
                _addressShop = value;
                emit(state.copyWith(store: store));
              },
            ),
          );
        },
      );
    }
  }

  void onTapEditBank(BuildContext context) async {
    final result = await context.router
        .push(AddBankRoute(isEdit: true, card: state.store?.cardData));
    if (result != null) {
      final card = result as CardDataEntity;
      emit(
        state.copyWith(
          store: state.store?.copyWith(cardData: card),
        ),
      );
    }
  }

  void onTapAddBank(BuildContext context) async {
    final result = await context.router.push(AddBankRoute());
    if (result != null) {
      final card = result as CardDataEntity;
      emit(
        state.copyWith(
          store: state.store?.copyWith(cardData: card),
        ),
      );
    }
  }
}
