import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:one_click/presentation/config/bloc/bloc_status.dart';
import 'package:one_click/presentation/di/di.dart';
import 'package:one_click/presentation/view/authen/models/sign_payload_model.dart';
import 'package:one_click/presentation/view/authen/repos/account_repo.dart';

import '../../../../domain/usecase/signup_use_case.dart';
import '../../../config/bloc/init_state.dart';

class SignV2Bloc extends Cubit<CubitState> {
  SignV2Bloc() : super(CubitState());
  final _repo = AccountRepo();
  final payload = SignPayloadModel(
    name: '',
    phone: '',
    password: '',
    shopName: '',
    address: null,
  );

  sign() async {
    emit(state.copyWith(status: BlocStatus.loading));
    print(jsonEncode(payload.toJson()));
    final res = await _repo.sign(payload);
    if (res.code == 200) {
      emit(
        state.copyWith(
          status: BlocStatus.success,
          // msg: 'Tạo tài khoản thành công',
          msg: 'Vui lòng bấm "Xác nhận" để nhận mã kích hoạt tài khoản',
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: BlocStatus.failure,
          msg:
              'Lỗi.Số điện thoại đã được đăng kí, vui lòng trở lại để đăng nhập',
        ),
      );
    }
  }
}
