import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:one_click/presentation/routers/router.gr.dart';
// import 'package:package_info_plus/package_info_plus.dart';

import '../../di/di.dart';
import 'cubit/login_cubit.dart';
import 'cubit/login_state.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final myBloc = getIt.get<LoginCubit>();

  late TextEditingController username;
  late TextEditingController password;

  @override
  void dispose() {
    username.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> initFirebase() async {
    // await Firebase.initializeApp();
    // await NotiService.intinializeNotiService(
    //   onSelect: (data) => onSelectNoti.call(data),
    // );
    // FirebaseMessaging.onBackgroundMessage(
    //   NotiService.firebaseMessagingBackroundHandler,
    // );
    // await NotiService.getDeviceToken();
  }

  Future<void> onSelectNoti(RemoteMessage data) async {
    context.router.push(const OrderManagerRoute());
  }

  @override
  void initState() {
    super.initState();

    initFirebase();

    username = TextEditingController();
    password = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return buildBody(context);
  }

  Widget buildBody(BuildContext context) {
    return BlocProvider<LoginCubit>(
      create: (_) => myBloc..init(),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: bg_4,
          resizeToAvoidBottomInset: true,
          body: Padding(
            padding: const EdgeInsets.only(top: 150),
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
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Đăng nhập',
                          // EnvironmentConfig.APP_NAME,
                          style: h2,
                        ),
                        // FutureBuilder<PackageInfo>(
                        //   future: PackageInfo.fromPlatform(),
                        //   builder: (context, snapshot) {
                        //     return Visibility(
                        //       visible: snapshot.data?.packageName ==
                        //           'com.idtinc.one.click.dev',
                        //       child: Text(
                        //         '-${snapshot.data?.packageName}-${EnvironmentConfig.BASE_URL}',
                        //       ),
                        //     );
                        //   },
                        // ),
                        const SizedBox(
                          height: sp32,
                        ),
                        BlocBuilder<LoginCubit, LoginState>(
                          builder: (context, state) {
                            if (username.text != state.email) {
                              username.text = state.email;
                            }
                            return AppInput(
                              controller: username,
                              label: 'Số điện thoại',
                              hintText: 'Nhập số điện thoại',
                              textInputType: TextInputType.phone,
                              validate: (value) {},
                              onChanged: (value) => myBloc.changePhone(value),
                            );
                          },
                        ),
                        const SizedBox(height: sp16),
                        BlocBuilder<LoginCubit, LoginState>(
                          builder: (context, state) {
                            if (password.text != state.password) {
                              password.text = state.password;
                            }
                            return AppInput(
                              controller: password,
                              label: 'Mật khẩu',
                              hintText: 'Nhập mật khẩu',
                              validate: (value) {},
                              show: state.showPassword,
                              isPassword: true,
                              maxLines: 1,
                              onChanged: (value) => context
                                  .read<LoginCubit>()
                                  .changePassword(value),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  myBloc.toggleShowPassword();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(sp16),
                                  child: SvgPicture.asset(
                                    "${AssetsPath.icon}/login/${state.showPassword ? "ic_eye_close.svg" : "ic_eye.svg"}",
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: sp16),
                        BlocBuilder<LoginCubit, LoginState>(
                          builder: (context, state) {
                            return Row(
                              children: [
                                BaseCheckbox(
                                  value: state.rememberPassword,
                                  onChanged: (value) => myBloc
                                      .changeRememberPassword(value ?? false),
                                ),
                                const SizedBox(width: sp12),
                                const Text(
                                  'Lưu mật khẩu',
                                  style: p6,
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: sp32),
                        BlocBuilder<LoginCubit, LoginState>(
                          builder: (context, state) => SizedBox(
                            width: double.infinity,
                            child: MainButton(
                              title: 'Đăng nhập',
                              event: () => myBloc.login(context),
                              largeButton: true,
                              icon: null,
                            ),
                          ),
                        ),
                        const SizedBox(height: sp24),
                        Align(
                          alignment: Alignment.center,
                          child: InkWell(
                            onTap: () => context.router
                                .replace(const ForgotPasswordRoute()),
                            child: Text(
                              'Quên mật khẩu',
                              style: p5.copyWith(color: blue_1),
                            ),
                          ),
                        ),
                        const SizedBox(height: sp32),
                      ],
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
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(bottom: sp24),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Bạn chưa có tài khoản? ',
                    style: p6.copyWith(color: blackColor),
                  ),
                  TextSpan(
                    text: 'Đăng ký ngay',
                    style: p5.copyWith(color: blue_1),
                    recognizer: TapGestureRecognizer()
                      ..onTap =
                          () => context.router.replace(const SignupRoute()),
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
