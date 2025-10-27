import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_click/gen/assets.dart';
import 'package:one_click/presentation/base/checkbox_title.dart';
import 'package:one_click/presentation/config/app_style/init_app_style.dart';
import 'package:one_click/presentation/config/bloc/init_state.dart';
import 'package:one_click/presentation/di/di.dart';
import 'package:one_click/presentation/routers/router.gr.dart';
import 'package:one_click/presentation/shared_view/widget/fa_icon.dart';
import 'package:one_click/presentation/view/authen/blocs/auth_bloc.dart';
import 'package:one_click/shared/constants/fa_code.dart';
import 'package:one_click/shared/ext/index.dart';

import '../../config/bloc/bool_bloc.dart';
import '../login/cubit/login_cubit.dart';

//Ndm2205@1234
@RoutePage()
class LoginV2Page extends StatefulWidget {
  const LoginV2Page({super.key});

  @override
  State<LoginV2Page> createState() => _LoginV2PageState();
}

class _LoginV2PageState extends State<LoginV2Page> {
  final phone = TextEditingController();
  final password = TextEditingController();

  final boolBloc = BoolBloc();
  final authBloc = AuthBloc();
  final loginBloc = getIt.get<LoginCubit>();
  bool isRemember = false;
  final _keyForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    boolBloc.toggle(value: false);
  }

  @override
  void dispose() {
    phone.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthBloc, CubitState>(
        bloc: authBloc,
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _keyForm,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (context.height * 0.15).height,
                  Image.asset(
                    'assets/imgs/logo_1click.png',
                    width: 96,
                    height: 99,
                  ),
                  (context.height * 0.15).height,
                  Visibility(
                    visible: !authBloc.isActive,
                    child: _buildInput(
                      hintText: 'Nhập số điện thoại',
                      label: 'Số điện thoại',
                      controller: phone,
                      textInputType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      onConfirm: (value) {
                        if (_keyForm.currentState?.validate() ?? false) {
                          authBloc.check(
                            context,
                            phone: phone.text,
                          );
                        }
                      },
                      suffixOnTap: () {
                        context.hideKeyboard();
                        if (_keyForm.currentState?.validate() ?? false) {
                          authBloc.check(
                            context,
                            phone: phone.text,
                          );
                        }
                      },
                    ),
                  ),
                  8.height,
                  Visibility(
                    visible: authBloc.isActive == false,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        MainButton(
                          title: 'Tiếp tục',
                          event: () {
                            context.hideKeyboard();
                            if (_keyForm.currentState?.validate() ?? false) {
                              authBloc.check(
                                context,
                                phone: phone.text,
                              );
                            }
                          },
                          largeButton: true,
                          icon: null,
                        ).expanded(),
                      ],
                    ),
                  ),
                  BlocBuilder<BoolBloc, bool>(
                    bloc: boolBloc,
                    builder: (context, state) {
                      return Visibility(
                        visible: authBloc.isActive,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildInput(
                              hintText: 'Nhập mật khẩu',
                              label: 'Mật khẩu',
                              controller: password,
                              show: state,
                              onHidePass: boolBloc.toggle,
                              inputFormatters: [],
                              textInputType: TextInputType.visiblePassword,
                              onConfirm: (value) {
                                if (_keyForm.currentState?.validate() ??
                                    false) {
                                  loginBloc.setData(
                                    isRemember: isRemember,
                                    email: phone.text,
                                    password: password.text,
                                  );
                                  loginBloc.login(
                                    context,
                                  );
                                }
                              },
                              suffixOnTap: () {
                                context.hideKeyboard();

                                if (_keyForm.currentState?.validate() ??
                                    false) {
                                  loginBloc.setData(
                                    isRemember: isRemember,
                                    email: phone.text,
                                    password: password.text,
                                  );
                                  loginBloc.login(
                                    context,
                                  );
                                }
                              },
                              prefixOnTap: () {
                                password.clear();
                                context.hideKeyboard();
                                authBloc.isActive = false;
                              },
                            ),
                            8.height,
                            Visibility(
                              visible: authBloc.isActive,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Extrabutton(
                                      title: 'Quay lại',
                                      event: () {
                                        password.clear();
                                        context.hideKeyboard();
                                        authBloc.isActive = false;
                                      },
                                      borderColor: borderColor_3,
                                      largeButton: true,
                                      icon: null,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: MainButton(
                                      title: 'Đăng nhập',
                                      event: () {
                                        context.hideKeyboard();
                                        if (_keyForm.currentState?.validate() ??
                                            false) {
                                          loginBloc.setData(
                                            isRemember: isRemember,
                                            email: phone.text,
                                            password: password.text,
                                          );
                                          loginBloc.login(context);
                                        }
                                      },
                                      largeButton: true,
                                      icon: null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            8.height,
                            Row(
                              children: [
                                CheckBoxTitle(
                                  value: isRemember,
                                  onChange: (value) {
                                    isRemember = value;
                                  },
                                  title: 'Ghi nhớ mật khẩu',
                                  padding: 4.pading,
                                ).expanded(),
                                InkWell(
                                  onTap: () => context.pushRoute(
                                    OtpRoute(
                                      phone: phone.text,
                                      isResetPass: true,
                                    ),
                                  ),
                                  child: Text(
                                    'Quên mật khẩu?',
                                    style: AppStyle.bodyBsMedium.copyWith(
                                      color: AppColors.blue70,
                                    ),
                                  ).padding(4.pading),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  // SizedBox(
                  //   width: double.infinity,
                  //   child: MainButton(
                  //     title: 'Đăng nhập',
                  //     event: () => loginBloc.login(
                  //       context,
                  //     ),
                  //     largeButton: true,
                  //     icon: null,
                  //   ),
                  // ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInput({
    required String hintText,
    String? label,
    TextEditingController? controller,
    TextInputType textInputType = TextInputType.text,
    Function()? suffixOnTap,
    Function()? prefixOnTap,
    Function()? onHidePass,
    Function(String? value)? onConfirm,
    List<TextInputFormatter>? inputFormatters,
    bool show = true,
  }) {
    return AppInput(
      controller: controller,
      hintText: hintText,
      label: label,
      borderColor: AppColors.input_borderDefault,
      textInputType: textInputType,
      show: show,
      maxLines: 1,
      onConfirm: onConfirm,
      backgroundColor: Colors.white,
      inputFormatters: inputFormatters,
      suffixIcon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (textInputType == TextInputType.visiblePassword &&
              onHidePass != null)
            InkWell(
              onTap: onHidePass,
              child: FaIcon(
                code: show ? FaCode.eye : FaCode.eyeSlash,
                color: borderColor_4,
                size: 16,
              ).size(width: 24),
            ),
          8.width,
          //     if (suffixOnTap != null)
          //       Container(
          //         width: 32,
          //         height: 32,
          //         decoration: BoxDecoration(
          //           color: mainColor,
          //           shape: BoxShape.circle,
          //           boxShadow: [
          //             BoxShadow(
          //               color: Colors.black.withOpacity(0.1),
          //               blurRadius: 4,
          //               offset: const Offset(0, 2),
          //             ),
          //           ],
          //         ),
          //         child: IconButton(
          //           padding: EdgeInsets.zero,
          //           onPressed: suffixOnTap,
          //           icon: FaIcon(
          //             code: FaCode.anglesRight,
          //             color: whiteColor,
          //             size: 16,
          //           ),
          //         ),
          //       ),
          //     8.width,
          //   ],
          // ),
          // prefixIcon: prefixOnTap == null
          //     ? null
          //     : Row(
          //         mainAxisSize: MainAxisSize.min,
          //         children: [
          //           8.width,
          //           Container(
          //             width: 32,
          //             height: 32,
          //             decoration: BoxDecoration(
          //               color: mainColor,
          //               shape: BoxShape.circle,
          //               boxShadow: [
          //                 BoxShadow(
          //                   color: Colors.black.withOpacity(0.1),
          //                   blurRadius: 4,
          //                   offset: const Offset(0, 2),
          //                 ),
          //               ],
          //             ),
          //             child: IconButton(
          //               padding: EdgeInsets.zero,
          //               onPressed: prefixOnTap,
          //               icon: FaIcon(
          //                 code: FaCode.anglesLeft,
          //                 color: whiteColor,
          //                 size: 16,
          //               ),
          //             ),
          //           ),
        ],
      ),
      validate: (value) {
        if (value.validator.trim().isEmptyOrNull) {
          return 'Không bỏ trống';
        }

        if (value!.isNotEmpty) {
          return value.validatorTextField(type: textInputType);
        }
        return null;
      },
    );
  }
}
