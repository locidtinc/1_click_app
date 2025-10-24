import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/domain/entity/category_detail_entity.dart';
import 'package:one_click/domain/entity/group_entity.dart';
import 'package:one_click/domain/usecase/create_product_group_use_case.dart';
import 'package:one_click/domain/usecase/update_category_use_case.dart';
import 'package:one_click/presentation/base/dialog_custom.dart';
import 'package:one_click/presentation/view/category_detail/widgets/dialog_create_product_group.dart';
import 'package:one_click/presentation/view/category_edit/cubit/category_edit_state.dart';

@injectable
class CategoryEditCubit extends Cubit<CategoryEditState> {
  CategoryEditCubit(
    this._createProductGroupUseCase,
    this._updateCategoryUseCase,
  ) : super(const CategoryEditState());
  final CreateProductGroupUseCase _createProductGroupUseCase;
  final UpdateCategoryUseCase _updateCategoryUseCase;

  final formKey = GlobalKey<FormState>();

  void initData(CategoryDetailEntity category) {
    emit(state.copyWith(category: category));
  }

  void onChangeTitle(String value) {
    final category = state.category?.copyWith(title: value);
    emit(state.copyWith(category: category));
  }

  String? validateCategory(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập tên ngành hàng';
    }
    return null;
  }

  void _onChangeProductGroup(String? value) {
    emit(state.copyWith(productGroup: value));
  }

  void onTapCreateGroup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return DialogCreateProductGroup(
          onChanged: _onChangeProductGroup,
          onTapConfirm: () async {
            Navigator.of(context, rootNavigator: true).pop();
            DialogUtils.showLoadingDialog(
              context,
              content: 'Đang tạo nhóm sản phẩm, vui lòng đợi!',
            );
            final res = await _createProductGroupUseCase.execute(
              CreateProductGroupInput(
                product: [],
                title: state.productGroup,
                productCategory: state.category?.id,
              ),
            );
            if (res.code == 200 && context.mounted) {
              Navigator.of(context).pop();
              DialogCustoms.showSuccessDialog(
                context,
                content: const Text(
                  'Tạo nhóm sản phẩm thành công!',
                  style: p5,
                ),
                click: () {
                  Navigator.of(context).pop();
                  final group = GroupEntity(
                    id: res.data?.id ?? 0,
                    title: res.data?.title ?? '',
                    code: res.data?.code ?? '',
                    account: res.data?.account ?? 0,
                  );
                  final List<GroupEntity> listGroup = [
                    ...state.category!.groups
                  ];
                  listGroup.add(group);
                  final category = state.category?.copyWith(groups: listGroup);
                  emit(state.copyWith(category: category));
                },
              );
            } else {
              Navigator.of(context).pop();
              DialogCustoms.showErrorDialog(
                context,
                content: const Text(
                  'Tạo nhóm sản phẩm thất bại',
                  style: p5,
                ),
              );
            }
          },
        );
      },
    );
  }

  void onTapSave(BuildContext context) async {
    DialogUtils.showLoadingDialog(
      context,
      content: 'Đang cập nhật, vui lòng đợi!',
    );
    final res = await _updateCategoryUseCase.execute(
      UpdateCategoryInput(
        state.category!.id,
        state.category!.title,
        state.category!.groups.map((e) => e.id).toList(),
      ),
    );
    if (res.code == 200 && context.mounted) {
      Navigator.of(context).pop();
      Navigator.of(context).pop(res.code);
    } else {
      Navigator.of(context).pop();
      DialogUtils.showErrorDialog(
        context,
        content: res.message ?? 'Cập nhật thất bại!',
      );
    }
  }

  void onTapCancel(BuildContext context) {
    DialogCustoms.showNotifyDialog(
      context,
      content: const Text(
        'Bạn có muốn thoát không?',
        style: p6,
      ),
      click: () {
        int count = 2;
        context.router.popUntil((route) => count-- <= 0);
      },
    );
  }

  void deleteItem(BuildContext context, int index) {
    DialogCustoms.showErrorDialog(
      context,
      content: const Text(
        'Xác nhận xoá nhóm sản phẩm \nkhỏi ngành hàng này?',
        style: p4,
        textAlign: TextAlign.center,
      ),
      click: () {
        Navigator.of(context).pop();
        final listGroup = [...state.category!.groups];
        listGroup.removeAt(index);
        final category = state.category?.copyWith(groups: listGroup);
        emit(state.copyWith(category: category));
      },
    );
  }
}
