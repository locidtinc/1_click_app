import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/domain/entity/brand.dart';
import 'package:one_click/domain/entity/group_detail_entity.dart';
import 'package:one_click/domain/entity/product_preview.dart';
import 'package:one_click/domain/usecase/category_get_list_use_case.dart';
import 'package:one_click/domain/usecase/group_create_use_case.dart';
import 'package:one_click/domain/usecase/update_product_group_use_case.dart';
import 'package:one_click/presentation/base/dialog_custom.dart';
import 'package:one_click/presentation/view/group_edit/cubit/group_edit_state.dart';
import 'package:one_click/presentation/view/product_manager/child/category/cubit/category_state.dart';

@injectable
class GroupEditCubit extends Cubit<GroupEditState> {
  GroupEditCubit(
    this._categoryGetListUseCase,
    this._updateProductGroupUseCase,
  ) : super(const GroupEditState());

  final CategoryGetListUseCase _categoryGetListUseCase;
  final UpdateProductGroupUseCase _updateProductGroupUseCase;

  bool isLoading = false;

  void titleChange(String value) {
    final groups = state.groups?.copyWith(title: value);
    emit(state.copyWith(groups: groups));
  }

  void productCategoryChange(int value) {
    emit(state.copyWith(productCategory: value));
  }

  void updateProduct(List<ProductPreviewEntity> list) {
    final groups = state.groups?.copyWith(products: list);
    emit(state.copyWith(groups: groups));
  }

  void deleteProduct(ProductPreviewEntity product) {
    final list = List<ProductPreviewEntity>.from(state.groups!.products);
    list.remove(product);
    final groups = state.groups?.copyWith(products: list);
    emit(state.copyWith(groups: groups));
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
    final res = await _updateProductGroupUseCase.execute(
      UpdateGroupInput(
        state.groups?.id ?? 0,
        GroupCreateInput(
          product: state.groups!.products.map((e) => e.id).toList(),
          productCategory: state.productCategory,
          title: state.groups?.title ?? '',
        ),
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

  Future<void> getCategory(GroupDetailEntity? groups) async {
    isLoading = true;
    final input = CategoryGetListInput(
      typeCategory: TypeCategory.category,
      page: 1,
      limit: 1000,
      searchKey: '',
      code: 'ALL',
    );
    final res = await _categoryGetListUseCase.execute(input);
    isLoading = false;
    final listDropdown = (res.response.data as List<BrandEntity>)
        .map(
          (e) => DropdownMenuItem<int>(
            value: e.id,
            child: Text(e.title, style: p6),
          ),
        )
        .toList();
    for (int i = 0; i < listDropdown.length; i++) {
      if (groups?.productCategory == listDropdown[i].value) {
        productCategoryChange(groups?.productCategory ?? 1);
      }
    }
    emit(state.copyWith(listCategory: listDropdown, groups: groups));
  }
}
