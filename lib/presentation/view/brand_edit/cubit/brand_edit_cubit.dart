import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/domain/entity/brand_detail_entity.dart';
import 'package:one_click/domain/entity/product_preview.dart';
import 'package:one_click/domain/usecase/update_product_brand_use_case.dart';
import 'package:one_click/presentation/base/dialog_custom.dart';
import 'package:one_click/presentation/routers/router.gr.dart';
import 'package:one_click/presentation/view/brand_edit/cubit/brand_edit_state.dart';
import 'package:one_click/shared/constants/app_constant.dart';

@injectable
class BrandEditCubit extends Cubit<BrandEditState> {
  BrandEditCubit(this._updateProductBrand) : super(const BrandEditState());

  final UpdateProductBrandUseCase _updateProductBrand;

  final keyForm = GlobalKey<FormState>();

  void titleChange(String value) {
    final brand = state.brand?.copyWith(title: value);
    emit(state.copyWith(brand: brand));
  }

  String? validateBrand(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Vui lòng điền tên thương hiệu';
    }
    return null;
  }

  void initData(BrandDetailEntity? brand) {
    emit(state.copyWith(brand: brand));
  }

  void imagePickerChange() async {
    final imagePicker = ImagePicker();
    final res = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 10,
    );
    if (res != null) {
      final file = File(res.path);
      final brand = state.brand?.copyWith(image: file.path);
      emit(state.copyWith(brand: brand));
    }
  }

  void onTapAddProduct(BuildContext context) {
    context.router.push(
      AddProductRoute(
        onConfirm: (List<ProductPreviewEntity> list) =>
            _productsSelectedChange(list),
        listProductInit: state.brand?.products ?? [],
      ),
    );
  }

  void deleteProductSelected(ProductPreviewEntity product) {
    final newList =
        List<ProductPreviewEntity>.from(state.brand?.products ?? []);
    newList.remove(product);
    final brand = state.brand?.copyWith(products: newList);
    emit(state.copyWith(brand: brand));
  }

  void onTapCancel(BuildContext context) {
    DialogCustoms.showNotifyDialog(
      context,
      content: const Text('Bạn có muốn thoát không?', style: p6),
      click: () {
        int count = 2;
        context.router.popUntil((route) => count-- <= 0);
      },
    );
  }

  void onTapSave(BuildContext context) async {
    DialogUtils.showLoadingDialog(
      context,
      content: 'Đang cập nhật, vui lòng đợi!',
    );
    final res = await _updateProductBrand.execute(
      UpdateBrandInput(
        state.brand?.id ?? 0,
        state.brand?.title ?? '',
        state.brand?.products.map((e) => e.id).toList() ?? [],
        state.brand!.image!.startsWith(AppConstant.http)
            ? null
            : File(state.brand!.image ?? ''),
      ),
    );
    if (res.code == 200 && context.mounted) {
      Navigator.of(context).pop();
      Navigator.of(context).pop(res.data);
    } else {
      Navigator.of(context).pop();
      DialogCustoms.showErrorDialog(
        context,
        content: Text(res.message ?? 'Cập nhật thất bại!'),
      );
    }
  }

  void _productsSelectedChange(List<ProductPreviewEntity> list) {
    final brand = state.brand?.copyWith(products: list);
    emit(state.copyWith(brand: brand));
  }
}
