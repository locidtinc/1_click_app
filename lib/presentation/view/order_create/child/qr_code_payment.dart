import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:one_click/domain/entity/qr_code_payment.dart';
import 'package:one_click/presentation/routers/router.gr.dart';
import 'package:one_click/presentation/view/order_create/cubit/order_create_cubit.dart';
import 'package:one_click/presentation/view/order_create/cubit/order_create_state.dart';
import 'package:one_click/shared/utils/event.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodePaymentView extends StatelessWidget {
  const QrCodePaymentView({
    super.key,
    required this.qrCodePayment,
    required this.orderCreateCubit,
  });

  final OrderCreateCubit orderCreateCubit;
  final QrCodePayment qrCodePayment;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(sp16),
        ),
        child: Container(
          width: widthDevice(context) - sp32,
          padding: const EdgeInsets.all(sp24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(sp16),
            color: whiteColor,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('QR thanh toán', style: p1),
                  GestureDetector(
                    onTap: () => context.router.popUntil(
                      (route) => route.settings.name == 'OrderManagerRoute',
                    ),
                    child:
                        const Icon(Icons.close, size: sp16, color: greyColor),
                  ),
                ],
              ),
              const SizedBox(height: sp24),
              Text(
                'Số tiền thanh toán',
                style: p7.copyWith(color: greyColor),
              ),
              const SizedBox(height: sp8),
              Text(
                FormatCurrency(int.parse(qrCodePayment.amount ?? '0')),
                style: h2.copyWith(color: mainColor),
              ),
              const SizedBox(height: sp24),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(sp16),
                  border: Border.all(color: borderColor_2),
                ),
                padding: const EdgeInsets.all(sp24),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: QrImageView(
                    data: qrCodePayment.qrCode ?? '',
                    version: QrVersions.auto,
                  ),
                ),
              ),
              const SizedBox(height: sp24),
              SizedBox(
                width: double.infinity,
                child: MainButton(
                  title: 'Xác nhận thanh toán',
                  event: () => confirmPayment(context),
                  largeButton: true,
                  icon: null,
                ),
              )
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
    await orderCreateCubit.updatePayment(context);
  }
}
