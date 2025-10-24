import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:one_click/presentation/base/switch.dart';

import '../../../../domain/entity/variant_create_product.dart';
import '../../../routers/router.gr.dart';

class VariantEditContainer extends StatefulWidget {
  const VariantEditContainer({
    super.key,
    required this.variant,
    required this.toggeCheckbox,
    required this.imagePicker,
    required this.barcodeChange,
    required this.amountChange,
    required this.priceImportChange,
    required this.priceSellChange,
  });

  final VariantCreateProductEntity variant;
  final Function(bool value) toggeCheckbox;
  final Function(File? image) imagePicker;
  final Function(String? value) barcodeChange;
  final Function(String value) amountChange;
  final Function(String value) priceImportChange;
  final Function(String value) priceSellChange;

  @override
  State<VariantEditContainer> createState() => _VariantEditContainerState();
}

class _VariantEditContainerState extends State<VariantEditContainer> {
  late ExpandableController expandableController;
  late TextEditingController priceImportTec;
  late TextEditingController priceSellTec;
  late TextEditingController barcodeTec;

  static const _locale = 'vi';
  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(int.parse(s));

  @override
  void initState() {
    super.initState();

    expandableController = ExpandableController(initialExpanded: true)
      ..addListener(() {
        setState(() {});
      });
    priceImportTec = TextEditingController();
    priceSellTec = TextEditingController();
    barcodeTec = TextEditingController(text: widget.variant.barcode);

    final String priceSell =
        _formatNumber(widget.variant.priceSell.replaceAll('.', ''));
    priceSellTec.value = TextEditingValue(
      text: priceSell,
      selection: TextSelection.collapsed(offset: priceSell.length),
    );

    final String priceImport =
        _formatNumber(widget.variant.priceImport.replaceAll('.', ''));
    priceImportTec.value = TextEditingValue(
      text: priceImport,
      selection: TextSelection.collapsed(offset: priceImport.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      controller: expandableController,
      child: ExpandablePanel(
        theme: const ExpandableThemeData(hasIcon: false),
        header: Container(
          padding: const EdgeInsets.symmetric(vertical: sp16, horizontal: sp16),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.vertical(
              top: const Radius.circular(sp8),
              bottom: Radius.circular(
                expandableController.expanded ? sp0 : sp8,
              ),
            ),
          ),
          child: Row(
            children: [
              BaseSwitch(
                value: widget.variant.isUse,
                onToggle: (value) => widget.toggeCheckbox.call(value),
              ),
              const SizedBox(width: sp16),
              Expanded(
                child: Text(
                  widget.variant.title,
                  style: p1,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: sp16),
              AnimatedRotation(
                turns: !expandableController.expanded ? 0 : 0.5,
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
          width: double.infinity,
          padding: const EdgeInsets.all(sp16).copyWith(top: sp0),
          decoration: const BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(sp8),
            ),
          ),
          child: Column(
            children: [
              const Divider(),
              const SizedBox(height: sp16),
              //Image Variant
              Row(
                children: [
                  InkWell(
                    onTap: () async {
                      final imagePicker = ImagePicker();
                      final res = await imagePicker.pickImage(
                        source: ImageSource.gallery,
                        imageQuality: 10,
                      );
                      if (res != null) {
                        final file = File(res.path);
                        widget.imagePicker.call(file);
                      }
                    },
                    child: SizedBox(
                      width: 81,
                      height: 81,
                      child: widget.variant.image == null
                          ? DottedBorder(
                              color: mainColor,
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(8),
                              dashPattern: const [3, 6],
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.add,
                                      color: mainColor,
                                    ),
                                    Text(
                                      'Thêm ảnh',
                                      style: p6.copyWith(
                                        color: mainColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(sp8),
                                  child: Image.file(
                                    widget.variant.image!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () => widget.imagePicker.call(null),
                                    child: const CircleAvatar(
                                      radius: sp12,
                                      backgroundColor: mainColor,
                                      child: Center(
                                        child: Icon(
                                          Icons.close,
                                          size: sp12,
                                          color: whiteColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(
                    width: sp24,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Ảnh sản phẩm',
                          style: p3.copyWith(color: greyColor),
                        ),
                        const SizedBox(height: sp8),
                        Visibility(
                          visible: true,
                          child: Text(
                            '≤5mb ( JPEG, PNG, JPG,...)',
                            style: p7.copyWith(color: borderColor_3),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: sp16),
              // Info Variant
              AppInput(
                controller: TextEditingController(
                  text: widget.variant.title,
                ),
                label: 'Tên mẫu mã',
                hintText: 'hintText',
                validate: (value) {},
                readOnly: true,
                backgroundColor: borderColor_1,
                borderColor: borderColor_1,
              ),
              const SizedBox(height: sp16),
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
                    ),
                  ),
                  const SizedBox(width: sp8),
                  GestureDetector(
                    onTap: () => context.router.push(
                      ProductBarCodeScanRoute(
                        onScanEvent: (String? barcode) {
                          setState(() {
                            barcodeTec.text = barcode ?? barcodeTec.text;
                          });
                          widget.barcodeChange.call(barcode);
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
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: InputCurrency(
                      label: 'Giá nhập',
                      hintText: 'Nhập giá nhập',
                      validate: (value) {},
                      controller: priceImportTec,
                    ),
                  ),
                  const SizedBox(width: sp16),
                  Expanded(
                    flex: 1,
                    child: InputCurrency(
                      label: 'Giá bán lẻ',
                      hintText: 'Nhập giá bán lẻ',
                      validate: (value) {},
                      controller: priceSellTec,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: sp16),
              AppInput(
                initialValue: widget.variant.quantity,
                label: 'Số lượng',
                hintText: 'Nhập số lượng',
                textInputType: TextInputType.number,
                validate: (value) {},
                onChanged: (value) => widget.amountChange.call(value),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
