import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:one_click/presentation/config/bloc/init_state.dart';
import 'package:one_click/presentation/view/authen/blocs/otp_bloc.dart';
import 'package:one_click/presentation/view/authen/components/back_view.dart';
import 'package:one_click/shared/ext/index.dart';
import 'package:pinput/pinput.dart';

import '../../base/custom_btn.dart';
import '../../config/app_style/init_app_style.dart';

@RoutePage()
class OtpPage extends StatefulWidget {
  final String phone;
  final bool isCreate;
  final bool isResetPass;
  const OtpPage({
    super.key,
    required this.phone,
    this.isCreate = false,
    this.isResetPass = false,
  });

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final bloc = OtpBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc.send(
      context,
      widget.phone,
      isLoad: false,
      isCreate: widget.isCreate,
      isResetPass: widget.isResetPass,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }

  Widget _buildView() {
    return BlocBuilder<OtpBloc, CubitState>(
      bloc: bloc,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Nhập mã kích hoạt',
              style: AppStyle.headingMd,
            ),
            8.height,
            Text(
              widget.isCreate || widget.isResetPass
                  ? 'Vui lòng nhập mã kích hoạt được gửi từ Zalo của bạn.'
                  : 'Vui lòng nhập mã bảo mật OTP được gửi từ Zalo của bạn.',
              // : 'S/ố điện thoại đã đăng ký nhưng chưa được kích hoạt. Vui lòng nhập mã kích hoạt được gửi từ Zalo của bạn.',
              style: AppStyle.bodyBsRegular.copyWith(
                color: AppColors.grey79,
              ),
            ),
            24.height,
            Pinput(
              autofocus: true,
              length: 6,
              onChanged: (value) {},
              onCompleted: (value) {
                bloc.verify(
                  context,
                  phone: widget.phone,
                  otp: value,
                  isCreate: widget.isCreate,
                  isResetPass: widget.isResetPass,
                );
              },
              defaultPinTheme: PinTheme(
                width: context.width / 6,
                height: context.width / 8,
                textStyle: AppStyle.heading2xl.copyWith(
                  color: AppColors.grey79,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.input_borderDefault,
                  ),
                ),
              ),
              errorText: bloc.msg,
              errorTextStyle: AppStyle.bodyBsRegular.copyWith(
                color: AppColors.ultility_positive_60,
              ),
              forceErrorState: true,
              pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
            ),
            16.height,
            CustomBtn(
              onPressed: state.total > 0
                  ? null
                  : () => bloc.send(
                        context,
                        widget.phone,
                        isCreate: widget.isCreate,
                        isResetPass: widget.isResetPass,
                      ),
              title: 'Gửi lại mã${state.total > 0 ? " (${state.total}s)" : ""}',
              backgroundColor: state.total > 0
                  ? AppColors.button_brand_alpha_backgroundDisabled
                  : AppColors.brand,
              textStyle: AppStyle.bodyBsMedium.copyWith(
                color: AppColors.white,
              ),
            ).size(height: 45),
          ],
        );
      },
    );
  }
}
