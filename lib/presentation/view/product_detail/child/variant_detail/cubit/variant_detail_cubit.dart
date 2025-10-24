import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/domain/entity/variant_entity.dart';
import 'package:one_click/domain/usecase/get_variant_detail_use_case.dart';
import 'package:one_click/domain/usecase/product_shipments_use_case.dart';
import 'package:one_click/domain/usecase/update_variant_use_case.dart';
import 'package:one_click/presentation/base/dialog_custom.dart';
import 'package:one_click/presentation/routers/router.gr.dart';
import 'package:one_click/presentation/view/product_detail/child/variant_detail/cubit/variant_detail_state.dart';
import 'package:one_click/shared/utils/event.dart';

@injectable
class VariantDetailCubit extends Cubit<VariantDetailState> {
  VariantDetailCubit(this._getVariantDetailUseCase, this._updateVariantUseCase,
      this._productShipmentsUseCase)
      : super(const VariantDetailState());

  final GetVariantDetailUseCase _getVariantDetailUseCase;
  final UpdateVariantUseCase _updateVariantUseCase;
  final ProductShipmentsUseCase _productShipmentsUseCase;

  bool isLoading = false;

  void getProductPatternDetail(int id) async {
    isLoading = true;
    final res = await _getVariantDetailUseCase.execute(VariantDetailInput(id));
    emit(state.copyWith(variantEntity: res.variantEntity));
    isLoading = false;
  }

  Future<void> onTapEditVariant(BuildContext context, int id) async {
    final result = await context.router
        .push(EditVariantRoute(variant: state.variantEntity!));
    if (result != null && context.mounted) {
      DialogUtils.showSuccessDialog(
        context,
        content: 'Cập nhật mẫu mã thành công',
        accept: () async {
          Navigator.of(context).pop();
          getProductPatternDetail(id);
        },
      );
    }
  }

  Future<void> deleteVariant(BuildContext context, VariantEntity variant,
      Function()? onConfirm) async {
    DialogCustoms.showErrorDialog(
      context,
      content: const Column(
        children: [
          Text(
            'Xác nhận xóa mẫu mã này?',
            style: p4,
          ),
          SizedBox(height: 4),
        ],
      ),
      titleClose: 'Huỷ bỏ',
      click: () async {
        Navigator.of(context).pop();
        // DialogUtils.showLoadingDialog(
        //   context,
        //   content: 'Đang xoá mẫu mã, vui lòng đợi!',
        // );
        final data = {
          'status': false,
        };
        final payload = FormData.fromMap({'data': jsonEncode(data)});
        final res = await _updateVariantUseCase
            .execute(UpdateVariantInput(variant.id, payload));
        if (res.res.code == 200 && context.mounted) {
          onConfirm?.call();
          context.router.pop(res.res.code);
        } else if (res.res.code == 400 && context.mounted) {
          onConfirm?.call();
          context.router.pop(res.res.code);
          //ĐANG ĐỢI FIX LỖI
          // DialogUtils.showErrorDialog(
          //   context,
          //   content: 'Bạn không có quyền xóa sản phẩm này',
          // );
          return;
        } else {
          Navigator.of(context).pop();
          DialogUtils.showErrorDialog(
            context,
            content: 'Xóa mẫu mã thất bại',
          );
        }
      },
    );
  }

  Future<void> init(int id) async {
    try {
      final res =
          await _productShipmentsUseCase.execute(ProductShipmentInput(id));

      if (res.response.code == 200) {
        emit(
          state.copyWith(
            listProductShipments: res.response.data,
            shipmentsInfor: res.response.extra,
          ),
        );
      }
    } catch (e) {
      print('Error in init: $e');
    }
  }
}
