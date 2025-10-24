import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/domain/entity/brand_detail_entity.dart';
import 'package:one_click/domain/usecase/delete_product_item_use_case.dart';
import 'package:one_click/domain/usecase/get_brand_detail_use_case.dart';
import 'package:one_click/presentation/base/dialog_custom.dart';
import 'package:one_click/presentation/routers/router.gr.dart';

import 'brand_detail_state.dart';

@injectable
class BrandDetailCubit extends Cubit<BrandDetailState> {
  BrandDetailCubit(this._getBrandDetailUseCase, this._deleteProductItemUseCase)
      : super(const BrandDetailState());

  final GetBrandDetailUseCase _getBrandDetailUseCase;
  final DeleteProductItemUseCase _deleteProductItemUseCase;

  bool isLoading = false;

  void getBrandDetail(int id) async {
    isLoading = true;
    final res = await _getBrandDetailUseCase.execute(id);
    emit(state.copyWith(brandDetail: res));
    isLoading = false;
  }

  void onTapEditBrand(BuildContext context) async {
    final result =
        await context.router.push(BrandEditRoute(brand: state.brandDetail));
    if (result != null && context.mounted) {
      DialogCustoms.showSuccessDialog(
        context,
        content: const Text(
          'Cập nhật thương hiệu thành công',
          style: p6,
        ),
        click: () {
          Navigator.of(context).pop();
          final brand = result as BrandDetailEntity;
          emit(state.copyWith(brandDetail: brand));
        },
      );
    }
  }

  void onTapDeleteBrand(BuildContext context, int id) {
    DialogUtils.showErrorDialog(
      context,
      content: 'Xác nhận xoá thương hiệu này?',
      close: () {
        Navigator.of(context).pop();
      },
      accept: () async {
        Navigator.of(context).pop();
        DialogUtils.showLoadingDialog(
          context,
          content: 'Đang xoá thương hiệu, vui lòng đợi!',
        );
        final res = await _deleteProductItemUseCase.execute(
          ProductItemInput(id, 'productbrand'),
        );
        if (res.code == 200 && context.mounted) {
          Navigator.of(context).pop();
          DialogCustoms.showSuccessDialog(
            context,
            content: const Text('Xoá thương hiệu thành công!', style: p6),
            click: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(res.code);
            },
          );
        } else {
          Navigator.of(context).pop();
          DialogUtils.showErrorDialog(
            context,
            content: res.message ?? 'Xoá thương hiệu thất bại!',
          );
        }
      },
    );
  }
}
