import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:one_click/data/models/payload/signup_payload.dart';
import 'package:one_click/gen/assets.dart';
import 'package:one_click/presentation/base/custom_btn.dart';
import 'package:one_click/presentation/base/input_column.dart';
import 'package:one_click/presentation/config/bloc/bloc_status.dart';
import 'package:one_click/presentation/routers/router.gr.dart';
import 'package:one_click/presentation/view/authen/components/choose_address.dart';
import 'package:one_click/presentation/view/authen/models/confirm_account_payload.dart';
import 'package:one_click/shared/ext/index.dart';
// import 'package:video_player/video_player.dart';

import '../../config/app_style/init_app_style.dart';
import '../../config/bloc/init_state.dart';
import 'blocs/confirm_account_bloc.dart';
import 'components/back_view.dart';

@RoutePage()
class ConfirmAccountPage extends StatefulWidget {
  final ConfirmAccountPayload account;
  const ConfirmAccountPage({
    super.key,
    required this.account,
  });

  @override
  State<ConfirmAccountPage> createState() => _ConfirmAccountPageState();
}

class _ConfirmAccountPageState extends State<ConfirmAccountPage> {
  final bloc = ConfirmAccountBloc();
  final formKey = GlobalKey<FormState>();
  // late VideoPlayerController _controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc.showVideo();
    // _controller = VideoPlayerController.asset(
    //   MyAssets.videoInfo,
    // )..initialize().then((_) {
    //     _controller.play();
    //     setState(() {});
    //   });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyF5,
      body: BlocConsumer<ConfirmAccountBloc, CubitState>(
        bloc: bloc,
        listener: (context, state) {
          if (state.status == BlocStatus.success &&
              state.isFirst &&
              state.total == 0) {
            // _controller.pause();
          }
        },
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              context.padding.top.height,
              Center(
                child: state.total != 0
                    ? _videoView()
                    : SingleChildScrollView(
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
          );
        },
      ),
    );
  }

  Widget _videoView() {
    // return AspectRatio(
    //   aspectRatio: _controller.value.aspectRatio,
    //   child: VideoPlayer(
    //     _controller,
    //   ),
    // ).padding(24.pading);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // if (_controller.value.isInitialized)
        //   AspectRatio(
        //     aspectRatio: _controller.value.aspectRatio,
        //     child: VideoPlayer(
        //       _controller,
        //     ),
        //   ).padding(24.pading),
        // 16.height,
        CustomBtn(
          onPressed: bloc.state.total > 0
              ? null
              : () {
                  bloc.skipVideo();
                },
          title:
              'Bỏ qua${bloc.state.total > 0 ? " (${bloc.state.total}s)" : ""}',
          backgroundColor: bloc.state.total > 0
              ? AppColors.button_brand_alpha_backgroundDisabled
              : AppColors.brand,
          textStyle: AppStyle.bodyBsMedium.copyWith(
            color: AppColors.white,
          ),
        ).size(height: 45),
      ],
    );
  }

  Widget _buildView() {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Xác minh thông tin',
            style: AppStyle.headingMd,
          ),
          24.height,
          InputColumn(
            label: 'Số điện thoại',
            isRequired: true,
            textInputType: TextInputType.phone,
            initialValue: widget.account.phone,
            readOnly: true,
          ),
          16.height,
          InputColumn(
            label: 'Mật khẩu',
            isRequired: true,
            maxLines: 1,
            isPassword: true,
            textInputType: TextInputType.visiblePassword,
            onChanged: (p0) => widget.account.password = p0,
          ),
          16.height,
          InputColumn(
            label: 'Tên cửa hàng',
            initialValue: widget.account.shopName,
            onChanged: (p0) => widget.account.shopName = p0,
          ),
          16.height,
          InputColumn(
            label: 'Người đại diện',
            initialValue: widget.account.fullName,
            onChanged: (p0) => widget.account.fullName = p0,
            isRequired: true,
          ),
          16.height,
          FormField(
            validator: (value) {
              if (widget.account.address?.province == null) {
                return 'Không bỏ trống';
              }
              return null;
            },
            builder: (field) {
              return ChooseAddress(
                address: widget.account.address,
                onTap: () {
                  context
                      .pushRoute(
                    AddressV2Route(address: widget.account.address),
                  )
                      .then((value) {
                    if (value is AddressDataPayload) {
                      setState(() {
                        widget.account.address = value;
                      });
                    }
                  });
                },
              );
            },
          ),
          16.height,
          CustomBtn(
            title: 'Xác nhận',
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                bloc.confirm(context, widget.account);
              }
            },
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
