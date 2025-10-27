import 'dart:io';

import 'package:base_mykiot/base_lhe.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:one_click/presentation/base/build_image.dart';
import 'package:one_click/presentation/base/switch.dart';

class VariantDefaultView extends StatefulWidget {
  const VariantDefaultView({
    super.key,
    required this.title,
    required this.barcode,
    required this.priceImport,
    required this.priceSell,
    required this.amountChange,
    required this.image,
    required this.imageChange,
    this.toggleStatus,
    required this.status,
    this.imageProducts,
  });

  final String title;
  final String barcode;
  final String priceImport;
  final String priceSell;
  final File? image;
  final List<XFile>? imageProducts;

  final bool status;
  final Function(String value) amountChange;
  final Function(File? image) imageChange;
  final Function()? toggleStatus;

  @override
  State<VariantDefaultView> createState() => _VariantDefaultViewState();
}

class _VariantDefaultViewState extends State<VariantDefaultView> {
  late ExpandableController expandableController;

  @override
  void initState() {
    super.initState();

    expandableController = ExpandableController(initialExpanded: true)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void didUpdateWidget(covariant VariantDefaultView oldWidget) {
    super.didUpdateWidget(oldWidget);

    final hasNewProductImage = widget.imageProducts != null &&
        widget.imageProducts!.isNotEmpty &&
        (oldWidget.imageProducts == null ||
            oldWidget.imageProducts!.isEmpty ||
            oldWidget.imageProducts!.first.path !=
                widget.imageProducts!.first.path);

    if (hasNewProductImage) {
      widget.imageChange(File(widget.imageProducts!.first.path));
    }
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
              // BaseSwitch(
              //   value: widget.status,
              //   onToggle: (value) => widget.toggleStatus?.call(),
              // ),
              // const SizedBox(width: sp16),
              const Text(
                'Mẫu mã mặc định',
                style: p1,
              ),
              const Spacer(),
              AnimatedRotation(
                turns: !expandableController.expanded ? 0 : 0.5,
                duration: const Duration(milliseconds: 300),
                child: SvgPicture.asset(
                  '${AssetsPath.icon}/ic_arrow_down.svg',
                ),
              ),
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
                        widget.imageChange.call(file);
                      }
                    },
                    child: SizedBox(
                      width: 81,
                      height: 81,
                      child: (widget.image != null)
                          ? Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(sp8),
                                  child: buildImage(
                                    widget.image?.path ?? '',
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () => widget.imageChange.call(null),
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
                                ),
                              ],
                            )
                          // : widget.imageProducts != null && widget.imageProducts!.isNotEmpty
                          //     ? ClipRRect(
                          //         borderRadius: BorderRadius.circular(sp8),
                          //         child: buildImage(
                          //           widget.imageProducts?[0].path ?? '',
                          //         ),
                          //       )
                          : DottedBorder(
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
                  ),
                ],
              ),
              const SizedBox(height: sp16),
              // Info Variant
              AppInput(
                initialValue: widget.title,
                label: 'Tên mẫu mã',
                hintText: 'Nhập tên sản phẩm',
                validate: (value) {},
                readOnly: true,
                backgroundColor: borderColor_1,
              ),
              const SizedBox(height: sp16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 1,
                    child: AppInput(
                      initialValue: widget.barcode,
                      label: 'Mã vạch',
                      hintText: 'Nhập mã vạch',
                      validate: (value) {},
                      backgroundColor: borderColor_1,
                      readOnly: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: sp16),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: AppInput(
                      initialValue: widget.priceImport,
                      label: 'Giá nhập',
                      hintText: 'Nhập giá nhập',
                      validate: (value) {},
                      backgroundColor: borderColor_1,
                      readOnly: true,
                      maxLines: 1,
                      suffixIcon: const SizedBox(
                        width: 50,
                        child: Center(child: Text('VNĐ')),
                      ),
                    ),
                  ),
                  const SizedBox(width: sp16),
                  Expanded(
                    flex: 1,
                    child: AppInput(
                      initialValue: widget.priceSell,
                      label: 'Giá bán lẻ',
                      hintText: 'Nhập giá bán lẻ',
                      validate: (value) {},
                      backgroundColor: borderColor_1,
                      readOnly: true,
                      maxLines: 1,
                      suffixIcon: const SizedBox(
                        width: 20,
                        child: Center(child: Text('VNĐ')),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: sp16),
              AppInput(
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
