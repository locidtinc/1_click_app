import 'dart:async';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

@RoutePage()
class ProductBarCodeScanPage extends StatefulWidget {
  const ProductBarCodeScanPage({
    super.key,
    required this.onScanEvent,
  });

  final Function(String? barcode) onScanEvent;

  @override
  State<ProductBarCodeScanPage> createState() => _ProductBarCodeScanPageState();
}

class _ProductBarCodeScanPageState extends State<ProductBarCodeScanPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  bool debounce = false;

  Timer? timer;

  String barcodePrevious = '';

  // Future<void> _getVariantByScanBarcod(String barcode) async {
  //   if (debounce) {
  //     return;
  //   }
  //   debounce = true;
  //   // await widget.orderCreateCubit.getVariantByScanBarcode(context, barcode);
  //   debounce = false;
  // }

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
      body: Stack(
        children: [
          SizedBox(
            width: widthDevice(context),
            height: heightDevice(context),
            child: _buildQrView(context),
          ),
          Positioned(
            top: sp32,
            left: sp16,
            child: GestureDetector(
              onTap: () => context.router.pop(),
              child: CircleAvatar(
                radius: sp24,
                backgroundColor: greyColor.withOpacity(0.5),
                child: const Icon(
                  Icons.close_rounded,
                  color: whiteColor,
                  size: sp24,
                ),
              ),
            ),
          ),
        ],
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

  // void _onQRViewCreated(QRViewController controller) {
  //   this.controller = controller;
  //   controller.scannedDataStream.listen((scanData) {
  //     if (scanData.code == barcodePrevious) return;
  //     barcodePrevious = scanData.code ?? '';
  //     timer ??= Timer(const Duration(milliseconds: 100), () async {
  //       await widget.onScanEvent.call(scanData.code);
  //       if (scanData.code != null) {
  //         context.router.pop();
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             backgroundColor: green_1,
  //             content: Text(
  //               'Thêm mã code: ${scanData.code}',
  //               style: p5.copyWith(color: whiteColor),
  //             ),
  //           ),
  //         );
  //       }
  //       timer = null;
  //     });
  //   });
  // }
  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (scanData.code == barcodePrevious) return;
      barcodePrevious = scanData.code ?? '';
      timer ??= Timer(const Duration(milliseconds: 100), () async {
        await widget.onScanEvent.call(scanData.code);
        if (!mounted) return;
        if (scanData.code != null) {
          context.router.pop();
          await Future.delayed(const Duration(milliseconds: 100));
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: green_1,
              content: Text(
                'Thêm mã code: ${scanData.code}',
                style: p5.copyWith(color: whiteColor),
              ),
            ),
          );
        }
        timer = null;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
    timer?.cancel();
  }
}
