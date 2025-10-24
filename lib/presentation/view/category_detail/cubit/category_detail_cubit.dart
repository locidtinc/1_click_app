import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/domain/usecase/delete_product_item_use_case.dart';
import 'package:one_click/domain/usecase/get_category_detail_use_case.dart';
import 'package:one_click/presentation/base/dialog_custom.dart';
import 'package:one_click/presentation/routers/router.gr.dart';
import 'package:one_click/presentation/view/category_detail/cubit/category_detail_state.dart';

@injectable
class CategoryDetailCubit extends Cubit<CategoryDetailState> {
  CategoryDetailCubit(
    this._getCategoryDetailUseCase,
    this._deleteProductItemUseCase,
  ) : super(const CategoryDetailState());

  final GetCategoryDetailUseCase _getCategoryDetailUseCase;
  final DeleteProductItemUseCase _deleteProductItemUseCase;

  bool isLoading = false;

  void getProductCategoryDetail(int id) async {
    isLoading = true;
    final res = await _getCategoryDetailUseCase.execute(id);
    emit(state.copyWith(category: res));
    isLoading = false;
  }

  void onChangeProductGroup(String? value) {
    emit(state.copyWith(productGroup: value));
  }

  void onTapDeleteCategory(BuildContext context) {
    DialogCustoms.showErrorDialog(
      context,
      content: const Text(
        'Xác nhận xoá ngành hàng này?',
        style: p4,
      ),
      click: () async {
        Navigator.of(context).pop();
        DialogUtils.showLoadingDialog(
          context,
          content: 'Đang xoá ngành hàng, vui lòng đợi!',
        );
        final res = await _deleteProductItemUseCase
            .execute(ProductItemInput(state.category.id, 'productcategory'));
        if (res.code == 200 && context.mounted) {
          Navigator.of(context).pop();
          DialogCustoms.showSuccessDialog(
            context,
            content: const Text('Xoá ngành hàng thành công!', style: p6),
            click: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(res.code);
            },
          );
        } else {
          Navigator.of(context).pop();
          DialogUtils.showErrorDialog(
            context,
            content: res.message ?? 'Xoá ngành hàng thất bại!',
          );
        }
      },
    );
  }

  void onTapEditCategory(BuildContext context) async {
    final result =
        await context.router.push(CategoryEditRoute(category: state.category));
    if (result != null && result == 200 && context.mounted) {
      DialogCustoms.showSuccessDialog(
        context,
        content: const Text('Cập nhật thành công!', style: p6),
        click: () {
          Navigator.of(context).pop();
          getProductCategoryDetail(state.category.id);
        },
      );
    }
  }
}
