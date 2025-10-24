import 'dart:io';

import 'package:base_mykiot/base_lhe.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_click/presentation/base/build_image.dart';
import 'package:one_click/presentation/view/product_create/cubit/product_create_cubit.dart';
import 'package:one_click/presentation/view/product_create/cubit/product_create_state.dart';

class ProductImagePickerView extends StatelessWidget {
  const ProductImagePickerView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      context,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Ảnh sản phẩm',
            style: p1,
          ),
          const SizedBox(
            height: sp24,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () =>
                      context.read<ProductCreateCubit>().productImageGallery(),
                  child: DottedBorder(
                    color: mainColor,
                    borderType: BorderType.RRect,
                    padding: const EdgeInsets.symmetric(vertical: sp16),
                    radius: const Radius.circular(8),
                    dashPattern: const [5, 6],
                    child: Center(
                      child:
                          BlocBuilder<ProductCreateCubit, ProductCreateState>(
                        builder: (context, state) {
                          return Text(
                            'Tải ảnh lên(${state.listImage.length}/4)',
                            style: p5.copyWith(color: mainColor),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: sp16),
              GestureDetector(
                onTap: () =>
                    context.read<ProductCreateCubit>().productImagePicker(),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: sp16,
                    horizontal: sp16,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(sp8),
                    border: Border.all(color: mainColor),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.camera_alt,
                      size: 14,
                      color: mainColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          BlocBuilder<ProductCreateCubit, ProductCreateState>(
            builder: (context, state) {
              return Column(
                children: [
                  SizedBox(height: state.listImage.isNotEmpty ? sp16 : 0),
                  SizedBox(
                    height: state.listImage.isNotEmpty ? 61 : 0,
                    child: ListView.separated(
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Container(
                              height: 61,
                              width: 61,
                              decoration: BoxDecoration(
                                border: Border.all(color: borderColor_2),
                                borderRadius: BorderRadius.circular(sp8),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(sp8),
                                child: buildImage(state.listImage[index].path),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              child: GestureDetector(
                                onTap: () => context
                                    .read<ProductCreateCubit>()
                                    .productImageDelete(state.listImage[index]),
                                child: const CircleAvatar(
                                  backgroundColor: mainColor,
                                  radius: sp8,
                                  child: Center(
                                    child: Icon(
                                      Icons.close,
                                      size: sp12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: sp16),
                      itemCount: state.listImage.length,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
