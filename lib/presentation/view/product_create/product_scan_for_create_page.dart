import 'dart:async';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:one_click/domain/entity/product_detail_entity.dart';
import 'package:one_click/presentation/view/product_create/cubit/product_create_cubit.dart';
import 'package:one_click/presentation/view/product_create/cubit/product_create_state.dart';
import 'package:one_click/shared/constants/pref_keys.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

@RoutePage()
class ProductScanForCreate extends StatefulWidget {
  const ProductScanForCreate({
    super.key,
    required this.onScanEvent,
    required this.productCreateCubit,
    this.onChoseProduct,
  });

  final Function(String? barcode) onScanEvent;
  final Function(ProductDetailEntity product)? onChoseProduct;
  final ProductCreateCubit productCreateCubit;

  @override
  State<ProductScanForCreate> createState() => _ProductScanForCreateState();
}

class _ProductScanForCreateState extends State<ProductScanForCreate> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  bool debounce = false;

  Timer? timer;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: widthDevice(context),
        height: heightDevice(context),
        child: _buildQrView(context),
      ),
      bottomNavigationBar: Container(
        width: widthDevice(context),
        padding: const EdgeInsets.symmetric(vertical: sp24, horizontal: sp24),
        child: Row(
          children: [
            SvgPicture.asset('${AssetsPath.icon}/ic_scan_btn.svg'),
            const SizedBox(width: sp8),
            Text(
              'Đặt mã vạch vào trong khung để quét',
              style: p3.copyWith(color: blackColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.white,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 3,
        cutOutWidth: 250,
        cutOutHeight: 120,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    // log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('')),
      // );
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (timer != null) return;
      timer ??= Timer(const Duration(seconds: 1), () {
        getProduct(scanData.code);
        timer?.cancel();
      });
    });
  }

  Future<void> getProduct(String? barCode) async {
    await widget.productCreateCubit.getProductByScan(barCode);
    // ignore: use_build_context_synchronously
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          enableDrag: false,
          builder: (BuildContext context) => Container(
            width: heightDevice(context) / 2,
            padding: const EdgeInsets.all(sp16),
            color: whiteColor,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Mã vạch: $barCode',
                    style: p5.copyWith(color: blackColor),
                  ),
                  const SizedBox(height: sp16),
                  BlocBuilder<ProductCreateCubit, ProductCreateState>(
                    bloc: widget.productCreateCubit,
                    builder: (context, state) {
                      final adminProducts = state.listProductScan
                          .where((p) => p.codeSystemData == 'ADMIN')
                          .toList();

                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final product = adminProducts[index];
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 56,
                                      height: 56,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(sp8),
                                        child: CachedNetworkImage(
                                          imageUrl: product.images.isNotEmpty
                                              ? product.images[0]
                                              : PrefKeys.imgProductDefault,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: sp16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product.title,
                                            style:
                                                p3.copyWith(color: blackColor),
                                          ),
                                          const SizedBox(height: sp12),
                                          Text(
                                            product.code,
                                            style:
                                                p4.copyWith(color: greyColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: sp16),
                                    MainButton(
                                      title: 'Chọn',
                                      event: () {
                                        widget.onChoseProduct?.call(product);
                                        context.router.popUntil(
                                          (route) =>
                                              route.settings.name ==
                                              'ProductCreateRoute',
                                        );
                                      },
                                      largeButton: true,
                                      icon: null,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                        separatorBuilder: (context, index) =>
                            const Divider(height: 32),
                        itemCount: adminProducts.length,
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: widthDevice(context),
                    child: Extrabutton(
                      title: 'Chỉ nhập mã vạch',
                      event: () => widget.onScanEvent.call(barCode),
                      largeButton: true,
                      borderColor: borderColor_2,
                      icon: null,
                    ),
                  ),
                ],
              ),
            ),
          ),
          onClosing: () {},
        );
      },
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
