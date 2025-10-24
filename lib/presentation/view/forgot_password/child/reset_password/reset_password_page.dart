import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:one_click/presentation/di/di.dart';
import 'package:one_click/presentation/view/forgot_password/child/reset_password/cubit/reset_password_cubit.dart';
import 'package:one_click/presentation/view/forgot_password/child/reset_password/cubit/reset_password_state.dart';

import '../../../../routers/router.gr.dart';

@RoutePage()
class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({
    super.key,
    required this.sessionKey,
    required this.otp,
  });

  final String sessionKey;
  final String otp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg_4,
      resizeToAvoidBottomInset: true,
      body: BlocProvider<ResetPasswordCubit>(
        create: (_) => getIt.get<ResetPasswordCubit>(),
        child: Padding(
          padding: const EdgeInsets.only(top: 160),
          child: Stack(
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
                padding: const EdgeInsets.only(left: 24, right: 24, top: 64),
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SingleChildScrollView(
                  child: BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
                    builder: (context, state) {
                      final bloc = context.read<ResetPasswordCubit>();
                      return Form(
                        key: bloc.formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Quên mật khẩu',
                              style: h2,
                            ),
                            const SizedBox(height: sp32),
                            AppInput(
                              label: 'Mật khẩu mới',
                              hintText: 'Nhập mật khẩu mới',
                              textInputType: TextInputType.emailAddress,
                              show: state.isShowPassword,
                              maxLines: 1,
                              validate: bloc.validatePassword,
                              onChanged: bloc.onChangeNewPassword,
                              suffixIcon: InkWell(
                                onTap: bloc.toggleShowPassword,
                                child: Padding(
                                  padding: const EdgeInsets.all(sp16),
                                  child: SvgPicture.asset(
                                    "${AssetsPath.icon}/login/${state.isShowPassword ? "ic_eye_close.svg" : "ic_eye.svg"}",
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: sp16),
                            AppInput(
                              label: 'Nhập lại mật khẩu',
                              hintText: 'Nhập mật khẩu mới',
                              maxLines: 1,
                              show: false,
                              textInputType: TextInputType.emailAddress,
                              validate: bloc.validateConfirmPassword,
                              onChanged: bloc.onChangeConfirmPassword,
                            ),
                            const SizedBox(height: sp32),
                            SizedBox(
                              width: double.infinity,
                              child: SupportButton(
                                title: 'Hoàn thành',
                                event: state.enableButton
                                    ? () => bloc.onTapFinish(
                                          context,
                                          sessionKey,
                                          otp,
                                        )
                                    : () {},
                                largeButton: true,
                                icon: null,
                                color: whiteColor,
                                backgroundColor: state.enableButton
                                    ? mainColor
                                    : borderColor_2,
                              ),
                            ),
                            const SizedBox(height: sp32),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 40,
                child: Container(
                  padding: const EdgeInsets.all(sp8),
                  decoration: BoxDecoration(
                    color: bg_4,
                    borderRadius: BorderRadius.circular(sp8),
                  ),
                  child: Image.asset(
                    '${AssetsPath.image}/ic_app.png',
                    height: sp48,
                    width: sp48,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: sp24),
        child: InkWell(
          onTap: () => context.router.replace(const LoginV2Route()),
          splashColor: Colors.transparent,
          child: Text(
            'Quay lại đăng nhập',
            style: p5.copyWith(color: blue_1),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
