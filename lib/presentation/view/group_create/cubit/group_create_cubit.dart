import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/domain/entity/brand.dart';
import 'package:one_click/domain/usecase/category_get_list_use_case.dart';
import 'package:one_click/domain/usecase/group_create_use_case.dart';
import 'package:one_click/presentation/routers/router.gr.dart';
import 'package:one_click/presentation/view/product_manager/child/category/cubit/category_state.dart';
import '../../../../domain/entity/product_preview.dart';
import 'group_create_state.dart';

@injectable
class GroupCreateCubit extends Cubit<GroupCreateState> {
  GroupCreateCubit(this._categoryGetListUseCase, this._groupCreateUseCase)
      : super(const GroupCreateState());

  final CategoryGetListUseCase _categoryGetListUseCase;
  final GroupCreateUseCase _groupCreateUseCase;

  void titleChange(String value) {
    emit(state.copyWith(title: value));
  }

  void updateProduct(List<ProductPreviewEntity> list) {
    emit(state.copyWith(listProduct: list));
  }

  void deleteProduct(ProductPreviewEntity product) {
    final list = List<ProductPreviewEntity>.from(state.listProduct);
    list.remove(product);
    emit(state.copyWith(listProduct: list));
  }

  void productCategoryChange(int value) {
    emit(state.copyWith(productCategory: value));
  }

  String? validate() {
    if (state.productCategory == null) {
      return 'Vui lòng chọn ngành hàng';
    }
    return null;
  }

  void clearData() {
    emit(
      state.copyWith(
        title: '',
        listProduct: [],
        productCategory: null,
      ),
    );
  }

  Future<void> createGroup(BuildContext context) async {
    final String? validates = validate();
    if (validates != null) {
      DialogUtils.showErrorDialog(context, content: validates);
      return;
    }
    DialogUtils.showLoadingDialog(
      context,
      content: 'Đang tạo nhóm sản phẩm mới',
    );
    final res = await _createGroup();
    if (res.code == 200 && context.mounted) {
      Navigator.pop(context);
      DialogUtils.showSuccessDialog(
        context,
        content: 'Tạo nhóm sản phẩm thành công',
        close: () {
          context.router.popUntil(
              (route) => route.settings.name == 'ProductManagerRoute');
        },
        accept: () {
          Navigator.of(context).pop();
          context.pushRoute(GroupDetailRoute(id: res.data.id));
        },
      );
    } else {
      Navigator.pop(context);
      DialogUtils.showErrorDialog(
        context,
        content: 'Tạo nhóm sản pẩm thất bại',
      );
    }
  }

  Future<void> saveAndCreateMore(BuildContext context) async {
    final String? validates = validate();
    if (validates != null) {
      DialogUtils.showErrorDialog(context, content: validates);
      return;
    }
    DialogUtils.showLoadingDialog(
      context,
      content: 'Đang tạo nhóm sản phẩm mới',
    );
    final res = await _createGroup();
    if (res.code == 200 && context.mounted) {
      clearData();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Tạo nhóm sản phẩm thành công',
            style: p5.copyWith(color: green_1),
          ),
          backgroundColor: green_2,
        ),
      );
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Tạo nhóm sản phẩm thất bại',
            style: p5.copyWith(color: red_1),
          ),
          backgroundColor: red_2,
        ),
      );
    }
  }

  Future<void> getCategory() async {
    final input = CategoryGetListInput(
      typeCategory: TypeCategory.category,
      page: 1,
      limit: 1000,
      searchKey: '',
      code: 'ALL',
    );
    final res = await _categoryGetListUseCase.execute(input);
    final listDropdown = (res.response.data as List<BrandEntity>)
        .map(
          (e) => DropdownMenuItem<int>(
            value: e.id,
            child: Text(e.title, style: p6),
          ),
        )
        .toList();
    emit(state.copyWith(listCategory: listDropdown));
  }

  Future<BaseResponseModel> _createGroup() async {
    final input = GroupCreateInput(
      product: state.listProduct.map((e) => e.id).toList(),
      productCategory: state.productCategory,
      title: state.title,
    );
    final res = await _groupCreateUseCase.execute(input);
    return res.response;
  }
}
