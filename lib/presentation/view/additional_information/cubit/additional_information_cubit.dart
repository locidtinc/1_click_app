import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:one_click/domain/entity/store_entity.dart';
import 'package:one_click/domain/entity/store_information_payload.dart';
import 'package:one_click/domain/usecase/get_list_business_type_use_case.dart';
import 'package:one_click/presentation/base/dialog_custom.dart';
import 'package:one_click/presentation/base/select_time_widget.dart';
import 'package:one_click/presentation/routers/router.gr.dart';
import 'package:one_click/presentation/view/additional_information/cubit/additional_information_state.dart';
import 'package:one_click/presentation/view/edit_store/widget/select_bottom_sheet.dart';
import 'package:one_click/shared/mixins/validate_mixin.dart';

import '../../../../domain/usecase/update_store_use_case.dart';

@injectable
class AdditionalInformationCubit extends Cubit<AdditionalInformationState>
    with ValidateMixin {
  AdditionalInformationCubit(
    this._getListBusinessTypeUseCase,
    this._updateStoreUseCase,
  ) : super(const AdditionalInformationState());

  final GetListBusinessTypeTokenUseCase _getListBusinessTypeUseCase;
  final UpdateStoreUseCaseToken _updateStoreUseCase;

  void onChangeEmail(String value) {
    emit(state.copyWith(email: value));
    _enableButton();
  }

  void onChangeDeputy(String value) {
    emit(state.copyWith(deputy: value));
    _enableButton();
  }

  void onChangeContact(String value) {
    emit(state.copyWith(contact: value));
    _enableButton();
  }

  void onChangeReferralCode(String? value) {
    emit(state.copyWith(referralCode: value));
    _enableButton();
  }

  void onChangeDescription(String value) {
    emit(state.copyWith(description: value));
    _enableButton();
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
            _onChangeBusiness(state.listBusinessType[index].title!);
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

  void getListBusinessType(String token) async {
    emit(state.copyWith(isLoading: true));
    final listBusinessType = await _getListBusinessTypeUseCase.execute(token);
    emit(
      state.copyWith(
        listBusinessType: listBusinessType.listBusinessType,
        isLoading: false,
      ),
    );
  }

  void onTapAddBank(BuildContext context, token) async {
    final result = await context.router.push(AddBankRoute(token: token));
    if (result != null) {
      final card = result as CardDataEntity;
      emit(
        state.copyWith(cardData: card),
      );
    }
  }

  void onTapSkip(BuildContext context) {
    context.router.replace(const LoginV2Route());
  }

  void onTapConfirm(
    BuildContext context,
    StoreEntity store,
    String? token,
  ) async {
    DialogUtils.showLoadingDialog(context, content: 'Đang xử lý, vui lòng đợi');
    final StoreInformationPayload storeInformationPayload =
        StoreInformationPayload(
      account: AccountPayload(
        email: state.email ?? store.email,
        fullName: state.deputy ?? store.representative,
        phone: store.phoneNumber,
        referralCode:
            (state.referralCode?.isEmpty ?? true) ? null : state.referralCode,
      ),
      shop: ShopPayload(
        title: store.nameStore,
        description: state.description ?? store.description,
        businessType: state.businessType ?? store.business,
        settings: SettingShopPayload(
          contact: state.contact ?? store.contact,
          openTime: state.openTime ?? store.openTime,
          closeTime: state.closeTime ?? store.closeTime,
        ),
      ),
    );

    final res = await _updateStoreUseCase.execute(
      UpdateStoreInput(store.id, storeInformationPayload, token: token),
    );
    Navigator.of(context).pop();
    if (res.res.code == 200 && context.mounted) {
      DialogCustoms.showSuccessDialog(
        context,
        titleConfirm: 'Quay lại đăng nhập',
        content: const Text(
          'Cập nhật thông tin thành công!',
          style: p4,
        ),
        click: () {
          context.router.pop();
          context.router.replace(const LoginV2Route());
        },
      );
    } else {
      DialogUtils.showErrorDialog(
        context,
        content: res.res.message ?? '',
      );
    }
  }

  void _onChangeBusiness(String value) {
    emit(state.copyWith(business: value));
  }

  void _enableButton() {
    if (state.email != null ||
        state.contact != null ||
        state.deputy != null ||
        state.description != null ||
        state.business != null ||
        state.openTime != null ||
        state.closeTime != null ||
        state.cardData != null) {
      emit(state.copyWith(enableButton: true));
      return;
    }
    emit(state.copyWith(enableButton: false));
  }
}
