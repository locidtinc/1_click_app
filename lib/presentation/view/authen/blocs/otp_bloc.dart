import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:one_click/data/models/store_model/store_model.dart';
import 'package:one_click/presentation/base/dialog_custom.dart';
import 'package:one_click/presentation/config/bloc/bloc_status.dart';
import 'package:one_click/presentation/routers/router.gr.dart';
import 'package:one_click/presentation/view/authen/models/confirm_account_payload.dart';
import 'package:one_click/presentation/view/authen/repos/auth_repo.dart';
import 'package:one_click/shared/ext/index.dart';

import '../../../config/bloc/init_state.dart';

class OtpBloc extends Cubit<CubitState> {
  OtpBloc() : super(CubitState(total: 60));

  final _repo = AuthRepo();

  Timer? time;
  String? msg;

  timeRun() {
    time = Timer.periodic(1.seconds, (timer) {
      print(timer.tick);
      if (state.total > 0) {
        final total = state.total - 1;
        emit(state.copyWith(total: total));
      } else {
        time?.cancel();
      }
    });
  }

  Future<void> send(
    BuildContext context,
    String phone, {
    bool isLoad = true,
    bool isCreate = false,
    bool isResetPass = false,
  }) async {
    if (isCreate && !isLoad) {
      timeRun();
      return;
    }
    msg = null;
    if (isLoad) DialogUtils.showLoadingDialog(context, content: 'Đang tải...');
    emit(
      state.copyWith(
        total: kDebugMode ? 10 : 60,
        status: BlocStatus.loading,
      ),
    );

    time = null;
    final res = await _repo.sendOtp(phone);
    if (!context.mounted) return;
    if (isLoad) Navigator.pop(context);
    if (res.code == 200) {
      timeRun();
      emit(
        state.copyWith(
          status: BlocStatus.success,
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gửi mã OTP đến Zalo $phone thành công',
            style: p5.copyWith(color: green_1),
          ),
          backgroundColor: green_2,
        ),
      );
    } else {
      msg = res.message ?? 'Lỗi. Gửi thông báo không thành công.';
      DialogUtils.showErrorDialog(
        context,
        content: msg!,
      );
      emit(
        state.copyWith(
          status: BlocStatus.failure,
          total: 0,
          msg: msg,
        ),
      );
    }
  }

  Future<void> verify(
    BuildContext context, {
    required String phone,
    required String otp,
    bool isCreate = false,
    bool isResetPass = false,
  }) async {
    DialogUtils.showLoadingDialog(context, content: 'Đang tải...');

    final res = await _repo.verifyOtp(phone: phone, otp: otp);
    if (!context.mounted) return;
    Navigator.pop(context);
    if (res.code == 200) {
      if (isCreate) {
        context.router.replace(const LoginV2Route());
      } else if (isResetPass) {
        context.router.replace(ResetPasseV2Route(phone: phone));
      } else if (res.data is Map) {
        final store = StoreModel.fromJson(res.data);

        final payload = ConfirmAccountPayload();

        payload.fullName = store.fullName;
        payload.phone = store.phone;
        payload.shopName = store.shopData?.title;
        if (store.addressData != null) {
          payload.address = AddressDataPayload(
            title: store.addressData?.title,
            address: store.addressData?.title,
            area: store.addressData?.areaData?.id,
            areaName: store.addressData?.areaData?.title,
            ward: store.addressData?.wardData?.id,
            wardName: store.addressData?.wardData?.title,
            district: store.addressData?.districtData?.id,
            districtName: store.addressData?.districtData?.title,
            province: store.addressData?.provinceData?.id,
            provinceName: store.addressData?.provinceData?.title,
          );
        }

        context.router.replace(
          ConfirmAccountRoute(
            account: payload,
          ),
        );
      }
    } else {
      msg = res.message ?? 'Lỗi. Mã xác thực không chính xác hoặc đã hết hạn';
      emit(
        state.copyWith(
          status: BlocStatus.failure,
        ),
      );
    }
  }
}
