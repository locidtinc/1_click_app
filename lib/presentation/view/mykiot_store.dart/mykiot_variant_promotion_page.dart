import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_click/presentation/shared_view/widget/appbar_with_shopping_cart.dart';
import 'package:one_click/presentation/view/mykiot_store.dart/widgets/variant_promo_card.dart';

import '../../../domain/entity/variant_entity.dart';
import '../../base/app_bar.dart';
import '../../base/bottom_bar.dart';
import '../../routers/router.gr.dart';
import '../../shared_view/shimmer/product_mykiot_shimmer.dart';
import '../shopping_cart/cubit/shopping_cart_cubit.dart';
import 'cubit/cart_cubit.dart';
import 'cubit/mykiot_store_cubit.dart';
import 'cubit/mykiot_store_state.dart';

@RoutePage()
class MykiotVariantPromotionPage extends StatefulWidget {
  const MykiotVariantPromotionPage({
    super.key,
    required this.mykiotStoreCubit,
    this.cartCubit,
  });

  final MykiotStoreCubit mykiotStoreCubit;
  final ShoppingCartCubit? cartCubit;

  @override
  State<MykiotVariantPromotionPage> createState() =>
      _MykiotVariantPromotionPageState();
}

class _MykiotVariantPromotionPageState
    extends State<MykiotVariantPromotionPage> {
  @override
  void dispose() {
    super.dispose();

    widget.mykiotStoreCubit.onFieldChange(keySearchPromotion: '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg_4,
      appBar: AppBarWithShoppingCart(
        mybloc: widget.cartCubit,
      ),
      body: Container(
        height: heightDevice(context),
        width: widthDevice(context),
        padding: const EdgeInsets.symmetric(vertical: sp24, horizontal: sp16)
            .copyWith(bottom: 0),
        child: SingleChildScrollView(
          controller: widget.mykiotStoreCubit.scPagePromotion,
          child: Column(
            children: [
              AppInput(
                hintText: 'Tìm kiếm',
                validate: (value) {},
                backgroundColor: whiteColor,
                prefixIcon: const Icon(
                  Icons.search,
                  size: sp20,
                  color: greyColor,
                ),
                onChanged: (value) =>
                    widget.mykiotStoreCubit.onSearchPromotion(value),
              ),
              const SizedBox(height: sp24),
              BlocBuilder<MykiotStoreCubit, MykiotStoreState>(
                bloc: widget.mykiotStoreCubit,
                builder: (context, state) {
                  return Visibility(
                    visible: !state.isLoadingProductPromotion &&
                        (state.listVariantPromotion.isNotEmpty ||
                            state.listVariantPromotionSearch.isNotEmpty),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: sp16,
                        crossAxisSpacing: sp16,
                        childAspectRatio: 0.55,
                      ),
                      itemBuilder: (context, index) {
                        final VariantEntity variant =
                            state.keySearchPromotion.isEmpty
                                ? state.listVariantPromotion[index]
                                : state.listVariantPromotionSearch[index];
                        // return VariantMykiotCard(variant: variant);
                        return GestureDetector(
                          onTap: () => context.router.push(VariantDetailMykiot(
                              id: variant.id, cartCubit: widget.cartCubit)),
                          child: VariantPromoCard(
                            variant: variant,
                          ),
                        );
                      },
                      itemCount: state.keySearchPromotion.isEmpty
                          ? state.listVariantPromotion.length
                          : state.listVariantPromotionSearch.length,
                    ),
                  );
                },
              ),
              BlocBuilder<MykiotStoreCubit, MykiotStoreState>(
                bloc: widget.mykiotStoreCubit,
                builder: (context, state) {
                  return Visibility(
                    visible: state.isLoadingProductPromotion,
                    child: Column(
                      children: [
                        const SizedBox(height: sp16),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: sp16,
                            crossAxisSpacing: sp16,
                            childAspectRatio: 1,
                          ),
                          itemBuilder: (context, index) {
                            return const ProductMykiotShimmer();
                          },
                          itemCount: 4,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BuildBottomBar(pageCode: TabCode.storeOnline),
    );
  }
}
