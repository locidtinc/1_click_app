import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:one_click/data/models/payload/product/payload_variant.dart';
import 'package:one_click/data/models/payload/product/product_properties.dart';
import 'package:one_click/presentation/base/switch.dart';
import 'package:one_click/presentation/view/product_create/cubit/product_create_cubit.dart';
import 'package:one_click/presentation/view/product_create/cubit/product_create_state.dart';

import '../../../routers/router.gr.dart';

class VariantFieldView extends StatefulWidget {
  const VariantFieldView({
    super.key,
    required this.variant,
  });

  final PayloadVariantModel variant;
  @override
  State<VariantFieldView> createState() => _VariantFieldViewState();
}

class _VariantFieldViewState extends State<VariantFieldView> {
  @override
  void initState() {
    super.initState();
    // Khởi tạo 1 lần
    widget.variant.nameVariantController = TextEditingController(
      text:
          '${context.read<ProductCreateCubit>().state.productName} ${widget.variant.title}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      controller: widget.variant.controller,
      child: ExpandablePanel(
        theme: const ExpandableThemeData(hasIcon: false),
        header: Container(
          padding: const EdgeInsets.symmetric(vertical: sp16, horizontal: sp16),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.vertical(
              top: const Radius.circular(sp8),
              bottom: Radius.circular(
                widget.variant.controller!.expanded ? sp0 : sp8,
              ),
            ),
          ),
          child: Row(
            children: [
              BaseSwitch(
                value: widget.variant.isUse,
                onToggle: (value) => setState(() {
                  widget.variant.isUse = !widget.variant.isUse;
                }),
              ),
              const SizedBox(width: sp16),
              Text(
                widget.variant.title ?? '',
                style: p1,
              ),
              const Spacer(),
              AnimatedRotation(
                turns: !widget.variant.controller!.expanded ? 0 : 0.5,
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
              // Image Variant
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
                        setState(() {
                          widget.variant.image = file;
                        });
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
                                    const Icon(Icons.add, color: mainColor),
                                    Text('Thêm ảnh',
                                        style: p6.copyWith(color: mainColor)),
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
                                    width: 81,
                                    height: 81,
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () => setState(() {
                                      widget.variant.image = null;
                                    }),
                                    child: const CircleAvatar(
                                      radius: sp12,
                                      backgroundColor: mainColor,
                                      child: Center(
                                        child: Icon(Icons.close,
                                            size: sp12, color: whiteColor),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: () async {
                      final imagePicker = ImagePicker();
                      final res = await imagePicker.pickImage(
                        source: ImageSource.camera,
                        imageQuality: 10,
                      );
                      if (res != null) {
                        final file = File(res.path);
                        setState(() {
                          widget.variant.image = file;
                        });
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
                                    const Icon(Icons.camera_alt,
                                        color: mainColor),
                                    Text('Chụp ảnh',
                                        style: p6.copyWith(color: mainColor)),
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ),
                  ),
                ],
              ),
              // Row(
              //   children: [
              //     Expanded(
              //       flex: 1,
              //       child: GestureDetector(
              //         onTap: () => context.read<ProductCreateCubit>().productVariantImageGallery(),
              //         child: DottedBorder(
              //           color: mainColor,
              //           borderType: BorderType.RRect,
              //           padding: const EdgeInsets.symmetric(vertical: sp16),
              //           radius: const Radius.circular(8),
              //           dashPattern: const [5, 6],
              //           child: Center(
              //             child: BlocBuilder<ProductCreateCubit, ProductCreateState>(
              //               builder: (context, state) {
              //                 return Text(
              //                   'Tải ảnh (${state.listVariantImage.length}/1)',
              //                   style: p5.copyWith(color: mainColor),
              //                 );
              //               },
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //     const SizedBox(width: sp16),
              //     GestureDetector(
              //       onTap: () => context.read<ProductCreateCubit>().productVariantImagePicker(),
              //       child: Container(
              //         padding: const EdgeInsets.symmetric(
              //           vertical: sp16,
              //           horizontal: sp16,
              //         ),
              //         decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(sp8),
              //           border: Border.all(color: mainColor),
              //         ),
              //         child: const Center(
              //           child: Icon(
              //             Icons.camera_alt,
              //             size: 14,
              //             color: mainColor,
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              // BlocBuilder<ProductCreateCubit, ProductCreateState>(
              //   builder: (context, state) {
              //     // if (state.listVariantImage.isNotEmpty) {
              //     //   final file = File(state.listVariantImage.first.path);
              //     //   setState(() {
              //     //     widget.variant.image = file;
              //     //   });
              //     // }
              //     return Column(
              //       children: [
              //         SizedBox(height: state.listVariantImage.isNotEmpty ? sp16 : 0),
              //         Row(
              //           children: [
              //             Expanded(
              //               child: SizedBox(
              //                 height: state.listVariantImage.isNotEmpty ? 61 : 0,
              //                 child: ListView.separated(
              //                   physics: const ClampingScrollPhysics(),
              //                   shrinkWrap: true,
              //                   scrollDirection: Axis.horizontal,
              //                   itemBuilder: (context, index) {
              //                     return Stack(
              //                       children: [
              //                         Container(
              //                           height: 61,
              //                           width: 61,
              //                           decoration: BoxDecoration(
              //                             border: Border.all(color: borderColor_2),
              //                             borderRadius: BorderRadius.circular(sp8),
              //                           ),
              //                           child: ClipRRect(
              //                             borderRadius: BorderRadius.circular(sp8),
              //                             child: Image.file(
              //                               File(state.listVariantImage[index].path),
              //                               fit: BoxFit.cover,
              //                             ),
              //                           ),
              //                         ),
              //                         Positioned(
              //                           right: 0,
              //                           child: GestureDetector(
              //                             onTap: () => context.read<ProductCreateCubit>().productVariantImageDelete(state.listVariantImage[index]),
              //                             child: const CircleAvatar(
              //                               backgroundColor: mainColor,
              //                               radius: sp8,
              //                               child: Center(
              //                                 child: Icon(
              //                                   Icons.close,
              //                                   size: sp12,
              //                                 ),
              //                               ),
              //                             ),
              //                           ),
              //                         ),
              //                       ],
              //                     );
              //                   },
              //                   separatorBuilder: (context, index) => const SizedBox(width: sp16),
              //                   itemCount: state.listVariantImage.length,
              //                 ),
              //               ),
              //             ),
              //           ],
              //         ),
              //       ],
              //     );
              //   },
              // ),
              const SizedBox(height: sp16),
              // Info Variant
              BlocBuilder<ProductCreateCubit, ProductCreateState>(
                builder: (context, state) {
                  return AppInput(
                    // controller: TextEditingController(
                    //   text: '${state.productName} ${widget.variant.title}',
                    // ),
                    controller: widget.variant.nameVariantController,
                    label: 'Tên mẫu mã',
                    hintText: 'Nhập mẫu mã',
                    validate: (value) {},
                  );
                },
              ),
              const SizedBox(height: sp16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 1,
                    child: AppInput(
                      label: 'Mã vạch',
                      hintText: 'Nhập mã vạch',
                      validate: (value) {},
                      controller: widget.variant.barcode,
                      fn: widget.variant.focusNode,
                      // fn: _focusNode,
                    ),
                  ),
                  const SizedBox(width: sp8),
                  GestureDetector(
                    onTap: () => context.router.push(
                      ProductBarCodeScanRoute(
                        onScanEvent: (String? barcode) {
                          setState(() {
                            widget.variant.barcode!.text = barcode ?? '';
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              widget.variant.focusNode?.requestFocus();
                            });

                            // _focusNode.requestFocus();
                          });
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
                  ),
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
                      controller: widget.variant.priceImport!,
                    ),
                  ),
                  const SizedBox(width: sp16),
                  Expanded(
                    flex: 1,
                    child: InputCurrency(
                      label: 'Giá bán lẻ',
                      hintText: 'Nhập giá bán lẻ',
                      validate: (value) {},
                      controller: widget.variant.priceSell!,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: sp16),
              AppInput(
                controller: widget.variant.quantity,
                label: 'Số lượng',
                hintText: 'Nhập số lượng',
                textInputType: TextInputType.number,
                validate: (value) {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
