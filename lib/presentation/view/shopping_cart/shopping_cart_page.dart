import 'package:auto_route/annotations.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:one_click/presentation/base/app_bar.dart';
import 'package:one_click/presentation/view/shopping_cart/cubit/shopping_cart_cubit.dart';
import 'package:one_click/presentation/view/shopping_cart/cubit/shopping_cart_state.dart';
import 'package:one_click/presentation/view/shopping_cart/cubit/widget/count_widget.dart';
import 'package:one_click/shared/button/base_check_box_v2.dart';
import 'package:one_click/shared/utils/event.dart';

@RoutePage()
class ShoppingCartPage extends StatelessWidget {
  const ShoppingCartPage({super.key, this.myBloc});

  final ShoppingCartCubit? myBloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShoppingCartCubit, ShoppingCartState>(
      bloc: myBloc,
      builder: (context, state) {
        return Scaffold(
          appBar: BaseAppBar(
            title: state.listCart.isNotEmpty
                ? 'Giỏ hàng (${state.listCart.length})'
                : 'Giỏ hàng',
          ),
          backgroundColor: bg_4,
          body: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: sp12),
                  child: ListView.builder(
                    itemCount: state.listCart.length,
                    itemBuilder: (context, index) {
                      final cart = state.listCart[index];
                      return Container(
                        padding: const EdgeInsets.all(sp16),
                        margin: const EdgeInsets.symmetric(vertical: sp4),
                        color: whiteColor,
                        child: Column(
                          children: [
                            _infoVariant(index),
                            const SizedBox(height: sp16),
                            CountWidget(
                              quantity: cart.quantity,
                              remaining: cart.variant.promotion?.quantity ?? 0,
                              onTapReduced: (quantity) =>
                                  myBloc?.onTapReduced(quantity, index),
                              onTapIncremented: (quantity) =>
                                  myBloc?.onTapIncremented(quantity, index),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              Container(
                color: whiteColor,
                padding: const EdgeInsets.all(sp16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            child: Row(
                              children: [
                                BaseCheckboxV2(
                                  value: state.listCart.isEmpty
                                      ? false
                                      : state.checkAll,
                                  checkColor: mainColor,
                                  fillColor: borderColor_1,
                                  onChanged: (value) =>
                                      myBloc?.onTapCheckAll.call(value),
                                ),
                                const SizedBox(width: sp8),
                                const Text('Chọn tất cả', style: p4),
                              ],
                            ),
                          ),
                        ),
                        Text(
                          '${FormatCurrency(state.total)}đ',
                          style: p3.copyWith(color: mainColor),
                        ),
                      ],
                    ),
                    const SizedBox(height: sp24),
                    SizedBox(
                      width: double.infinity,
                      child: MainButton(
                        title: 'Tạo đơn đặt hàng',
                        event: () => myBloc?.orderProduct(context),
                        largeButton: true,
                        icon: null,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _infoVariant(int index) {
    return BlocBuilder<ShoppingCartCubit, ShoppingCartState>(
      bloc: myBloc,
      builder: (context, state) {
        return Row(
          children: [
            BaseCheckboxV2(
              value: state.listCart[index].chose,
              fillColor: borderColor_1,
              checkColor: mainColor,
              onChanged: (value) => myBloc?.onChangeCheckbox(value, index),
            ),
            Container(
              width: 80,
              height: 80,
              margin: const EdgeInsets.symmetric(horizontal: sp16),
              decoration: BoxDecoration(
                border: Border.all(color: borderColor_1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  progressIndicatorBuilder: (context, url, progress) {
                    return Center(
                      child: CircularProgressIndicator(
                        value: progress.progress,
                      ),
                    );
                  },
                  fit: BoxFit.contain,
                  imageUrl: state.listCart[index].variant.image,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    state.listCart[index].variant.title,
                    style: p5,
                  ),
                  const SizedBox(height: sp8),
                  Text(
                    state.listCart[index].variant.code,
                    style: p5.copyWith(color: borderColor_4),
                  ),
                  const SizedBox(height: sp8),
                  Row(
                    children: [
                      if (state.listCart[index].variant.promotion != null)
                        Text(
                          '${FormatCurrency(state.listCart[index].variant.priceSellDefault)}đ',
                          style: p6.copyWith(
                            color: borderColor_3,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      if (state.listCart[index].variant.promotion != null)
                        const SizedBox(width: sp8),
                      Text(
                        state.listCart[index].variant.promotion != null
                            ? '${FormatCurrency(state.listCart[index].variant.priceSell)}đ'
                            : '${FormatCurrency(
                                state.listCart[index].variant.priceSell,
                              )}đ',
                        style: p3.copyWith(
                          color: mainColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: sp16),
            GestureDetector(
              onTap: () => myBloc?.deleteVariant(index),
              child: SvgPicture.asset(
                '${AssetsPath.icon}/ic_trash.svg',
                color: blackColor,
                width: sp16,
              ),
            ),
          ],
        );
      },
    );
  }
}
