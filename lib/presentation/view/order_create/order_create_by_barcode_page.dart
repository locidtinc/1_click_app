import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_click/presentation/base/app_bar.dart';
import 'package:one_click/presentation/routers/router.gr.dart';

import '../../../shared/utils/event.dart';
import 'child/camera_scan_view.dart';
import 'child/type_barcode_view.dart';
import 'cubit/order_create_cubit.dart';
import 'cubit/order_create_state.dart';

enum PageBarCode { camera, typeBarcode }

@RoutePage()
class OrderCreateByBarcodePage extends StatefulWidget {
  const OrderCreateByBarcodePage({super.key, required this.orderCreateCubit});

  final OrderCreateCubit orderCreateCubit;

  @override
  State<OrderCreateByBarcodePage> createState() =>
      _OrderCreateByBarcodePageState();
}

class _OrderCreateByBarcodePageState extends State<OrderCreateByBarcodePage> {
  var pageValue = PageBarCode.camera;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(title: 'Quét mã vạch'),
      body: Container(
        height: heightDevice(context),
        width: widthDevice(context),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CupertinoSlidingSegmentedControl<PageBarCode>(
                padding:
                    const EdgeInsets.symmetric(vertical: sp8, horizontal: sp16),
                thumbColor: borderColor_1,
                backgroundColor: whiteColor,
                groupValue: pageValue,
                children: {
                  PageBarCode.camera: Container(
                    width: widthDevice(context) / 2,
                    padding: const EdgeInsets.all(sp12),
                    child: Text(
                      'Máy ảnh',
                      style: p5.copyWith(
                        color: pageValue == PageBarCode.camera
                            ? blackColor
                            : greyColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  PageBarCode.typeBarcode: Text(
                    'Nhập mã vạch',
                    style: p5.copyWith(
                      color: pageValue == PageBarCode.typeBarcode
                          ? blackColor
                          : greyColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                },
                onValueChanged: (value) {
                  if (value != null) {
                    setState(() {
                      pageValue = value;
                    });
                  }
                },
              ),
              pageValue == PageBarCode.camera
                  ? CameraScanView(
                      orderCreateCubit: widget.orderCreateCubit,
                    )
                  : TypeBarcodeView(
                      orderCreateCubit: widget.orderCreateCubit,
                    )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: whiteColor,
          boxShadow: [
            BoxShadow(
              color: greyColor.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 40),
            ),
          ],
        ),
        padding: const EdgeInsets.all(sp16).copyWith(bottom: sp24),
        width: widthDevice(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  BlocBuilder<OrderCreateCubit, OrderCreateState>(
                    bloc: widget.orderCreateCubit,
                    builder: (context, state) {
                      return Text(
                        '${state.listVariantSelect.length} sản phẩm',
                        style: p4.copyWith(color: greyColor),
                      );
                    },
                  ),
                  const SizedBox(
                    height: sp8,
                  ),
                  BlocBuilder<OrderCreateCubit, OrderCreateState>(
                    bloc: widget.orderCreateCubit,
                    builder: (context, state) {
                      return Text(
                        '${FormatCurrency(state.totalPrice)}đ',
                        style: p3.copyWith(color: mainColor),
                      );
                    },
                  )
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: MainButton(
                title: 'Tiếp tục',
                event: () => context.router.push(
                  OrderCreateConfirmRoute(
                    orderCreateCubit: widget.orderCreateCubit,
                  ),
                ),
                largeButton: true,
                icon: null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
