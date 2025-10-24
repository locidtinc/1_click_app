import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/domain/entity/cart_entity.dart';
import 'package:one_click/domain/usecase/order_create_use_case.dart';
import 'package:one_click/domain/entity/order_create.dart';
import 'package:one_click/domain/entity/order_import_create.dart';
import 'package:one_click/domain/entity/variant_entity.dart';
import 'package:one_click/presentation/shared_view/order/order_widget.dart';
import 'package:one_click/presentation/view/order_create/cubit/order_create_state.dart';
import 'package:one_click/presentation/view/shopping_cart/cubit/shopping_cart_cubit.dart';
import 'package:one_click/shared/constants/local_storage/app_shared_preference.dart';
import 'package:one_click/shared/constants/pref_keys.dart';

import '../../../../domain/usecase/get_variant_detail_use_case.dart';
import '../../../routers/router.gr.dart';
import 'variant_detail_mykiot_state.dart';

@injectable
class VariantDetailMykiotCubit extends Cubit<VariantDetailMykiotState> {
  VariantDetailMykiotCubit(
    this._getVariantDetailUseCase,
    this._orderCreateUseCase,
  ) : super(const VariantDetailMykiotState());

  final GetVariantDetailUseCase _getVariantDetailUseCase;
  final OrderCreateUseCase _orderCreateUseCase;

  bool isLoading = false;

  Future<void> getProductPatternDetail(int id) async {
    isLoading = true;
    final res = await _getVariantDetailUseCase.execute(VariantDetailInput(id));
    emit(state.copyWith(variantEntity: res.variantEntity));
    isLoading = false;
  }

  void onTapEditVariant(BuildContext context, int id) async {
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

  void onTapOrder(
    BuildContext context, {
    String? title,
    ShoppingCartCubit? cartCubit,
    int? id,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(sp12),
        ),
      ),
      isScrollControlled: true,
      builder: (_) {
        // final myBloc = getIt.get<ShoppingCartCubit>();
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: OrderWidget(
            variant: state.variantEntity!,
            titleButton: title ?? 'Mua hàng',
            onTap: (int value, int discount) async {
              if (value == 0) return;
              if (title == null) {
                await _orderProduct(
                  context,
                  value,
                  discount,
                  state.variantEntity!,
                  id,
                );
                return;
              }
              // Save to cart
              final List<String>? carts =
                  AppSharedPreference.instance.getStringList(PrefKeys.cart);
              final listCart = carts
                      ?.map((item) => CartEntity.fromJson(json.decode(item)))
                      .toList() ??
                  [];
              final cart = CartEntity(
                quantity: value,
                discount: discount,
                variant: state.variantEntity!,
              );
              cartCubit?.addToCart.call(cart);
            },
          ),
        );
      },
    );
  }

//mua hàng
  Future<void> _orderProduct(
    BuildContext context,
    int quantity,
    int discount,
    VariantEntity variant,
    int? id,
  ) async {
    DialogUtils.showLoadingDialog(
      context,
      content: 'Đang tiến hành đặt hàng, vui lòng đợi!',
    );
    final res = await _orderCreateUseCase.execute(
      OrderCreateInput(
        orderImportCreateEntity: OrderImportCreateEntity(
          order: OrderImportInfoCreate(
            discount:
                ((variant.priceSellDefault - variant.priceSell) * quantity)
                    .toString(),
            total: (variant.priceSellDefault * quantity).toString(),
          ),
          orderitem: [
            Orderitem(
              variant: variant.id,
              price: variant.priceSell.toInt(),
              quantity: quantity,
              discount: discount,
              promotion: variant.promotion?.promotion,
            ),
          ],
        ),
      ),
    );
    if (context.mounted) {
      Navigator.of(context).pop();
    }
    getProductPatternDetail(id ?? 0);

    if (res.response.code == 200 && context.mounted) {
      //chi tiết đơn
      DialogUtils.showSuccessDialog(
        context,
        content: 'Tạo đơn hàng thành công',
        titleConfirm: 'Chi tiết đơn',
        titleClose: 'Danh sách đơn',
        accept: () {
          Navigator.pop(context);
          context.router.push(const OrderImportRoute());
          context.router.push(
            OrderDetailRoute(
              order: res.response.data!.id,
              typeOrder: TypeOrder.ad,
            ),
          );
        },
        close: () {
          Navigator.pop(context);
          context.router.push(const OrderImportRoute());
        },
      );
    } else {
      DialogUtils.showErrorDialog(
        context,
        content: 'Đang hàng thất bại, vui lòng kiểm tra tồn kho',
      );
    }
  }
}
