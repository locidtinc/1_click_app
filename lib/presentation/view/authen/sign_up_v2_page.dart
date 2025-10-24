import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:one_click/presentation/base/custom_btn.dart';
import 'package:one_click/presentation/base/input_column.dart';
import 'package:one_click/presentation/config/bloc/init_state.dart';
import 'package:one_click/presentation/routers/router.gr.dart';
import 'package:one_click/presentation/view/authen/blocs/sign_bloc.dart';
import 'package:one_click/shared/ext/index.dart';

import '../../config/app_style/init_app_style.dart';
import '../../shared_view/address/address_widget.dart';
import 'components/back_view.dart';
import 'components/choose_address.dart';
import 'models/confirm_account_payload.dart';

@RoutePage()
class SignUpV2Page extends StatefulWidget {
  final String phone;
  const SignUpV2Page({super.key, required this.phone});

  @override
  State<SignUpV2Page> createState() => _SignUpV2PageState();
}

class _SignUpV2PageState extends State<SignUpV2Page> {
  final _keyForm = GlobalKey<FormState>();
  final bloc = SignV2Bloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc.payload.phone = widget.phone;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignV2Bloc, CubitState>(
      bloc: bloc,
      listener: (context, state) {
        CheckStateBloc.check(
          context,
          state,
          close: () => context.router.replace(
            const LoginV2Route(),
          ),
          success: () {
            context.router.replace(
              OtpRoute(
                phone: widget.phone,
                isCreate: true,
              ),
            );
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
            'Đăng ký tài khoản',
            style: AppStyle.headingMd,
          ),
          8.height,
          Text(
            'Số điện thoại chưa được đăng ký. Vui lòng đăng ký tài khoản để sử dụng MYKIOS.',
            style: AppStyle.bodyBsRegular.copyWith(
              color: AppColors.grey79,
            ),
          ),
          24.height,
          InputColumn(
            label: 'Số điện thoại',
            isRequired: true,
            initialValue: widget.phone,
            textInputType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            onChanged: (p0) => bloc.payload.phone = p0,
          ),
          16.height,
          InputColumn(
            label: 'Mật khẩu',
            isRequired: true,
            maxLines: 1,
            isPassword: true,
            textInputType: TextInputType.visiblePassword,
            onChanged: (p0) => bloc.payload.password = p0,
          ),
          16.height,
          InputColumn(
            label: 'Tên cửa hàng',
            isRequired: true,
            onChanged: (p0) => bloc.payload.shopName = p0,
          ),
          16.height,
          InputColumn(
            label: 'Người đại diện',
            isRequired: true,
            onChanged: (p0) => bloc.payload.name = p0,
          ),
          16.height,
          InputColumn(
            label: 'Website',
            onChanged: (p0) => bloc.payload.subdomain = p0,
          ),
          16.height,
          InputColumn(
            label: 'Mã số thuế',
            onChanged: (p0) => bloc.payload.taxCode = p0,
          ),
          16.height,
          InputColumn(
            label: 'Mã số kinh doanh',
            onChanged: (p0) => bloc.payload.businessCode = p0,
          ),
          16.height,
          InputColumn(
            label: 'Diện tích kho (m²)',
            onChanged: (p0) => bloc.payload.warehouseArea = p0,
          ),
          16.height,
          FormField(
            validator: (value) {
              if (bloc.payload.address?.province == null) {
                return 'Không bỏ trống';
              }
              return null;
            },
            builder: (field) {
              return ChooseAddress(
                errorText: field.errorText,
                address: bloc.payload.address,
                onTap: () {
                  context
                      .pushRoute(
                    AddressV2Route(
                      address: bloc.payload.address,
                    ),
                  )
                      .then((value) {
                    if (value is AddressDataPayload) {
                      setState(() {
                        bloc.payload.address = value;
                      });
                    }
                  });
                },
              );
            },
          ),
          16.height,
          InputColumn(
            label: 'Mã giới thiệu',
            onChanged: (p0) => bloc.payload.referralCode = p0,
          ),
          16.height,
          CustomBtn(
            onPressed: () {
              final valid = _keyForm.currentState?.validate() ?? false;
              if (valid) {
                bloc.sign();
              }
            },
            title: 'Đăng ký',
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
