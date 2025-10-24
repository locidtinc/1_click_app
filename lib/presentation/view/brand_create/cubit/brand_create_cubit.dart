import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/domain/entity/brand.dart';
import 'package:one_click/domain/usecase/brand_create_use_case.dart';
import 'package:one_click/presentation/routers/router.gr.dart';

import '../../../../domain/entity/product_preview.dart';
import 'brand_create_state.dart';

@injectable
class BrandCreateCubit extends Cubit<BrandCreateState> {
  BrandCreateCubit(this._brandCreateUseCase) : super(const BrandCreateState());

  final BrandCreateUseCase _brandCreateUseCase;

  final GlobalKey<FormState> keyForm = GlobalKey<FormState>();

  void imagePickerChange() async {
    final imagePicker = ImagePicker();
    final res = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 10,
    );
    if (res != null) {
      final file = File(res.path);
      emit(state.copyWith(imagePicker: file));
    }
  }

  void productsSelectedChange(List<ProductPreviewEntity> list) {
    emit(state.copyWith(productsSelected: list));
  }

  void deleteProductSelected(ProductPreviewEntity product) {
    final newList = List<ProductPreviewEntity>.from(state.productsSelected);
    newList.remove(product);
    emit(state.copyWith(productsSelected: newList));
  }

  void titleChange(String value) {
    emit(state.copyWith(title: value));
  }

  void _clearData() {
    emit(
      state.copyWith(
        title: '',
        imagePicker: null,
        productsSelected: [],
      ),
    );
  }

  bool _validateProduct() {
    for (final item in state.productsSelected) {
      if (item.brandName != null) {
        return false;
      }
    }
    return true;
  }

  Future<void> createBrand(BuildContext context, bool isContinueCreate) async {
    final validate = keyForm.currentState!.validate();
    if (!validate) return;
    final validateProduct = _validateProduct();
    if (!validateProduct) {
      final isContinue = await showDialog<bool>(
        context: context,
        builder: (context) => BasePopupNoti(
          status: StatusNoti.WARNING,
          content:
              'Có sản phẩm đã có thương hiệu. \n Bạn chắc chắn muốn thay đổi không?',
          titleConfirm: 'Tiếp tục',
          titleClose: 'Quay lại',
          close: () => Navigator.pop(context, false),
          click: () => Navigator.pop(context, true),
        ),
      );
      if (!(isContinue ?? false)) return;
    }
    if (context.mounted) {
      DialogUtils.showLoadingDialog(context, content: 'Đang tạo thương hiệu');
    }
    final res = await _createBrand();
    if (res.code == 200 && context.mounted) {
      Navigator.of(context).pop();
      switch (isContinueCreate) {
        case true:
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Tạo thương hiệu thành công',
                style: p5.copyWith(color: green_1),
              ),
              backgroundColor: green_2,
            ),
          );
          _clearData();
          break;
        default:
          DialogUtils.showSuccessDialog(
            context,
            content: 'Tạo thương hiệu thành công',
            titleClose: 'Trang danh sách',
            titleConfirm: 'Chi tiết thương hiệu',
            close: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(true);
            },
            //  context.router.popUntil(
            //     (route) => route.settings.name == 'ProductManagerRoute'),
            accept: () {
              // context.router.popUntil(
              //   (route) => route.settings.name == 'ProductManagerRoute',
              // );
              Navigator.of(context).pop();
              Navigator.of(context).pop(true);
              context.router.push(BrandDetailRoute(id: res.data?.id ?? 0));
            },
          );
      }
    } else {
      Navigator.of(context).pop();
      DialogUtils.showErrorDialog(
        context,
        content:
            'Tạo thương hiệu thất bại. \n Vui lòng kiểm tra lại ảnh hoặc tên thương hiệu',
      );
    }
  }
}

extension ApiEvent on BrandCreateCubit {
  Future<BaseResponseModel<BrandEntity>> _createBrand() async {
    final input = BrandCreateInput(
      group: [],
      product: state.productsSelected.map((e) => e.id).toList(),
      title: state.title,
      image: state.imagePicker,
      productBrand: state.productsSelected
          .where((item) => item.brandName != null)
          .map(
            (e) => ProductBrand(
              product: e.id,
              brand: e.brandId ?? 0,
            ),
          )
          .toList(),
    );
    final res = await _brandCreateUseCase.execute(input);
    return res.response;
  }
}
