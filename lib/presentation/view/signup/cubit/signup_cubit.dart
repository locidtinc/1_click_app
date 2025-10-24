import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/data/mapper/store_information_mapper.dart';
import 'package:one_click/data/models/payload/signup_payload.dart';
import 'package:one_click/domain/usecase/signup_use_case.dart';
import 'package:one_click/presentation/base/dialog_custom.dart';
import 'package:one_click/presentation/routers/router.gr.dart';
import 'package:one_click/presentation/shared_view/address/address_widget.dart';
import 'package:one_click/presentation/view/signup/cubit/signup_state.dart';
import 'package:one_click/shared/mixins/validate_mixin.dart';

import '../../../../domain/entity/store_information_payload.dart';

@injectable
class SignupCubit extends Cubit<SignupState> with ValidateMixin {
  SignupCubit(this._signupUseCase, this._mapper) : super(SignupState());

  final SignupUseCase _signupUseCase;
  final StoreInformationMapper _mapper;

  late AddressPayload _addressPayload;

  final keyForm = GlobalKey<FormState>();

  void changePhone(String value) {
    emit(state.copyWith(phone: value));
  }

  void changeNameStore(String value) {
    emit(state.copyWith(nameStore: value));
  }

  void changePassword(String value) {
    emit(state.copyWith(password: value));
  }

  void changeWebsite(String value) {
    emit(state.copyWith(website: value));
  }

  void toggleShowPassword() {
    emit(state.copyWith(showPassword: !state.showPassword));
  }

  void onChangeDeputy(String value) {
    emit(state.copyWith(deputy: value));
  }

  String? validateStoreName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập tên cửa hàng';
    }
    return null;
  }

  String? validateWebsite(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập tên website của cửa hàng';
    }
    return null;
  }

  void onTapChangeAddress(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(_).viewInsets.bottom,
          ),
          child: AddressWidget(
            onDone: (value) {
              emit(state.copyWith(address: value.title));
              _addressPayload = AddressPayload(
                title: value.title,
                lat: value.lat,
                long: value.long,
                province: value.province,
                district: value.district,
                ward: value.ward,
              );
            },
          ),
        );
      },
    );
  }

  void register(BuildContext context) async {
    if (keyForm.currentState!.validate()) {
      if (state.address.isEmpty) {
        DialogCustoms.showNotifyDialog(
          context,
          content: const Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: Text(
              'Vui lòng chọn địa chỉ cửa hàng.',
              style: p3,
            ),
          ),
        );
        return;
      }
      DialogUtils.showLoadingDialog(
        context,
        content: 'Đang xác thực, vui lòng đợi',
      );
      final res = await _signupUseCase.execute(
        SignupInput(
          SignupPayload(
            AccountPayloadModel(state.phone, state.password, state.deputy),
            ShopPayloadModel(
              state.nameStore,
              state.website,
              //'${AppConstant.http}${state.website}${AppConstant.endpointWebsite}',
            ),
            _addressPayload,
          ),
        ),
      );
      Navigator.of(context).pop();
      if (res.data.code == 400 && context.mounted) {
        DialogUtils.showErrorDialog(
          context,
          content: res.data.message ?? '',
        );
      } else {
        final store = _mapper.mapToEntity(res.data.data?.user);
        context.router.push(
          AdditionalInformationRoute(
            store: store,
            token: res.data.data?.token ?? '',
          ),
        );
      }
    }
  }
}
