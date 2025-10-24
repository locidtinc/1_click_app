import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/domain/usecase/create_category_use_case.dart';
import 'package:one_click/presentation/base/dialog_custom.dart';
import 'package:one_click/presentation/routers/router.gr.dart';
import 'package:one_click/presentation/view/category_create/cubit/category_create_state.dart';

@injectable
class CategoryCreateCubit extends Cubit<CategoryCreateState> {
  CategoryCreateCubit(this._createCategoryUseCase)
      : super(const CategoryCreateState());

  final CreateCategoryUseCase _createCategoryUseCase;

  final formKey = GlobalKey<FormState>();

  void onChangeTitle(String value) {
    emit(state.copyWith(title: value));
  }

  String? validateCategory(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập tên ngành hàng';
    }
    return null;
  }

  void _clearData() {
    emit(state.copyWith(title: ''));
  }

  void onTapCreateCategory(BuildContext context, bool isCreateMore) async {
    if (!formKey.currentState!.validate()) return;
    DialogUtils.showLoadingDialog(
      context,
      content: 'Đang tạo ngành hàng, vui lòng đợi!',
    );
    final res = await _createCategoryUseCase
        .execute(CreateCategoryUseCaseInput(state.title, []));
    if (res.code == 200 && context.mounted) {
      Navigator.of(context).pop();
      switch (isCreateMore) {
        case true:
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Tạo ngành hàng thành công',
                style: p5.copyWith(color: green_1),
              ),
              backgroundColor: green_2,
            ),
          );
          _clearData();
          break;
        default:
          DialogCustoms.showSuccessDialog(
            context,
            content: const Text(
              'Tạo ngành hàng thành công',
              style: p6,
            ),
            click: () {
              context.router.pop();
              context.router
                  .popAndPush(CategoryDetailRoute(id: res.data?.id ?? 0));
            },
          );
      }
    } else {
      Navigator.of(context).pop();
      DialogUtils.showErrorDialog(
        context,
        content: res.message ?? 'Tạo ngành hàng thất bại',
      );
    }
  }
}
