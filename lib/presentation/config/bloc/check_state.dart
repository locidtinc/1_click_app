import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:one_click/shared/ext/index.dart';
import 'bloc_status.dart';
import 'cubit_state.dart';

class CheckStateBloc {
  static void show(
    BuildContext context,
    CubitState state, {
    Function()? success,
    Function()? error,
  }) {
    if (state.status == BlocStatus.loading) {
      DialogUtils.showLoadingDialog(
        context,
        content: 'Đang tải...',
      );
    }
    if (state.status == BlocStatus.success) {
      Navigator.pop(context);
      success?.call();
    }
    if (state.status == BlocStatus.failure) {
      Navigator.pop(context);
      error?.call() ??
          DialogUtils.showErrorDialog(
            context,
            content: state.msg,
          );
    }
  }

  static void check(
    BuildContext context,
    CubitState state, {
    String? msg,
    String? successBtnText,
    Function()? success,
    Function()? failure,
    Function()? close,
  }) {
    if (state.status == BlocStatus.loading) {
      DialogUtils.showLoadingDialog(
        context,
        content: 'Đang tải...',
      );
    }
    if (state.status == BlocStatus.success) {
      Navigator.pop(context);
      DialogUtils.showSuccessDialog(
        context,
        content: msg ?? state.msg,
        titleConfirm: successBtnText,
        accept: success,
        close: close ?? () => context.pop(),
      );
    }
    if (state.status == BlocStatus.failure) {
      Navigator.pop(context);
      if (failure != null) {
        failure();
      } else {
        DialogUtils.showErrorDialog(
          context,
          content: state.msg ?? 'Đã có lỗi vui lòng kiểm tra lại !',
        );
      }
    }
  }

  static checkNoLoad(
    BuildContext context,
    CubitState state, {
    String? msg,
    bool isShowMsg = true,
    String? successBtnText,
    Function()? success,
    Function()? failure,
  }) {
    if (state.status == BlocStatus.success) {
      DialogUtils.showSuccessDialog(
        context,
        content: msg ?? state.msg,
        titleConfirm: successBtnText,
        accept: success,
        close: () {
          context.pop();
        },
      );
    }
    if (state.status == BlocStatus.failure) {
      if (failure != null) {
        failure();
      } else {
        DialogUtils.showErrorDialog(
          context,
          content: state.msg,
        );
      }
    }
  }
}
