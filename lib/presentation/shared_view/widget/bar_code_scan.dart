import 'dart:async';
import 'dart:io';

import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:one_click/presentation/view/order_create/cubit/order_create_cubit.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRViewExample extends StatefulWidget {
  const QRViewExample({
    super.key,
    required this.orderCreateCubit,
  });

  final OrderCreateCubit orderCreateCubit;

  @override
  State<QRViewExample> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  bool debounce = false;

  Timer? timer;

  String barcodePrevious = '';

  Future<void> _getVariantByScanBarcod(String barcode) async {
    if (debounce) {
      return;
    }
    debounce = true;
    await widget.orderCreateCubit.getVariantByScanBarcode(context, barcode);
    debounce = false;
  }

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
    return SizedBox(
      width: widthDevice(context),
      height: 300,
      child: _buildQrView(context),
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
      // _getVariantByScanBarcod(scanData.code ?? '');

      if (scanData.code == barcodePrevious) {
        Timer(const Duration(seconds: 3), () {
          barcodePrevious = '';
        });
        return;
      }
      barcodePrevious = scanData.code ?? '';
      timer ??= Timer(const Duration(milliseconds: 100), () async {
        await widget.orderCreateCubit
            .getVariantByScanBarcode(context, scanData.code ?? '');
        timer = null;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
