import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/domain/entity/brand.dart';
import 'package:one_click/domain/usecase/category_get_list_use_case.dart';
import 'package:one_click/domain/usecase/delete_product_item_use_case.dart';
import 'package:one_click/presentation/base/dialog_custom.dart';
import 'package:one_click/presentation/config/bloc/bloc_status.dart';
import 'package:one_click/presentation/routers/router.gr.dart';

import 'category_state.dart';

@injectable
class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit(
    this._categoryGetListUseCase,
    this._deleteProductItemUseCase,
  ) : super(const CategoryState());

  final CategoryGetListUseCase _categoryGetListUseCase;
  final DeleteProductItemUseCase _deleteProductItemUseCase;

  final InfiniteListController<BrandEntity> infiniteListController =
      InfiniteListController<BrandEntity>.init();
  final ScrollController scrollController = ScrollController();

  Timer? timer;

  void searchKeyChange(String value) {
    emit(state.copyWith(searchKey: value));

    if (timer != null) {
      timer!.cancel();
    }

    timer = Timer(const Duration(seconds: 1), () {
      infiniteListController.onRefresh();
    });
  }

  void optionChange(TypeCategory value) {
    emit(state.copyWith(optionsSelected: value, isOpenPop: false));
    infiniteListController.onRefresh();
  }

  void filterChange(FilterButtonItem value) {
    infiniteListController.onRefresh();
    emit(state.copyWith(selectFilter: value, status: BlocStatus.success));
  }

  void isOpenPopChange() {
    emit(state.copyWith(isOpenPop: !state.isOpenPop));
  }

  void onTapItem(BuildContext context, int id) async {
    if (state.optionsSelected == TypeCategory.brand) {
      context.router.push(
        BrandDetailRoute(id: id),
      );
      return;
    }
    if (state.optionsSelected == TypeCategory.category) {
      final result = await context.router.push(
        CategoryDetailRoute(id: id),
      );
      if (result != null && result == 200) {
        infiniteListController.onRefresh();
      }
      return;
    }
    context.router.push(GroupDetailRoute(id: id));
  }

  void onTapDelete(BuildContext context, int id) async {
    DialogCustoms.showErrorDialog(
      context,
      content: Text(
        'Xác nhận xoá ${state.optionsSelected.value.toLowerCase()} này?',
        style: p6,
      ),
      click: () {
        Navigator.of(context).pop();
        _confirmDelete(context, id);
      },
    );
  }

  void _confirmDelete(BuildContext context, int id) async {
    DialogUtils.showLoadingDialog(context, content: 'Đang xoá, vui lòng đợi!');
    final res = await _deleteProductItemUseCase
        .execute(ProductItemInput(id, state.optionsSelected.endPoint));
    if (res.code == 200 && context.mounted) {
      Navigator.of(context).pop();
      DialogCustoms.showSuccessDialog(
        context,
        content: const Text(
          'Xoá thành công!',
          style: p6,
        ),
        click: () async {
          Navigator.of(context).pop();
          infiniteListController.onRefresh();
        },
      );
    }
  }
}

extension ApiEvent on CategoryCubit {
  Future<List<BrandEntity>> getListBrand(int page) async {
    final input = CategoryGetListInput(
      typeCategory: state.optionsSelected,
      page: page + 1,
      limit: state.limit,
      searchKey: state.searchKey,
      code: state.selectFilter.value,
    );
    final res = await _categoryGetListUseCase.execute(input);
    return res.response.data as List<BrandEntity>;
  }
}
