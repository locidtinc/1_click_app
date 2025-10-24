import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_click/domain/entity/card.dart';
import 'package:one_click/domain/entity/order_detail.dart';
import 'package:one_click/domain/entity/qr_code_payment.dart';
import 'package:one_click/presentation/base/app_bar.dart';
import 'package:one_click/presentation/di/di.dart';
import 'package:one_click/presentation/routers/router.gr.dart';
import 'package:one_click/presentation/shared_view/widget/cache_image.dart';
import 'package:one_click/presentation/view/order_create/cubit/order_create_state.dart';
import 'package:one_click/presentation/view/qr_code_payment/cubit/qr_code_payment_state.dart';
import 'package:one_click/presentation/view/qr_code_payment/widget/qr_screen.dart';
import 'package:one_click/shared/ext/index.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../shared/utils/event.dart';
import 'cubit/qr_code_payment_cubit.dart';

@RoutePage()
class QrCodePaymentPage extends StatelessWidget {
  QrCodePaymentPage({
    super.key,
    required this.qrcodeInfo,
    required this.cardEntity,
    required this.orderDetailEntity,
    this.onConfirm,
  });

  final QrCodePayment? qrcodeInfo;
  final CardEntity? cardEntity;
  final OrderDetailEntity orderDetailEntity;
  final Function()? onConfirm;

  final myBloc = getIt.get<QrCodePaymentCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<QrCodePaymentCubit>(
      create: (context) => myBloc..getDetailOrder(orderDetailEntity),
      child: Scaffold(
        backgroundColor: bg_4,
        appBar: const BaseAppBar(title: 'QR thanh toán'),
        body: Container(
          height: heightDevice(context),
          width: widthDevice(context),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: sp24),
          child: BlocBuilder<QrCodePaymentCubit, QrCodePaymentState>(
            builder: (context, state) {
              return state.isLoading
                  ? const BaseLoading()
                  : SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          Text(
                            '${FormatCurrency(int.parse(qrcodeInfo?.amount ?? '0'))}đ',
                            style: h1.copyWith(
                              color: mainColor,
                            ),
                          ),
                          const SizedBox(height: sp16),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(sp16),
                              border: Border.all(color: borderColor_2),
                              color: whiteColor,
                            ),
                            padding: const EdgeInsets.all(sp24),
                            child: AspectRatio(
                              aspectRatio: 1,
                              // child: QrImageView(
                              //   data: qrcodeInfo?.qrCode ?? '',
                              //   version: QrVersions.auto,
                              // ),
                              child: QrScreen(
                                  bankAccount: cardEntity?.cardNumber ?? '',
                                  bankCode: cardEntity?.codeBank,
                                  totalFinal:
                                      qrcodeInfo?.amount.parseDouble ?? 0,
                                  code: orderDetailEntity.note),
                            ),
                          ),
                          const SizedBox(height: sp16),
                          // AspectRatio(
                          //   aspectRatio: 1,
                          //   child: BaseCacheImage(
                          //     url: qrcodeInfo?.qrLink ?? '',
                          //     fit: BoxFit.contain,
                          //   ),
                          // ),
                          const SizedBox(height: sp16),
                          Text(
                            cardEntity?.fullName ?? '',
                            style: p1.copyWith(color: greyColor),
                          ),
                          const SizedBox(height: sp16),
                          Text(
                            cardEntity?.cardNumber ?? '',
                            style: h3.copyWith(color: blackColor),
                          ),
                          const SizedBox(
                            width: 100,
                            child: Divider(height: sp32),
                          ),
                          Text(
                            'Nội dung thanh toán',
                            style: p5.copyWith(color: greyColor),
                          ),
                          const SizedBox(height: sp16),
                          Text(
                            orderDetailEntity.note,
                            style: p5,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
            },
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(sp16),
          color: whiteColor,
          child: Row(
            children: [
              Expanded(
                child: Extrabutton(
                  title: 'Chi tiết đơn',
                  event: () => context.router.push(
                    OrderDetailRoute(
                      order: myBloc.state.orderDetailEntity,
                      typeOrder: TypeOrder.cHTH,
                    ),
                  ),
                  largeButton: true,
                  borderColor: borderColor_2,
                  icon: null,
                ),
              ),
              const SizedBox(width: sp16),
              Expanded(
                child: MainButton(
                  title: 'Xác nhận',
                  event: () => confirmPayment(context),
                  largeButton: true,
                  icon: null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> confirmPayment(BuildContext context) async {
    DialogUtils.showLoadingDialog(
      context,
      content: 'Đang xác nhận thanh toán QR',
    );
    final res = await myBloc.updatePayment();
    await onConfirm?.call();
    Navigator.of(context).pop();
    if (context.mounted) {
      context.router
          .popUntil((route) => route.settings.name == 'OrderManagerRoute');
      context.router.push(
        OrderDetailRoute(
          order: orderDetailEntity.id,
          typeOrder: TypeOrder.cHTH,
        ),
      );
    }
  }
}
