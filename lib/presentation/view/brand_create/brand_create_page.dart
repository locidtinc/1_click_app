import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:one_click/presentation/base/app_bar.dart';
import 'package:one_click/presentation/di/di.dart';
import 'package:one_click/presentation/routers/router.gr.dart';
import 'package:one_click/presentation/shared_view/card/product_added_card.dart';
import 'package:one_click/presentation/view/brand_create/cubit/brand_create_cubit.dart';
import 'package:one_click/presentation/view/brand_create/cubit/brand_create_state.dart';

import '../../../domain/entity/product_preview.dart';

@RoutePage()
class BrandCreatePage extends StatefulWidget {
  const BrandCreatePage({super.key});

  @override
  State<BrandCreatePage> createState() => _BrandCreatePageState();
}

class _BrandCreatePageState extends State<BrandCreatePage> {
  final nameTec = TextEditingController();
  final myBloc = getIt.get<BrandCreateCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BrandCreateCubit>(
      create: (context) => myBloc,
      child: Scaffold(
        backgroundColor: bg_4,
        appBar: const BaseAppBar(title: 'Tạo thương hiệu'),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: sp24, horizontal: sp16),
          height: heightDevice(context),
          width: widthDevice(context),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                // image brand
                BaseContainer(
                  context,
                  Padding(
                    padding: const EdgeInsets.all(sp8),
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
                            _selectImage(),
                            const SizedBox(width: sp16),
                            _nameImage(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: sp16),
                // info brand
                BaseContainer(
                  context,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Thông tin thương hiệu',
                        style: p1.copyWith(color: blackColor),
                      ),
                      const SizedBox(height: sp24),
                      Form(
                        key: myBloc.keyForm,
                        child: BlocBuilder<BrandCreateCubit, BrandCreateState>(
                          builder: (context, state) {
                            if (nameTec.text != state.title) {
                              nameTec.text = state.title;
                            }
                            return AppInput(
                              controller: nameTec,
                              label: 'Tên thương hiệu',
                              required: true,
                              hintText: 'Nhập tên thương hiệu',
                              validate: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Vui lòng điền tên thương hiệu';
                                }
                              },
                              onChanged: (value) => myBloc.titleChange(value),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: sp16),
                      Container(
                        padding: const EdgeInsets.all(sp16),
                        decoration: BoxDecoration(
                          color: borderColor_1,
                          borderRadius: BorderRadius.circular(sp8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text('Phân loại', style: p6),
                            Text('Nội bộ', style: p5)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: sp24),
                SizedBox(
                  width: double.infinity,
                  child: MainButton(
                    title: 'Thêm sản phẩm',
                    event: () => context.router.push(
                      AddProductRoute(
                        onConfirm: myBloc.productsSelectedChange,
                        listProductInit: myBloc.state.productsSelected,
                      ),
                    ),
                    largeButton: true,
                    icon: null,
                  ),
                ),
                const SizedBox(height: sp24),
                BlocBuilder<BrandCreateCubit, BrandCreateState>(
                  builder: (context, state) {
                    return ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final product = state.productsSelected[index];
                        return ProductAddedCard(
                          deleteProduct: myBloc.deleteProductSelected,
                          product: product,
                          warningItem: product.brandName == null
                              ? null
                              : Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(sp12),
                                  decoration: BoxDecoration(
                                    color: yellow_2,
                                    borderRadius: BorderRadius.circular(sp8),
                                  ),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        '${AssetsPath.icon}/ic_warning.svg',
                                        width: sp12,
                                      ),
                                      const SizedBox(width: sp8),
                                      Text(
                                        'Thương hiệu hiện tại',
                                        style: p5.copyWith(color: greyColor),
                                      ),
                                      const Spacer(),
                                      Expanded(
                                        child: Text(
                                          '${product.brandName}',
                                          style: p5,
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: sp16),
                      itemCount: state.productsSelected.length,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(sp16),
          color: whiteColor,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Extrabutton(
                  title: 'Lưu và tạo thêm',
                  event: () => myBloc.createBrand(context, true),
                  largeButton: true,
                  borderColor: borderColor_2,
                  icon: null,
                ),
              ),
              const SizedBox(width: sp16),
              Expanded(
                child: MainButton(
                  title: 'Lưu',
                  event: () => myBloc.createBrand(context, false),
                  largeButton: true,
                  icon: null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _selectImage() {
    return InkWell(
      onTap: myBloc.imagePickerChange,
      child: BlocBuilder<BrandCreateCubit, BrandCreateState>(
        builder: (context, state) {
          return SizedBox(
            width: 81,
            height: 81,
            child: state.imagePicker == null
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
                      child: Image.file(
                        state.imagePicker!,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }

  Widget _nameImage() {
    return Expanded(
      child: BlocBuilder<BrandCreateCubit, BrandCreateState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state.imagePicker?.path.split('/').last ?? 'Ảnh sản phẩm',
                style: p3.copyWith(
                  color: state.imagePicker == null ? greyColor : blackColor,
                ),
              ),
              Visibility(
                visible: state.imagePicker == null,
                child: Text(
                  '≤5mb ( JPEG, PNG, JPG,...)',
                  style: p7.copyWith(color: borderColor_3),
                ),
              ),
              Visibility(
                visible: state.imagePicker != null,
                child: TextButton(
                  onPressed: myBloc.imagePickerChange,
                  style: TextButton.styleFrom(
                    visualDensity: const VisualDensity(vertical: -4),
                    padding: EdgeInsets.zero,
                  ),
                  child: const Text(
                    'Thay đổi ảnh',
                    style: p8,
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
