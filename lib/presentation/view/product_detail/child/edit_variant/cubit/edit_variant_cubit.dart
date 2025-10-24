import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/domain/entity/variant_entity.dart';
import 'package:one_click/domain/usecase/update_variant_use_case.dart';
import 'package:one_click/presentation/view/product_detail/child/edit_variant/cubit/edit_variant_state.dart';
import 'package:one_click/shared/utils/event.dart';

@injectable
class EditVariantCubit extends Cubit<EditVariantState> {
  EditVariantCubit(this._updateVariantUseCase)
      : super(const EditVariantState());

  final UpdateVariantUseCase _updateVariantUseCase;

  void barCodeChange(String value) {
    emit(state.copyWith(barCode: value));
  }

  void priceImportChange(String value) {
    emit(state.copyWith(priceImport: value));
  }

  void priceSellChange(String value) {
    emit(state.copyWith(priceSell: value));
  }

  void onChangeSell(bool value) {
    emit(state.copyWith(isSell: value));
  }

  void onChangeAmount(String value) {
    emit(state.copyWith(amount: int.parse(value)));
  }

  void onSelectImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? images = await picker.pickImage(source: ImageSource.gallery);
    emit(state.copyWith(image: images));
  }

  void onTapCancel(BuildContext context) {
    Navigator.pop(context);
  }

  Future<void> onTapSave(BuildContext context, VariantEntity variant) async {
    DialogUtils.showLoadingDialog(
      context,
      content: 'Đang tạo cập nhật, vui lòng đợi!',
    );
    final data = {
      'barcode': state.barCode ?? variant.barCode,
      'price_sell': formatCurrencyString(
        state.priceSell ?? variant.priceSell.toInt().toString(),
      ),
      'price_import': formatCurrencyString(
        state.priceImport ?? variant.priceImport.toInt().toString(),
      ),
      'status': state.isSell,
      'quantity': state.amount ?? variant.amount,
    };
    final payload = (state.image != null)
        ? FormData.fromMap({
            'data': jsonEncode(data),
            'image': await MultipartFile.fromFile(state.image?.path ?? ''),
          })
        : FormData.fromMap({'data': jsonEncode(data)});
    final res = await _updateVariantUseCase
        .execute(UpdateVariantInput(variant.id, payload));
    Navigator.of(context).pop();
    if (res.res.code == 200 && context.mounted) {
      context.router.pop(res.res.code);
      return;
    }
    context.router.pop(res.res.code);

    // if (res.res.code == 400 && context.mounted) {
    //   DialogUtils.showErrorDialog(
    //     context,
    //     content: 'Bạn không có quyền cập nhật sản phẩm này',
    //   );
    //   return;
    // }
    // DialogUtils.showErrorDialog(
    //   context,
    //   content: 'Cập nhật mẫu mã thất bại',
    // );
  }
}
