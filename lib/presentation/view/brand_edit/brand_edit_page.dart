import 'dart:io';

import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_click/domain/entity/brand_detail_entity.dart';
import 'package:one_click/presentation/base/app_bar.dart';
import 'package:one_click/presentation/base/card_base.dart';
import 'package:one_click/presentation/di/di.dart';
import 'package:one_click/presentation/shared_view/card/product_added_card.dart';
import 'package:one_click/presentation/view/brand_edit/cubit/brand_edit_cubit.dart';
import 'package:one_click/presentation/view/brand_edit/cubit/brand_edit_state.dart';
import 'package:one_click/shared/constants/app_constant.dart';
import 'package:one_click/shared/constants/local_storage/app_shared_preference.dart';
import 'package:one_click/shared/constants/pref_keys.dart';

@RoutePage()
class BrandEditPage extends StatelessWidget {
  const BrandEditPage({super.key, required this.brand});

  final BrandDetailEntity brand;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(title: 'Chỉnh sửa chi tiết thương hiệu'),
      backgroundColor: bg_4,
      body: BlocProvider<BrandEditCubit>(
        create: (_) => getIt.get<BrandEditCubit>()..initData(brand),
        child: BlocBuilder<BrandEditCubit, BrandEditState>(
          builder: (context, state) {
            final width = MediaQuery.of(context).size.width;
            final myBloc = context.read<BrandEditCubit>();
            final userId = AppSharedPreference.instance.getValue(PrefKeys.user);
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: sp24),
                        CardBase(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ảnh thương hiệu',
                                style: p1.copyWith(color: blackColor),
                              ),
                              const SizedBox(height: sp16),
                              Row(
                                children: [
                                  _selectImage(width),
                                  const SizedBox(width: sp16),
                                  _nameImage(),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: sp16),
                        CardBase(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Thông tin thương hiệu',
                                style: p1.copyWith(color: blackColor),
                              ),
                              const SizedBox(height: sp24),
                              Form(
                                key: myBloc.keyForm,
                                child: AppInput(
                                  label: 'Tên thương hiệu',
                                  required: true,
                                  initialValue: state.brand?.title,
                                  hintText: 'Nhập tên thương hiệu',
                                  validate: myBloc.validateBrand,
                                  onChanged: myBloc.titleChange,
                                ),
                              ),
                              const SizedBox(height: sp16),
                              Container(
                                padding: const EdgeInsets.all(sp16),
                                decoration: BoxDecoration(
                                  color: borderColor_1,
                                  borderRadius: BorderRadius.circular(sp8),
                                ),
                                child: const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Phân loại', style: p6),
                                    Text('Nội bộ', style: p5),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(sp16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Danh sách sản phẩm', style: p1),
                              const SizedBox(height: sp16),
                              SizedBox(
                                width: width,
                                child: MainButton(
                                  title: 'Thêm sản phẩm',
                                  event: () => myBloc.onTapAddProduct(context),
                                  largeButton: true,
                                  icon: null,
                                ),
                              ),
                              const SizedBox(height: sp16),
                              ListView.separated(
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final product = state.brand?.products[index];
                                  return ProductAddedCard(
                                    deleteProduct: myBloc.deleteProductSelected,
                                    product: product!,
                                    isDelete: state.brand?.account == userId,
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: sp16),
                                itemCount: state.brand!.products.length,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: sp24),
                      ],
                    ),
                  ),
                ),
                TwoButtonBox(
                  extraTitle: 'Huỷ',
                  mainTitle: 'Lưu',
                  extraOnTap: () => myBloc.onTapCancel(context),
                  mainOnTap: () => myBloc.onTapSave(context),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _selectImage(double width) {
    return BlocBuilder<BrandEditCubit, BrandEditState>(
      builder: (context, state) {
        return InkWell(
          onTap: context.read<BrandEditCubit>().imagePickerChange,
          child: SizedBox(
            width: 81,
            height: 81,
            child: state.brand?.image == null
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
                : Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: borderColor_2),
                      borderRadius: BorderRadius.circular(sp8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(sp8),
                      child: state.brand!.image!.startsWith(AppConstant.http)
                          ? CachedNetworkImage(
                              width: width * 0.25,
                              height: width * 0.25,
                              imageUrl: state.brand?.image ?? '',
                              progressIndicatorBuilder:
                                  (context, url, progress) {
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: progress.progress,
                                  ),
                                );
                              },
                              fit: BoxFit.contain,
                            )
                          : Image.file(
                              width: width * 0.25,
                              height: width * 0.25,
                              File(state.brand?.image ?? ''),
                              fit: BoxFit.contain,
                            ),
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _nameImage() {
    return Expanded(
      child: BlocBuilder<BrandEditCubit, BrandEditState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state.brand?.image == null
                    ? 'Ảnh sản phẩm'
                    : state.brand!.image!.split('/').last,
                style: p3.copyWith(
                  color: state.brand?.image == null ? greyColor : blackColor,
                ),
              ),
              Visibility(
                visible: state.brand?.image == null,
                child: Text(
                  '≤5mb ( JPEG, PNG, JPG,...)',
                  style: p7.copyWith(color: borderColor_3),
                ),
              ),
              Visibility(
                visible: state.brand?.image != null,
                child: TextButton(
                  onPressed: context.read<BrandEditCubit>().imagePickerChange,
                  style: TextButton.styleFrom(
                    visualDensity: const VisualDensity(vertical: -4),
                    padding: EdgeInsets.zero,
                  ),
                  child: const Text(
                    'Thay đổi ảnh',
                    style: p8,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
