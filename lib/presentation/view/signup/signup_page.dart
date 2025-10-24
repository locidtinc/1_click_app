import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:one_click/presentation/routers/router.gr.dart';
import 'package:one_click/presentation/view/signup/cubit/signup_cubit.dart';
import 'package:one_click/presentation/view/signup/cubit/signup_state.dart';
import 'package:one_click/shared/constants/app_constant.dart';

import '../../di/di.dart';

@RoutePage()
class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return buildBody(context);
  }

  Widget buildBody(BuildContext context) {
    return BlocProvider<SignupCubit>(
      create: (_) => getIt.get<SignupCubit>(),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: bg_4,
          body: Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.1,
            ),
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
                  padding: const EdgeInsets.only(left: 24, right: 24, top: 64),
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: SingleChildScrollView(
                    child: BlocBuilder<SignupCubit, SignupState>(
                      builder: (context, state) {
                        final bloc = context.read<SignupCubit>();
                        return Form(
                          key: bloc.keyForm,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Đăng ký tài khoản',
                                style: h2,
                              ),
                              const SizedBox(
                                height: sp32,
                              ),
                              AppInput(
                                label: 'Số điện thoại',
                                hintText: 'Nhập số điện thoại',
                                textInputType: TextInputType.phone,
                                validate: bloc.validatePhoneNumber,
                                onChanged: bloc.changePhone,
                                maxLines: 1,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(12),
                                  FilteringTextInputFormatter.allow(
                                    RegExp(
                                      r'^\+?\d*',
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: sp16),
                              AppInput(
                                label: 'Mật khẩu',
                                hintText: 'Nhập mật khẩu',
                                validate: bloc.validatePassword,
                                show: state.showPassword,
                                isPassword: true,
                                maxLines: 1,
                                onChanged: bloc.changePassword,
                                suffixIcon: GestureDetector(
                                  onTap: bloc.toggleShowPassword,
                                  child: Padding(
                                    padding: const EdgeInsets.all(sp16),
                                    child: SvgPicture.asset(
                                      "${AssetsPath.icon}/login/${state.showPassword ? "ic_eye_close.svg" : "ic_eye.svg"}",
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: sp16),
                              AppInput(
                                label: 'Tên cửa hàng',
                                hintText: 'Nhập tên cửa hàng',
                                validate: bloc.validateStoreName,
                                onChanged: bloc.changeNameStore,
                              ),
                              const SizedBox(height: sp16),
                              AppInput(
                                label: 'Link cửa hàng',
                                hintText: 'Nhập tên link cửa hàng',
                                validate: bloc.validateWebsite,
                                onChanged: bloc.changeWebsite,
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.all(sp16),
                                  child: Text(
                                    AppConstant.endpointWebsite,
                                    style: p6,
                                  ),
                                ),
                              ),
                              const SizedBox(height: sp4),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    '${AssetsPath.icon}/ic_warning.svg',
                                    height: 18,
                                  ),
                                  const SizedBox(width: sp4),
                                  Text(
                                    'Link cửa hàng không thể thay đổi sau khi đăng ký',
                                    style: p7.copyWith(color: yellow_1),
                                  )
                                ],
                              ),
                              const SizedBox(height: sp16),
                              AppInput(
                                label: 'Người đại diện',
                                required: true,
                                hintText: 'Nhập tên người đại diện',
                                validate: bloc.validateFullName,
                                onChanged: bloc.onChangeDeputy,
                              ),
                              const SizedBox(height: sp16),
                              const Divider(
                                height: 1,
                                thickness: 1,
                                color: borderColor_1,
                              ),
                              const SizedBox(height: sp16),
                              state.address.isEmpty
                                  ? Row(
                                      children: [
                                        Expanded(
                                          flex: 5,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Thêm địa chỉ để xác định địa điểm bán hàng và vận chuyển',
                                                style: p7.copyWith(
                                                  color: greyColor,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              InkWell(
                                                onTap: () =>
                                                    bloc.onTapChangeAddress(
                                                  context,
                                                ),
                                                child: Text(
                                                  'Thêm địa chỉ',
                                                  style: p5.copyWith(
                                                    color: blue_1,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: sp32),
                                        SvgPicture.asset(
                                          '${AssetsPath.icon}/ic_location.svg',
                                        ),
                                      ],
                                    )
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('Địa chỉ', style: p5),
                                        const SizedBox(height: sp8),
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(sp16),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(sp8),
                                            border: Border.all(
                                              color: borderColor_2,
                                            ),
                                          ),
                                          child: Text(
                                            state.address,
                                            style: p6,
                                          ),
                                        ),
                                      ],
                                    ),
                              const SizedBox(height: sp24),
                              SizedBox(
                                width: double.infinity,
                                child: MainButton(
                                  title: 'Đăng ký',
                                  event: () => bloc.register(context),
                                  largeButton: true,
                                  icon: null,
                                ),
                              ),
                              const SizedBox(height: sp24),
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
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(bottom: sp24),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Bạn có tài khoản? ',
                    style: p6.copyWith(color: blackColor),
                  ),
                  TextSpan(
                    text: 'Trở lại đăng nhập',
                    style: p5.copyWith(color: blue_1),
                    recognizer: TapGestureRecognizer()
                      ..onTap =
                          () => context.router.replace(const LoginV2Route()),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
