import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/domain/entity/product_preview.dart';
import 'package:one_click/domain/usecase/product_get_use_case.dart';
import 'package:one_click/presentation/base/dialog_custom.dart';
import 'package:one_click/shared/constants/local_storage/app_shared_preference.dart';
import 'package:one_click/shared/constants/pref_keys.dart';
import '../../../../domain/entity/product_detail_entity.dart';
import '../../../../domain/usecase/product_by_qrcode.dart';
import 'add_product_state.dart';

@injectable
class AddProductCubit extends Cubit<AddProductState> {
  AddProductCubit(this._productPreviewUseCase, this._productByQrcodeUseCase)
      : super(const AddProductState());

  final ProductPreviewUseCase _productPreviewUseCase;
  final ProductByQrcodeUseCase _productByQrcodeUseCase;

  final InfiniteListController<ProductPreviewEntity> infiniteListController =
      InfiniteListController<ProductPreviewEntity>.init();
  final ScrollController scrollController = ScrollController();

  Timer? timer;

  void updateListProductSelected(List<ProductPreviewEntity> list) {
    emit(state.copyWith(productsSelected: list));
  }

  void searchKeyChange(String value) {
    emit(state.copyWith(searchKey: value));

    if (timer != null) {
      timer!.cancel();
    }

    timer = Timer(const Duration(seconds: 1), () {
      infiniteListController.onRefresh();
    });
  }

  void checkboxToggle(ProductPreviewEntity product) {
    final listProduct = List<ProductPreviewEntity>.from(state.productsSelected);
    final index = state.productsSelected.indexWhere((e) => e.id == product.id);
    if (index == -1) {
      listProduct.add(product);
    } else {
      listProduct.remove(listProduct[index]);
    }
    emit(state.copyWith(productsSelected: listProduct));
  }
}

extension ApiEvent on AddProductCubit {
  Future<List<ProductPreviewEntity>> getListProduct(int page) async {
    final account = AppSharedPreference.instance.getValue(PrefKeys.user);
    final input = ProductPreviewInput(
      keySearch: state.searchKey,
      limit: state.limit,
      page: page + 1,
      account: account as int?,
    );
    final res = await _productPreviewUseCase.execute(input);
    return res.listProduct;
  }

  Future<ProductDetailEntity?> getProductByQrcode(String? barcode) async {
    final input = ProductByQrcodeInput(barcode);
    final res = await _productByQrcodeUseCase.execute(input);
    if (res.response.data?.isEmpty ?? true) return null;
    final productDetail = res.response.data?[0];
    final productPreview = ProductPreviewEntity(
      id: productDetail?.id ?? 0,
      imageUrl: (productDetail?.images.isNotEmpty ?? false)
          ? productDetail!.images[0]
          : '',
      productName: productDetail?.title ?? '',
      productCode: productDetail?.code ?? '',
      productPrice: productDetail?.priceSell.round() ?? 0,
      brandName: productDetail?.brand ?? '',
      brandId: productDetail?.brandId ?? 0,
      groupName: productDetail?.productGroup ?? '',
      groupId: productDetail?.groupId ?? 0,
    );
    checkboxToggle(productPreview);
    return res.response.data?[0];
  }

  void onTapCancel(BuildContext context) {
    DialogCustoms.showNotifyDialog(
      context,
      content: const Padding(
        padding: EdgeInsets.only(bottom: 24),
        child: Text('Bạn có muốn thoát không?'),
      ),
      click: () {
        int count = 2;
        context.router.popUntil((route) => count-- <= 0);
      },
    );
  }
}
