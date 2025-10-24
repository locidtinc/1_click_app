import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:one_click/domain/entity/variant_entity.dart';
import 'package:one_click/presentation/base/app_bar.dart';
import 'package:one_click/presentation/base/card_base.dart';
import 'package:one_click/presentation/di/di.dart';
import 'package:one_click/presentation/routers/router.gr.dart';
import 'package:one_click/presentation/shared_view/widget/cache_image.dart';
import 'package:one_click/presentation/view/product_detail/child/edit_variant/cubit/edit_variant_cubit.dart';
import 'package:one_click/presentation/view/product_detail/child/edit_variant/cubit/edit_variant_state.dart';
import 'package:one_click/presentation/view/product_detail/widgets/root_product_widget.dart';

@RoutePage()
class EditVariantPage extends StatefulWidget {
  const EditVariantPage({
    super.key,
    required this.variant,
    this.onConfirm,
  });

  final VariantEntity variant;
  final Function()? onConfirm;

  @override
  State<EditVariantPage> createState() => _EditVariantPageState();
}

class _EditVariantPageState extends State<EditVariantPage> {
  final TextEditingController priceSellController = TextEditingController();
  final TextEditingController priceImportController = TextEditingController();
  late TextEditingController barcodeTec;

  @override
  void initState() {
    priceSellController.text = NumberFormat.decimalPattern('vi')
        .format(int.parse(widget.variant.priceSell.toInt().toString()));
    priceImportController.text = NumberFormat.decimalPattern('vi')
        .format(int.parse(widget.variant.priceImport.toInt().toString()));
    barcodeTec = TextEditingController(text: widget.variant.barCode);
    super.initState();
  }

  @override
  void dispose() {
    priceSellController.dispose();
    priceImportController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(
        title: 'Chỉnh sửa mẫu mã',
      ),
      backgroundColor: borderColor_1,
      body: BlocProvider<EditVariantCubit>(
        create: (context) =>
            getIt.get<EditVariantCubit>()..onChangeSell(widget.variant.status),
        child: BlocBuilder<EditVariantCubit, EditVariantState>(
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CardBase(
                          margin: const EdgeInsets.symmetric(horizontal: sp16) +
                              const EdgeInsets.only(top: sp24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                                decoration: BoxDecoration(
                                  border: Border.all(color: borderColor_1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: state.image == null
                                      ? BaseCacheImage(
                                          url: widget.variant.image,
                                        )
                                      : Image.file(File(state.image!.path)),
                                ),
                              ),
                              const SizedBox(height: 16),
                              InkWell(
                                onTap: context
                                    .read<EditVariantCubit>()
                                    .onSelectImage,
                                child: DottedBorder(
                                  color: mainColor,
                                  borderType: BorderType.RRect,
                                  radius: const Radius.circular(8),
                                  dashPattern: const [5, 5],
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Text(
                                        'Thay đổi ảnh',
                                        style: p5.copyWith(
                                          color: mainColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(widget.variant.title, style: p1),
                              const SizedBox(height: 8),
                              Text(
                                widget.variant.code,
                                style: p3.copyWith(color: borderColor_4),
                              ),
                              const SizedBox(height: 16),
                              const Divider(
                                height: 1,
                                thickness: 1,
                                color: borderColor_2,
                              ),
                              const SizedBox(height: 16),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  BlocBuilder<EditVariantCubit,
                                      EditVariantState>(
                                    builder: (context, state) {
                                      if (barcodeTec.text != state.barCode) {
                                        barcodeTec.text = state.barCode ??
                                            widget.variant.barCode;
                                      }
                                      return Expanded(
                                        flex: 1,
                                        child: AppInput(
                                          controller: barcodeTec,
                                          label: 'Mã vạch',
                                          hintText: 'Nhập mã vạch',
                                          validate: (value) {},
                                          onChanged: context
                                              .read<EditVariantCubit>()
                                              .barCodeChange,
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(width: sp8),
                                  InkWell(
                                    onTap: () => context.router.push(
                                      ProductBarCodeScanRoute(
                                        onScanEvent: (String? barcode) =>
                                            context
                                                .read<EditVariantCubit>()
                                                .barCodeChange(barcode ?? ''),
                                      ),
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.all(sp16),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(sp8),
                                        border:
                                            Border.all(color: borderColor_2),
                                      ),
                                      child: SvgPicture.asset(
                                        '${AssetsPath.icon}/ic_scan_btn.svg',
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 16),
                              AppInput(
                                initialValue: widget.variant.amount.toString(),
                                label: 'Số lượng',
                                hintText: '',
                                validate: (value) {},
                                onChanged: (value) => context
                                    .read<EditVariantCubit>()
                                    .onChangeAmount(value),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: BlocBuilder<EditVariantCubit,
                                        EditVariantState>(
                                      builder: (context, state) {
                                        return InputCurrency(
                                          label: 'Giá nhập',
                                          hintText: 'Nhập giá nhập',
                                          validate: (String? value) {},
                                          controller: priceImportController,
                                          suffixIcon: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 16.0,
                                              horizontal: 12,
                                            ),
                                            child: Text(
                                              'VNĐ',
                                              style: p6.copyWith(
                                                color: borderColor_4,
                                              ),
                                            ),
                                          ),
                                          onChanged: context
                                              .read<EditVariantCubit>()
                                              .priceImportChange,
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: BlocBuilder<EditVariantCubit,
                                        EditVariantState>(
                                      builder: (context, state) {
                                        return InputCurrency(
                                          label: 'Giá bán lẻ',
                                          hintText: 'Nhập giá bán lẻ',
                                          validate: (String? value) {},
                                          controller: priceSellController,
                                          suffixIcon: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 16.0,
                                              horizontal: 12,
                                            ),
                                            child: Text(
                                              'VNĐ',
                                              style: p6.copyWith(
                                                color: borderColor_4,
                                              ),
                                            ),
                                          ),
                                          onChanged: context
                                              .read<EditVariantCubit>()
                                              .priceSellChange,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        CardBase(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Trạng thái', style: p4),
                              Row(
                                children: [
                                  Text(
                                    state.isSell ? 'Đang bán' : 'Đã ẩn',
                                    style: p3.copyWith(
                                      color: state.isSell
                                          ? mainColor
                                          : borderColor_4,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  SizedBox(
                                    width: 20,
                                    child: Transform.scale(
                                      scale: 0.35,
                                      child: BlocBuilder<EditVariantCubit,
                                          EditVariantState>(
                                        builder: (context, state) {
                                          return CupertinoSwitch(
                                            value: state.isSell,
                                            activeColor: mainColor,
                                            trackColor: borderColor_3,
                                            onChanged: context
                                                .read<EditVariantCubit>()
                                                .onChangeSell,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        RootProductWidget(data: widget.variant.productData),
                      ],
                    ),
                  ),
                ),
                TwoButtonBox(
                  extraTitle: 'Huỷ bỏ',
                  mainTitle: 'Lưu lại',
                  extraOnTap: () =>
                      context.read<EditVariantCubit>().onTapCancel(context),
                  mainOnTap: () async {
                    await context
                        .read<EditVariantCubit>()
                        .onTapSave(context, widget.variant);
                    widget.onConfirm?.call();
                  },
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
