import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/domain/usecase/delete_product_use_case.dart';
import 'package:one_click/domain/usecase/product_get_item_use_case.dart';
import 'package:one_click/presentation/base/dialog_custom.dart';
import 'package:one_click/presentation/view/product_detail/cubit/product_detail_state.dart';

@injectable
class ProductDetailCubit extends Cubit<ProductDetailState> {
  ProductDetailCubit(
    this._productGetItemUseCase,
    this._deleteProductUseCase,
  ) : super(const ProductDetailState());

  final ProductGetItemUseCase _productGetItemUseCase;

  final DeleteProductUseCase _deleteProductUseCase;

  bool isLoading = false;
  int selectedImage = 0;

  Future<void> loadData(int productId) async {
    isLoading = true;
    await Future.delayed(Duration.zero);
    final res = await _productGetItemUseCase
        .buildUseCase(ProductDetailInput(productId));
    emit(state.copyWith(productDetailEntity: res.productDetailEntity));
    isLoading = false;
  }

  void onTapItemImage(int index) {
    emit(state.copyWith(selectedImage: index));
  }

  void deleteProduct(BuildContext context, int productId) {
    DialogCustoms.showErrorDialog(
      context,
      content: Column(
        children: [
          const Text(
            'Xác nhận xóa sản phẩm này?',
            style: p4,
          ),
          const SizedBox(height: 4),
          Text(
            'Các mẫu mã của sản phẩm cũng sẽ bị xóa',
            style: p6.copyWith(color: borderColor_4),
          ),
          const SizedBox(height: 24),
        ],
      ),
      titleClose: 'Huỷ bỏ',
      click: () async {
        Navigator.of(context).pop();
        DialogUtils.showLoadingDialog(
          context,
          content: 'Đang xoá sản phẩm, vui lòng đợi!',
        );
        final res =
            await _deleteProductUseCase.execute(DeleteProductInput(productId));
        if (res.code == 200 && context.mounted) {
          Navigator.of(context).pop();
          Navigator.of(context).pop(res.code);
        } else {
          Navigator.of(context).pop();
          DialogUtils.showErrorDialog(
            context,
            content: 'Không thể xóa sản phẩm đã phát sinh đơn',
          );
        }
      },
    );
  }
}
