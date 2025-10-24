import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:one_click/presentation/di/di.dart';
import 'package:one_click/presentation/routers/router.gr.dart';
import 'package:one_click/presentation/view/forgot_password/cubit/forgot_password_cubit.dart';
import 'package:one_click/presentation/view/forgot_password/cubit/forgot_password_state.dart';

@RoutePage()
class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg_4,
      resizeToAvoidBottomInset: true,
      body: BlocProvider<ForgotPasswordCubit>(
        create: (context) => getIt.get<ForgotPasswordCubit>(),
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
                  child: BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
                    builder: (context, state) {
                      final bloc = context.read<ForgotPasswordCubit>();
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
                            const SizedBox(
                              height: sp32,
                            ),
                            state.isLinkedEmail
                                ? Column(
                                    children: [
                                      AppInput(
                                        label: 'Số điện thoại',
                                        hintText: 'Nhập số điện thoại',
                                        textInputType: TextInputType.phone,
                                        validate: context
                                            .read<ForgotPasswordCubit>()
                                            .validatePhoneNumber,
                                        onChanged: context
                                            .read<ForgotPasswordCubit>()
                                            .onChangePhone,
                                      ),
                                      const SizedBox(height: sp32),
                                      SizedBox(
                                        width: double.infinity,
                                        child: MainButton(
                                          title: 'Tiếp tục',
                                          event: () =>
                                              bloc.onTapContinue(context),
                                          largeButton: true,
                                          icon: null,
                                        ),
                                      ),
                                      const SizedBox(height: sp24),
                                      SizedBox(
                                        width: double.infinity,
                                        child: Extrabutton(
                                          title: 'Gọi hỗ trợ kỹ thuật',
                                          event: bloc.onTapCallCentre,
                                          largeButton: true,
                                          borderColor: borderColor_2,
                                          icon: SvgPicture.asset(
                                            '${AssetsPath.icon}/ic_call_centre.svg',
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : _notLinkedEmail(
                                    state.phone,
                                    bloc.onTapBack,
                                    bloc.onTapCallCentre,
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
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: sp24),
        child: InkWell(
          onTap: () => context.router.replace(const LoginV2Route()),
          child: Text(
            'Quay lại đăng nhập',
            style: p5.copyWith(color: blue_1),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _notLinkedEmail(
    String phone,
    Function onTapBack,
    Function onTapCallCentre,
  ) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: borderColor_1,
            borderRadius: BorderRadius.circular(sp8),
          ),
          padding: const EdgeInsets.all(sp16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                '${AssetsPath.icon}/ic_warning.svg',
                height: 21,
                width: 21,
              ),
              const SizedBox(width: sp16),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    text: 'Số điện thoại ',
                    style: p6.copyWith(color: blackColor),
                    children: [
                      TextSpan(
                        text: phone,
                        style: p5.copyWith(color: blackColor),
                      ),
                      TextSpan(
                        text:
                            ' chưa được liên kết với địa chỉ Email Vui lòng gọi hỗ trợ kỹ thuật để được lấy lại mật khẩu',
                        style: p6.copyWith(color: blackColor),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: sp32),
        SizedBox(
          width: double.infinity,
          child: MainButton(
            title: 'Gọi hỗ trợ kỹ thuật',
            event: onTapCallCentre,
            largeButton: true,
            icon: SvgPicture.asset(
              '${AssetsPath.icon}/ic_call_centre.svg',
              color: whiteColor,
            ),
          ),
        ),
        const SizedBox(height: sp24),
        SizedBox(
          width: double.infinity,
          child: Extrabutton(
            title: 'Quay lại',
            event: onTapBack,
            largeButton: true,
            borderColor: borderColor_2,
            icon: null,
          ),
        ),
      ],
    );
  }
}
