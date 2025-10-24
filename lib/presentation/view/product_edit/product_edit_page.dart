import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_click/domain/entity/product_detail_entity.dart';
import 'package:one_click/presentation/base/app_bar.dart';
import 'package:one_click/presentation/di/di.dart';
import 'package:one_click/presentation/shared_view/widget/empty.dart';
import 'package:one_click/presentation/view/product_edit/widgets/product_image_container.dart';
import 'package:one_click/presentation/view/product_edit/widgets/product_info_container.dart';
import 'package:one_click/presentation/view/product_edit/widgets/product_info_extra_container.dart';
import 'package:one_click/presentation/view/product_edit/widgets/propertie_field_container.dart';
import 'package:one_click/presentation/view/product_edit/widgets/propertie_field_container_new.dart';
import 'package:one_click/presentation/view/product_edit/widgets/variant_edit_container.dart';
import 'package:one_click/presentation/view/product_edit/widgets/variant_view_container.dart';

import 'cubit/product_edit_cubit.dart';
import 'cubit/product_edit_state.dart';
import 'widgets/product_status_container.dart';

@RoutePage()
class ProductEditPage extends StatefulWidget {
  const ProductEditPage({
    super.key,
    required this.productDetailEntity,
    required this.onConfirm,
  });

  final ProductDetailEntity productDetailEntity;
  final Function()? onConfirm;

  @override
  State<ProductEditPage> createState() => _ProductEditPageState();
}

