import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:one_click/presentation/view/product_edit/widgets/synchronized_status.dart';

import '../../../routers/router.gr.dart';

class ProductInfoContainer extends StatefulWidget {
  const ProductInfoContainer({
    super.key,
    required this.expandableController,
    required this.priceImport,
    required this.priceSell,
    required this.barcode,
    required this.barcodeChange,
    required this.productName,
    required this.productNameChange,
    required this.priceImportChange,
    required this.priceSellChange,
    this.onScanBarcode,
    required this.statusSynchronizedSell,
    required this.statusSynchronizedImport,
    required this.onStatusSynchronizedImportChange,
    required this.onStatusSynchronizedSellChange,
  });

  final ExpandableController expandableController;
  final String priceImport;
  final String priceSell;
  final String barcode;
  final String productName;
  final bool statusSynchronizedSell;
  final bool statusSynchronizedImport;

  final Function(String value) barcodeChange;
  final Function(String value) productNameChange;
  final Function(String value) priceImportChange;
  final Function(String value) priceSellChange;
  final Function(String? barcode)? onScanBarcode;
  final Function(bool value) onStatusSynchronizedImportChange;
  final Function(bool value) onStatusSynchronizedSellChange;
  @override
  State<ProductInfoContainer> createState() => _ProductInfoContainerState();
}

class _ProductInfoContainerState extends State<ProductInfoContainer> {
  late TextEditingController barcodeTec;
  late TextEditingController priceImportTec;
  late TextEditingController priceSellTec;

  static const _locale = 'vi';
  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(int.parse(s));

  @override
  void initState() {
    super.initState();

    barcodeTec = TextEditingController(text: widget.barcode);
    priceImportTec = TextEditingController(text: widget.priceImport);
    priceSellTec = TextEditingController(text: widget.priceSell);

    final String priceSell =
        _formatNumber(widget.priceSell.replaceAll('.', ''));
    priceSellTec.value = TextEditingValue(
      text: priceSell,
      selection: TextSelection.collapsed(offset: priceSell.length),
    );

    final String priceImport =
        _formatNumber(widget.priceImport.replaceAll('.', ''));
    priceImportTec.value = TextEditingValue(
      text: priceImport,
      selection: TextSelection.collapsed(offset: priceImport.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      controller: widget.expandableController,
      child: ExpandablePanel(
        theme: const ExpandableThemeData(hasIcon: false),
        header: Container(
          padding: const EdgeInsets.all(sp16),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.vertical(
              top: const Radius.circular(sp8),
              bottom: Radius.circular(
                widget.expandableController.expanded ? sp0 : sp8,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Thông tin sản phẩm',
                style: p1,
              ),
              AnimatedRotation(
                turns: !widget.expandableController.expanded ? 0 : 0.5,
                duration: const Duration(milliseconds: 300),
                child: SvgPicture.asset(
                  '${AssetsPath.icon}/ic_arrow_down.svg',
                ),
              )
            ],
          ),
        ),
        collapsed: const SizedBox(),
        expanded: Container(
          padding: const EdgeInsets.all(sp16),
          decoration: const BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(sp8),
            ),
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 1,
                    child: AppInput(
                      controller: barcodeTec,
                      label: 'Mã vạch',
                      hintText: 'Nhập mã vạch',
                      validate: (value) {},
                      onConfirm: (value) {
                        widget.barcodeChange(value);
                      },
                      onChanged: (value) => widget.barcodeChange(value),
                    ),
                  ),
                  const SizedBox(width: sp8),
                  GestureDetector(
                    onTap: () => context.router.push(
                      ProductBarCodeScanRoute(
                        onScanEvent: (String? barcode) {
                          widget.onScanBarcode?.call(barcode);
                          setState(() {
                            barcodeTec.text = barcode ?? barcodeTec.text;
                          });
                          context.router.popUntil(
                            (route) =>
                                route.settings.name == 'ProductEditRoute',
                          );
                        },
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(sp16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(sp8),
                        border: Border.all(color: borderColor_2),
                      ),
                      child: SvgPicture.asset(
                        '${AssetsPath.icon}/ic_scan_btn.svg',
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: sp16),
              AppInput(
                initialValue: widget.productName,
                label: 'Tên sản phẩm',
                required: true,
                hintText: 'Nhập tên sản phẩm',
                validate: (value) {},
                onChanged: (value) => widget.productNameChange.call(value),
                textInputType: TextInputType.name,
              ),
              const SizedBox(height: sp16),
              InputCurrency(
                label: 'Giá bán',
                hintText: 'Nhập giá bán',
                controller: priceSellTec,
                validate: () {},
                onChanged: (value) => widget.priceSellChange.call(value),
              ),
              const SizedBox(height: sp8),
              SynchronizedStatus(
                title: 'bán',
                status: widget.statusSynchronizedSell,
                statusChange: (value) =>
                    widget.onStatusSynchronizedSellChange.call(value),
              ),
              const SizedBox(height: sp16),
              InputCurrency(
                label: 'Giá nhập',
                hintText: 'Nhập giá nhập',
                controller: priceImportTec,
                validate: () {},
                onChanged: (value) => widget.priceImportChange.call(value),
              ),
              const SizedBox(height: sp8),
              SynchronizedStatus(
                title: 'nhập',
                status: widget.statusSynchronizedImport,
                statusChange: (value) =>
                    widget.onStatusSynchronizedImportChange.call(value),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
