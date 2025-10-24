import 'dart:io';
import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:one_click/domain/entity/order_detail.dart';
import 'package:one_click/presentation/base/app_bar.dart';
import 'package:one_click/presentation/di/di.dart';
import 'package:one_click/presentation/routers/router.gr.dart';
import 'package:one_click/presentation/view/order_create/cubit/order_create_state.dart';
import 'package:one_click/shared/constants/enum/status_payment_order.dart';
import 'package:one_click/shared/utils/event.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
// import 'package:share_plus/share_plus.dart';

import 'cubit/bill_detail_cubit.dart';
import 'cubit/bill_detail_state.dart';

@RoutePage()
class BillDetailPage extends StatelessWidget {
  BillDetailPage({
    super.key,
    required this.orderDetailEntity,
    required this.typeOrder,
  });

  final OrderDetailEntity orderDetailEntity;
  final TypeOrder typeOrder;

  final myBloc = getIt.get<BillDetailCubit>();
  final _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BillDetailCubit>(
      create: (context) => myBloc
        ..orderDetailEntityChange(orderDetailEntity)
        ..typeOrderChange(typeOrder),
      child: Scaffold(
        backgroundColor: bg_4,
        appBar: const BaseAppBar(
          title: 'Chi tiết hóa đơn',
        ),
        body: Container(
          width: widthDevice(context),
          height: heightDevice(context),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: sp24),
            physics: const BouncingScrollPhysics(),
            child: RepaintBoundary(
              key: _globalKey,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: sp24,
                  horizontal: sp16,
                ),
                color: whiteColor,
                child: BlocBuilder<BillDetailCubit, BillDetailState>(
                  builder: (context, state) {
                    print(
                        '  state.orderDetailEntity ${state.orderDetailEntity?.toJson()}');
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          Text(
                            state.typeOrder == TypeOrder.ad
                                ? 'Nhà cung cấp MYKIOT'
                                : 'Cửa hàng tạp hoá',
                            style: p5.copyWith(color: blackColor),
                          ),
                          const SizedBox(height: sp8),
                          Text(
                            state.orderDetailEntity?.shopData?.address ??
                                'Chưa có thông tin',
                            style: p6.copyWith(color: blackColor),
                          ),
                          const SizedBox(height: sp8),
                          Text(
                            'SĐT: ${state.orderDetailEntity?.shopData?.phone ?? 'Chưa có thông tin'}',
                            style: p6.copyWith(color: blackColor),
                          ),
                          const SizedBox(height: sp8),
                          Text(
                            '------------------------------------',
                            style: p6.copyWith(color: greyColor),
                          ),
                          const SizedBox(height: sp8),
                          Text(
                            state.typeOrder == TypeOrder.ad
                                ? 'Hoá đơn đặt hàng'
                                : 'Hoá đơn thanh toán',
                            style: p3.copyWith(color: blackColor),
                          ),
                          const SizedBox(height: sp12),
                          Text(
                            'Mã đơn hàng: ${state.orderDetailEntity?.code}',
                            style: p6.copyWith(color: blackColor),
                          ),
                          const SizedBox(height: sp12),
                          Text(
                            'Thời gian: ${state.orderDetailEntity?.createAt}',
                            style: p6.copyWith(color: blackColor),
                          ),
                          const SizedBox(height: sp20),
                          const Divider(
                            height: 1,
                            color: greyColor,
                          ),
                          const SizedBox(height: sp12),
                          SizedBox(
                            width: double.infinity,
                            child: RichText(
                              textAlign: TextAlign.left,
                              text: TextSpan(
                                text: 'Khách hàng: ',
                                style: p6.copyWith(color: blackColor),
                                children: [
                                  TextSpan(
                                    text: state.orderDetailEntity?.customerData
                                            ?.fullName ??
                                        'Khách lẻ',
                                    style: p5.copyWith(color: blackColor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: sp12),
                          const Divider(
                            height: 1,
                            color: greyColor,
                          ),
                          const SizedBox(height: sp20),
                          buildRowItem(
                            context,
                            'Tên sản phẩm',
                            'Đ.Giá',
                            'SL',
                            'ĐVT',
                            'TT',
                            p5,
                          ),
                          const SizedBox(height: sp20),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final variant =
                                  state.orderDetailEntity?.variants[index];
                              return buildRowItem(
                                context,
                                variant?.name ?? '',
                                FormatCurrency(variant?.priceSell ?? 0),
                                'x${variant?.amount}',
                                '${variant?.unitSell}',
                                FormatCurrency(
                                  ((variant?.priceSell ?? 0) *
                                      (variant?.amount ?? 0)),
                                ),
                                p6,
                              );
                            },
                            separatorBuilder: (context, index) => const Divider(
                              height: sp24,
                              color: borderColor_2,
                            ),
                            itemCount:
                                state.orderDetailEntity?.variants.length ?? 0,
                          ),
                          const SizedBox(height: sp20),
                          const Divider(
                            height: 1,
                            color: greyColor,
                          ),
                          const SizedBox(height: sp20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Tổng cộng',
                                style: p1.copyWith(color: blackColor),
                              ),
                              Text(
                                FormatCurrency(
                                  state.orderDetailEntity?.total ?? 0,
                                ),
                                style: p1.copyWith(color: blackColor),
                              ),
                            ],
                          ),
                          const SizedBox(height: sp16),
                          Text(
                            '- - - - - - - - - - - - - - - - - - - -',
                            style: p6.copyWith(color: greyColor),
                          ),
                          const SizedBox(height: sp16),
                          const Text(
                            'Xin cảm ơn và hẹn gặp lại quý khách!',
                            style: p6,
                          ),
                          const SizedBox(height: sp12),
                          const Text(
                            'Powered by MYKIOS',
                            style: p6,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: Material(
          elevation: 5,
          child: Container(
            color: whiteColor,
            padding: const EdgeInsets.all(sp16),
            child: BlocBuilder<BillDetailCubit, BillDetailState>(
              builder: (context, state) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Hình thức thanh toán',
                          style: p4,
                        ),
                        Text(
                          state.orderDetailEntity?.statusPayment.title
                                      .contains(StatusPayment.qrCode.title) ??
                                  false
                              ? 'Thanh toán QR'
                              : 'Tiền mặt',
                          style: p3,
                        ),
                      ],
                    ),
                    const SizedBox(height: sp12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Tổng cộng',
                          style: p4,
                        ),
                        Text(
                          '${FormatCurrency(state.orderDetailEntity?.total ?? 0)}đ',
                          style: p3.copyWith(color: mainColor),
                        ),
                      ],
                    ),
                    const SizedBox(height: sp24),
                    Row(
                      children: [
                        Visibility(
                          visible: state.typeOrder == TypeOrder.ad,
                          child: Expanded(
                            child: Extrabutton(
                              title: 'Tạo đơn hàng mới',
                              event: () => context.router
                                  .push(OrderCreateRoute(typeOrder: typeOrder)),
                              largeButton: true,
                              borderColor: borderColor_2,
                              icon: null,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: state.typeOrder == TypeOrder.ad,
                          child: const SizedBox(
                            width: sp16,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: TwoButtonBox(
                            // mainOnTap: () => _shareImageBill(),
                            extraOnTap: () => _shareImageBill(),
                            mainTitle: 'In hoá đơn',
                            extraTitle: 'Gửi hóa đơn',
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget buildRowItem(
    BuildContext context,
    String text1,
    String text2,
    String text3,
    String text4,
    String text5,
    TextStyle textStyle,
  ) {
    return SizedBox(
      width: widthDevice(context),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              text1,
              style: textStyle,
            ),
          ),
          const SizedBox(width: sp16),
          Expanded(
            flex: 5,
            child: Text(
              text2,
              style: textStyle,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: sp16),
          Expanded(
            flex: 2,
            child: Text(
              text3,
              style: textStyle,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: sp16),
          Expanded(
            flex: 2,
            child: Text(
              text4,
              style: textStyle,
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(width: sp16),
          Expanded(
            flex: 5,
            child: Text(
              text5,
              style: textStyle,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _shareImageBill() async {
    final boundary =
        _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage();
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();

    // Lấy thư mục tạm thời để lưu tệp tin hình ảnh
    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/bill.png';

    final xfile = await File(filePath).writeAsBytes(pngBytes);
    Share.shareXFiles([XFile(xfile.path)]);
  }
}
