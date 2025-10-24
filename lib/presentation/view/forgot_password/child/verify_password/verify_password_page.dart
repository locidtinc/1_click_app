import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:one_click/presentation/di/di.dart';
import 'package:one_click/presentation/routers/router.gr.dart';
import 'package:one_click/presentation/view/forgot_password/child/verify_password/cubit/verify_password_cubit.dart';
import 'package:one_click/presentation/view/forgot_password/child/verify_password/cubit/verify_password_state.dart';
import 'package:pinput/pinput.dart';

@RoutePage()
class VerifyPasswordPage extends StatelessWidget {
  const VerifyPasswordPage({
    super.key,
    required this.sessionKey,
    required this.email,
  });

  final String sessionKey;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg_4,
      resizeToAvoidBottomInset: true,
      body: BlocProvider<VerifyPasswordCubit>(
        create: (_) => getIt.get<VerifyPasswordCubit>()..startCountDown(),
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
                  child: BlocBuilder<VerifyPasswordCubit, VerifyPasswordState>(
                    builder: (context, state) {
                      final bloc = context.read<VerifyPasswordCubit>();
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
                            Text(
                              'Nhập mã OTP',
                              style: p4.copyWith(color: borderColor_4),
                            ),
                            const SizedBox(height: sp16),
                            Pinput(
                              autofocus: true,
                              length: 6,
                              onChanged: bloc.onChangePin,
                              defaultPinTheme: PinTheme(
                                width: MediaQuery.of(context).size.width / 6,
                                height: MediaQuery.of(context).size.width / 8,
                                textStyle: h3,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: borderColor_2),
                                ),
                              ),
                              errorText: state.errorText,
                              forceErrorState: true,
                              pinputAutovalidateMode:
                                  PinputAutovalidateMode.onSubmit,
                            ),
                            const SizedBox(height: sp32),
                            Row(
                              children: [
                                Expanded(
                                  child: Extrabutton(
                                    title: state.time == 0
                                        ? 'Gửi lại mã'
                                        : 'Gửi lại mã (${state.time}s)',
                                    event: state.time == 0
                                        ? () =>
                                            bloc.reSendOtp(context, sessionKey)
                                        : () {},
                                    largeButton: true,
                                    icon: null,
                                    borderColor: borderColor_2,
                                  ),
                                ),
                                const SizedBox(width: sp16),
                                Expanded(
                                  child: SupportButton(
                                    title: 'Tiếp tục',
                                    event: state.enableButton
                                        ? () => bloc.verifyPassword(
                                              context,
                                              sessionKey,
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
                              ],
                            ),
                            const SizedBox(height: sp24),
                            Container(
                              decoration: BoxDecoration(
                                color: borderColor_1,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: sp16) +
                                      const EdgeInsets.only(
                                        top: sp16,
                                        bottom: sp12,
                                      ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SvgPicture.asset(
                                    '${AssetsPath.icon}/ic_warning_blue.svg',
                                    height: 20,
                                    color: blue_1,
                                  ),
                                  const SizedBox(width: sp16),
                                  Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                        text:
                                            'Mã OTP xác nhận đã được gửi về địa chỉ email:\n',
                                        style: p6.copyWith(color: blackColor),
                                        children: [
                                          TextSpan(
                                            text: bloc.hideEmail(email),
                                            style: p5.copyWith(
                                              color: blackColor,
                                              height: 2.0,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
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