class _ProductEditPageState extends State<ProductEditPage> {
  final myBloc = getIt.get<ProductEditCubit>();

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
  Widget build(BuildContext context) {
    return BlocProvider<ProductEditCubit>(
      create: (context) => myBloc
        ..updateProductDetail(widget.productDetailEntity)
        ..initData()
        ..getListCategory()
        ..getListGroup(),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: bg_4,
          appBar: const BaseAppBar(title: 'Chỉnh sửa sản phẩm'),
          body: Container(
            padding:
                const EdgeInsets.symmetric(vertical: sp24, horizontal: sp16),
            child: BlocBuilder<ProductEditCubit, ProductEditState>(
              builder: (context, state) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProductImageContainer(
                        listMedia: state.product?.mediaData ?? [],
                        listImagePicker: state.imagesPicker,
                        deletaImagePicker: (File file) =>
                            myBloc.deletaImagePicker(file),
                        deleteMediaData: (MediaDataEntity media) =>
                            myBloc.deleteMediaData(media),
                        productImagePicker: () => myBloc.productImagePicker(),
                      ),
                      const SizedBox(height: sp16),
                      BlocBuilder<ProductEditCubit, ProductEditState>(
                        builder: (context, state) {
                          return ProductInfoContainer(
                            expandableController: expandableController,
                            priceImport:
                                state.product?.priceImport.round().toString() ??
                                    '0',
                            priceSell:
                                state.product?.priceSell.round().toString() ??
                                    '0',
                            barcode: state.product?.barcode ?? '0',
                            productName: state.product?.title ?? '',
                            statusSynchronizedSell:
                                state.statusSynchronizedSell,
                            statusSynchronizedImport:
                                state.statusSynchronizedImport,
                            barcodeChange: (value) =>
                                myBloc.barcodeChange(value),
                            productNameChange: (String value) =>
                                myBloc.productFiledChange(productName: value),
                            priceImportChange: (String value) =>
                                myBloc.productFiledChange(priceImport: value),
                            priceSellChange: (String value) =>
                                myBloc.productFiledChange(priceSell: value),
                            onScanBarcode: (barcode) =>
                                myBloc.productFiledChange(barcode: barcode),
                            onStatusSynchronizedImportChange: (value) => myBloc
                              ..productFiledChange(
                                statusSynchronizedImport: value,
                              ),
                            onStatusSynchronizedSellChange: (value) => myBloc
                              ..productFiledChange(
                                statusSynchronizedSell: value,
                              ),
                          );
                        },
                      ),
                      const SizedBox(height: sp24),
                      Text(
                        'Thuộc tính',
                        style: p1.copyWith(color: blackColor),
                      ),
                      const SizedBox(height: sp16),
                      BlocBuilder<ProductEditCubit, ProductEditState>(
                        builder: (context, state) {
                          return ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final propertie = state.listProperties[index];
                              return state.product?.variant.length == 1
                                  ? PropertieFieldContainerNew(
                                      propertie: propertie,
                                      addPropertieValue: (value) => myBloc
                                          .addPropertieValue(propertie, value),
                                      namePropertieChange: (value) =>
                                          myBloc.namePropertieChange(
                                        propertie,
                                        value,
                                      ),
                                      deletePropertieValue: (value) =>
                                          myBloc.deletePropertieValue(
                                        propertie,
                                        value,
                                      ),
                                      deletePropertie: () =>
                                          myBloc.deletePropertie(propertie),
                                    )
                                  : PropertieFieldContainer(
                                      propertie: propertie,
                                      addPropertieValue: (value) => myBloc
                                          .addPropertieValue(propertie, value),
                                      deletePropertieValue: (value) =>
                                          myBloc.deletePropertieValue(
                                        propertie,
                                        value,
                                      ),
                                    );
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: sp16),
                            itemCount: state.listProperties.length,
                          );
                        },
                      ),
                      BlocBuilder<ProductEditCubit, ProductEditState>(
                        builder: (context, state) {
                          return Visibility(
                            visible: state.product?.variant.length == 1,
                            child: Column(
                              children: [
                                const SizedBox(height: sp16),
                                GestureDetector(
                                  onTap: myBloc.addPropertie,
                                  child: DottedBorder(
                                    color: blue_1,
                                    borderType: BorderType.RRect,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: sp12,
                                    ),
                                    radius: const Radius.circular(8),
                                    dashPattern: const [3, 6],
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(sp8),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Thêm thuộc tính ( ${state.listProperties.length}/3 )',
                                          style: p5.copyWith(color: blue_1),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: sp24),
                      Text(
                        'Mẫu mã mới',
                        style: p1.copyWith(color: blackColor),
                      ),
                      const SizedBox(height: sp16),
                      BlocBuilder<ProductEditCubit, ProductEditState>(
                        builder: (context, state) {
                          return state.listNewVariant.isEmpty
                              ? const EmptyContainer()
                              : ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    final variant = state.listNewVariant[index];
                                    return VariantEditContainer(
                                      variant: variant,
                                      amountChange: (String value) =>
                                          myBloc.variantFieldChange(
                                        variant,
                                        amount: value,
                                      ),
                                      barcodeChange: (String? value) =>
                                          myBloc.variantFieldChange(
                                        variant,
                                        barcode: value,
                                      ),
                                      priceImportChange: (String value) {},
                                      priceSellChange: (String value) {},
                                      toggeCheckbox: (bool value) =>
                                          myBloc.variantFieldChange(
                                        variant,
                                        isUse: value,
                                      ),
                                      imagePicker: (File? image) =>
                                          myBloc.variantFieldChange(
                                        variant,
                                        imageFile: image,
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(height: sp16),
                                  itemCount: state.listNewVariant.length,
                                );
                        },
                      ),
                      const SizedBox(height: sp24),
                      Text(
                        'Mẫu mã đã tồn tại (${state.product?.variant.length})',
                        style: p1.copyWith(color: blackColor),
                      ),
                      const SizedBox(height: sp16),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final variant = state.product?.variant[index];
                          return VariantViewContainer(variant: variant!);
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: sp16),
                        itemCount: state.product?.variant.length ?? 0,
                      ),
                      const SizedBox(height: sp24),
                      ProductInfoExtraContainer(
                        listBrandDropdonw: state.listBrandDropdonw,
                        listCategoryDropdonw: state.listCategoryDropdonw,
                        listGroupDropdonw: state.listGroupDropdonw,
                        brandSelected: state.product?.brandId,
                        categorySelected: state.product?.categoryId,
                        groupSelected: state.product?.groupId,
                        brandSelect: (value) =>
                            myBloc.productFiledChange(brandId: value),
                        categorySelect: (value) {
                          myBloc.productFiledChange(categoryId: value);
                          myBloc.getListGroup();
                        },
                        groupSelect: (value) =>
                            myBloc.productFiledChange(groupId: value),
                      ),
                      const SizedBox(height: sp16),
                      ProductStatusContainer(
                        statusProduct: state.product?.statusProduct ?? false,
                        statusOnline: state.product?.statusOnline ?? false,
                        statusProductChange: (value) =>
                            myBloc.productFiledChange(statusProduct: value),
                        statusOnlineChange: (value) =>
                            myBloc.productFiledChange(statusOnline: value),
                      ),
                      const SizedBox(height: sp16),
                      BaseContainer(
                        context,
                        AppInput(
                          label: 'Mô tả sản phẩm',
                          hintText: 'Nhập mô tả',
                          validate: (value) {},
                          textInputType: TextInputType.text,
                          maxLines: 3,
                          onChanged: (value) =>
                              myBloc.productFiledChange(description: value),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: whiteColor,
              boxShadow: [BoxShadow(color: greyColor.withOpacity(0.2))],
            ),
            padding: const EdgeInsets.all(sp16),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Extrabutton(
                    title: 'Huỷ bỏ',
                    event: () => context.router.pop(),
                    largeButton: true,
                    borderColor: borderColor_2,
                    icon: null,
                  ),
                ),
                const SizedBox(width: sp16),
                Expanded(
                  flex: 1,
                  child: MainButton(
                    title: 'Lưu',
                    event: () => editProduct(),
                    largeButton: true,
                    icon: null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> editProduct() async {
    DialogUtils.showLoadingDialog(context, content: 'Đang cập nhật sản phẩm');
    final res = await myBloc.editProduct();
    Navigator.of(context).pop();
    if (res.code == 200 && context.mounted) {
      widget.onConfirm?.call();
      DialogUtils.showSuccessDialog(
        context,
        content: 'Cập nhật sản phẩm thành công',
        titleConfirm: 'Chi tiết sản phẩm',
        accept: () => context.router
            .popUntil((route) => route.settings.name == 'ProductDetailRoute'),
        close: () => context.router
            .popUntil((route) => route.settings.name == 'ProductDetailRoute'),
      );
    } else {
      DialogUtils.showErrorDialog(
        context,
        content: 'Cập nhật sản phẩm thất bại',
      );
    }
  }
}
