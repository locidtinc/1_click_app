import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/domain/entity/product_detail_entity.dart';
import 'package:one_click/domain/entity/product_preview.dart';
import 'package:one_click/domain/entity/variant_entity.dart';
import 'package:one_click/domain/usecase/get_variant_detail_use_case.dart';
import 'package:one_click/domain/usecase/product_get_use_case.dart';
import 'package:one_click/domain/usecase/variant_get_list_department_use_case.dart';
import 'package:one_click/domain/usecase/variant_get_list_use_case.dart';
import 'package:one_click/presentation/base/dialog_custom.dart';
import 'package:one_click/presentation/routers/router.gr.dart';
import 'package:one_click/shared/constants/local_storage/app_shared_preference.dart';
import 'package:one_click/shared/constants/pref_keys.dart';
import 'package:one_click/shared/ext/index.dart';
import 'package:one_click/shared/utils/debounce.dart';
import 'package:one_click/shared/utils/delay_callback.dart';

import '../../../../../../domain/usecase/product_by_qrcode.dart';
import 'product_state.dart';

@injectable
class ProductCubit extends Cubit<ProductState> {
  ProductCubit(
    this._productPreviewUseCase,
    this._productByQrcodeUseCase,
    this._variantGetListUseCase,
    this._getProductManagerDetailUseCase,
    this._variantGetListDepartmentUseCase,
  ) : super(const ProductState());

  final ProductPreviewUseCase _productPreviewUseCase;
  final ProductByQrcodeUseCase _productByQrcodeUseCase;
  final ScrollController scrollController = ScrollController();
  final InfiniteListController<ProductPreviewEntity> infiniteListController =
      InfiniteListController<ProductPreviewEntity>.init();

  final VariantGetListUseCase _variantGetListUseCase;
  final GetVariantDetailUseCase _getProductManagerDetailUseCase;
  final VariantGetListDepartmentUseCase _variantGetListDepartmentUseCase;
  final InfiniteListController<VariantEntity> variantListController =
      InfiniteListController<VariantEntity>.init();

  // Future<void> getListProductPreview() async {
  //   final res = await _productPreviewUseCase.execute(ProductPreviewInput());
  //   emit(state.copyWith(listProduct: res.listProduct));
  // }

  final delay = DelayCallBack(delay: 1.seconds);

  @override
  Future<void> close() {
    infiniteListController.dispose();
    scrollController.dispose();
    variantListController.dispose();
    return super.close();
  }

  Future<List<ProductPreviewEntity>> getListProductPreview(int page) async {
    final warehouseId =
        AppSharedPreference.instance.getValue(PrefKeys.warehouseId) as int?;
    final input = ProductPreviewInput(
      page: page + 1,
      limit: state.limit,
      keySearch: state.keySearch,
      systemCode: state.systemSelected.code,
      statusOnline: state.statusSelected.code,
      warehouseId: warehouseId,
      statusProduct: state.statusSelected == StatusFilter.all
          ? null
          : state.statusSelected == StatusFilter.hide
              ? false
              : true,
      variantAmountWarehouse:
          state.inventorySelected == InventoryFilter.stocking ? 56 : null,
      excludeVariantAmountWarehouse:
          state.inventorySelected == InventoryFilter.outOfStock ? 56 : null,
    );
    final res = await _productPreviewUseCase.execute(input);
    return res.listProduct;
  }

  int _page = 1;
  bool isLoading = false;
  Future<List<ProductPreviewEntity>> searchPrdByBarcode({
    required String search,
    bool isMore = false,
  }) async {
    if (isMore) {
      _page++;
    } else {
      _page = 1;
    }
    final input = ProductPreviewInput(
      page: _page,
      limit: state.limit,
      keySearch: '',
      barcode: search,
      search: search,
    );
    final res = await _productPreviewUseCase.prdSuggest(input);

    return res.listProduct;
  }

  Future<List<ProductPreviewEntity>> searchPrd({
    required String search,
    bool isMore = false,
  }) async {
    if (isMore) {
      _page++;
    } else {
      _page = 1;
    }
    final input = ProductPreviewInput(
      page: _page,
      limit: state.limit,
      keySearch: '',
      search: search,
    );
    final res = await _productPreviewUseCase.prdSuggest(input);

    return res.listProduct;
  }

  Future<ProductDetailEntity?> getProductByQrcode(String? barcode) async {
    final input = ProductByQrcodeInput(barcode);
    final res = await _productByQrcodeUseCase.execute(input);
    final data = res.response.data;
    if (data != null && data.isNotEmpty) {
      return data[0];
    }
    return null;
  }

  void onTapItem(BuildContext context, ProductPreviewEntity item) async {
    final result =
        await context.router.push(ProductDetailRoute(productId: item.id));
    if (result != null && context.mounted) {
      DialogCustoms.showSuccessDialog(
        context,
        content: const Text(
          'Sản phẩm đã được xoá thành công!',
          style: p6,
        ),
        click: () {
          Navigator.of(context).pop();
          infiniteListController.onRefresh();
        },
      );
    }
  }

  void onTapPrdItem(
    BuildContext context,
    VariantEntity item, {
    Function()? onConfirm,
  }) async {
    // await context.router.push(ProductDetailRoute(productId: item.id));
    await context.router
        .push(VariantDetailRoute(id: item.id, onConfirm: onConfirm));
  }

  void searchKeyChange(String value) {
    emit(state.copyWith(keySearch: value));

    delay.debounce(() => infiniteListController.onRefresh());
  }

  void filterChange({
    StatusFilter? status,
    SystemFilter? system,
    InventoryFilter? inventory,
  }) {
    emit(
      state.copyWith(
        statusSelected: status ?? state.statusSelected,
        systemSelected: system ?? state.systemSelected,
        inventorySelected: inventory ?? state.inventorySelected,
      ),
    );
    infiniteListController.onRefresh();
  }

  Future<List<VariantEntity>> getListVariant(int page) async {
    final input = VariantGetListDepartmentInput(
      page: page + 1,
      limit: state.limit,
      searchKey: state.keySearch,
    );
    final res = await _variantGetListDepartmentUseCase.execute(input);
    countPrd(res.responseEntity.extra);
    // return res.responseEntity.data?.where((e) => e.status != false).toList() ?? [];
    return res.responseEntity.data ?? [];
  }

  void countPrd(int count) {
    emit(state.copyWith(count: count));
  }

  // Future<List<VariantEntity>> getVariantDetailManager(int id) async {
  //   // final warehouseId = AppSharedPreference.instance.getValue(PrefKeys.warehouseId) as int?;
  //   final res = await _variantGetListUseCase.execute(input);
  //   return res.responseEntity.data as List<VariantEntity>;
  // }
  void getVariantDetailManager(int id) async {
    isLoading = true;
    final res =
        await _getProductManagerDetailUseCase.execute(VariantDetailInput(id));
    emit(state.copyWith(variantEntity: res.variantEntity));
    isLoading = false;
  }
}
