import 'package:auto_route/annotations.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:one_click/presentation/base/app_bar.dart';
import 'package:one_click/presentation/base/card_base.dart';
import 'package:one_click/presentation/di/di.dart';
import 'package:one_click/presentation/view/change_password/cubit/change_password_cubit.dart';
import 'package:one_click/presentation/view/change_password/cubit/change_password_state.dart';

@RoutePage()
class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(title: 'Đổi mật khẩu'),
      backgroundColor: bg_4,
      body: BlocProvider<ChangePasswordCubit>(
        create: (_) => getIt.get<ChangePasswordCubit>(),
        child: BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
          builder: (context, state) {
            final bloc = context.read<ChangePasswordCubit>();
            return Column(
              children: [
                Expanded(
                  child: Form(
                    key: bloc.keyForm,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          CardBase(
                            margin:
                                const EdgeInsets.symmetric(horizontal: sp16) +
                                    const EdgeInsets.only(top: sp24),
                            child: Column(
                              children: [
                                AppInput(
                                  label: 'Mật khẩu hiện tại',
                                  hintText: 'Nhập mật khẩu hiện tại',
                                  validate: bloc.validateCurrentPassword,
                                  show: false,
                                  maxLines: 1,
                                  onChanged: bloc.changeCurrentPassword,
                                ),
                                const SizedBox(height: sp16),
                                AppInput(
                                  label: 'Mật khẩu mới',
                                  hintText: 'Nhập mật khẩu mới',
                                  show: state.showPassword,
                                  validate: bloc.validatePassword,
                                  maxLines: 1,
                                  onChanged: bloc.changeNewPassword,
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
                                  label: 'Xác nhận mật khẩu mới',
                                  hintText: 'Nhập lại mật khẩu mới để xác nhận',
                                  validate: bloc.validateConfirmPassword,
                                  show: false,
                                  maxLines: 1,
                                  onChanged: bloc.changeConfirmPassword,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                TwoButtonBox(
                  extraTitle: 'Huỷ bỏ',
                  mainTitle: 'Xác nhận',
                  mainOnTap: () => bloc.onTapChangePassword(context),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
