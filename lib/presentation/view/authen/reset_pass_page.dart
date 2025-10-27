import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:one_click/presentation/config/bloc/init_state.dart';
import 'package:one_click/presentation/view/authen/blocs/for_got_account_bloc.dart';
import 'package:one_click/shared/ext/index.dart';

import '../../base/custom_btn.dart';
import '../../base/input_column.dart';
import '../../config/app_style/init_app_style.dart';
import '../../routers/router.gr.dart';
import 'components/back_view.dart';

@RoutePage()
class ResetPasseV2Page extends StatefulWidget {
  final String phone;
  const ResetPasseV2Page({super.key, required this.phone});

  @override
  State<ResetPasseV2Page> createState() => _ResetPasseV2PageState();
}

class _ResetPasseV2PageState extends State<ResetPasseV2Page> {
  final _keyForm = GlobalKey<FormState>();
  final bloc = ForgotAccountBloc();
  final pass = TextEditingController();
  final passConfirm = TextEditingController();

  @override
  void dispose() {
    passConfirm.dispose();
    pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotAccountBloc, CubitState>(
      bloc: bloc,
      listener: (context, state) {
        CheckStateBloc.check(
          context,
          state,
          success: () {
            context.router.replaceAll([const LoginV2Route()]);
          },
        );
      },
      child: Scaffold(
        backgroundColor: AppColors.greyF5,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            context.padding.top.height,
            Center(
              child: SingleChildScrollView(
                child: Container(
                  margin: 16.pading,
                  padding: 16.pading,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: 8.radius,
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 4),
                        blurRadius: 4,
                        color: Colors.black.withOpacity(0.1),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const BackView(),
                      _buildView(),
                    ],
                  ),
                ),
              ),
            ).expanded(),
            context.padding.bottom.height,
          ],
        ),
      ),
    );
  }

  Widget _buildView() {
    return Form(
      key: _keyForm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Đổi mật khẩu',
            style: AppStyle.headingMd,
          ),
          8.height,
          Text(
            'Vui lòng điền mật khẩu có tối thiểu 8 ký tự, bao gồm: Chữ hoa, chữ thường, số và ký tự đặc biệt.',
            style: AppStyle.bodyBsRegular.copyWith(
              color: AppColors.grey79,
            ),
          ),
          24.height,
          InputColumn(
            label: 'Mật khẩu mới',
            isRequired: true,
            maxLines: 1,
            isPassword: true,
            textInputType: TextInputType.visiblePassword,
            controller: pass,
            validate: (value) {
              if (value!.isNotEmpty) {
                return value.validatorTextField(
                  type: TextInputType.visiblePassword,
                  textConfirm: passConfirm.text,
                );
              }
              return null;
            },
          ),
          16.height,
          InputColumn(
            label: 'Xác nhận mật khẩu',
            isRequired: true,
            maxLines: 1,
            isPassword: true,
            textInputType: TextInputType.visiblePassword,
            controller: passConfirm,
            validate: (value) {
              if (value!.isNotEmpty) {
                return value.validatorTextField(
                  type: TextInputType.visiblePassword,
                  textConfirm: pass.text,
                );
              }
              return null;
            },
          ),
          16.height,
          CustomBtn(
            onPressed: () {
              if (_keyForm.currentState?.validate() ?? false) {
                bloc.resetPass(
                  phone: widget.phone,
                  newPass: pass.text,
                  newPassConfirm: passConfirm.text,
                );
              }
            },
            title: 'Xác nhận',
            backgroundColor: AppColors.brand,
            textStyle: AppStyle.bodyBsMedium.copyWith(
              color: AppColors.white,
            ),
          ).size(height: 45),
          16.height,
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'Đã có tài khoản? ',
              style: AppStyle.bodyBsRegular,
              children: [
                TextSpan(
                  text: 'Đăng nhập ngay',
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      context.router.replaceAll([const LoginV2Route()]);
                    },
                  style: AppStyle.bodyBsRegular.copyWith(
                    color: AppColors.blue60,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
