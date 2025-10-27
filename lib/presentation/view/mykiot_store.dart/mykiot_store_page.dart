import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_click/domain/entity/variant_entity.dart';
import 'package:one_click/presentation/base/bottom_bar.dart';
import 'package:one_click/presentation/di/di.dart';
import 'package:one_click/presentation/routers/router.gr.dart';
import 'package:one_click/presentation/shared_view/shimmer/product_mykiot_shimmer.dart';
import 'package:one_click/presentation/shared_view/shimmer/product_promotion_shimmer.dart';
import 'package:one_click/presentation/shared_view/widget/appbar_with_shopping_cart.dart';
import 'package:one_click/presentation/shared_view/widget/cache_image.dart';
import 'package:one_click/presentation/shared_view/widget/empty.dart';
import 'package:one_click/presentation/view/mykiot_store.dart/widgets/variant_card.dart';
import 'package:one_click/presentation/view/mykiot_store.dart/widgets/variant_promo_card.dart';
import 'package:one_click/shared/utils/dismiss_keyboard.dart';
import 'package:one_click/shared/utils/event.dart';

import '../shopping_cart/cubit/shopping_cart_cubit.dart';
import 'cubit/mykiot_store_cubit.dart';
import 'cubit/mykiot_store_state.dart';

@RoutePage()
class MykiotStorePage extends StatefulWidget {
  const MykiotStorePage({super.key});

  @override
  State<MykiotStorePage> createState() => _MykiotStorePageState();
}

class _MykiotStorePageState extends State<MykiotStorePage> {
  final myBloc = getIt.get<MykiotStoreCubit>();
  final cartCubit = getIt.get<ShoppingCartCubit>();

  @override
  void initState() {
    super.initState();

    cartCubit.getListProduct();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MykiotStoreCubit>(
          create: (context) => myBloc..init(),
        ),
        BlocProvider<ShoppingCartCubit>(
          create: (context) => cartCubit..getListProduct(),
        ),
      ],
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => AppUtils.dissmissKeyboard(),
        child: Scaffold(
          backgroundColor: bg_4,
          appBar: AppBarWithShoppingCart(
            mybloc: cartCubit,
          ),
          body: Container(
            height: heightDevice(context),
            width: widthDevice(context),
            padding:
                const EdgeInsets.symmetric(vertical: sp24, horizontal: sp16)
                    .copyWith(bottom: 0),
            child: BlocBuilder<MykiotStoreCubit, MykiotStoreState>(
              builder: (context, state) {
                return FSBar<VariantEntity>(
                  hint: 'Tìm kiếm',
                  floatingSearchBarController:
                      myBloc.floatingSearchBarController,
                  list: state.listSearch,
                  goTo: () => null,
                  onSubmitted: (value) =>
                      myBloc.getVariantsSearch(searchKey: value),
                  itemBuilder: (context, item, index) {
                    return GestureDetector(
                      onTap: () => context.router.push(
                        VariantDetailMykiot(id: item.id, cartCubit: cartCubit),
                      ),
                      child: ListTile(
                        leading: BaseCacheImage(
                          url: item.image,
                          width: sp48,
                          height: sp48,
                        ),
                        title: Text(item.title),
                        subtitle: Text(
                          '${FormatCurrency(item.priceSell)}đ',
                          style: p5.copyWith(color: mainColor),
                        ),
                      ),
                    );
                  },
                  body: bodyBuild(),
                  shrinkWrap: true,
                  progress: state.isLoadingSearch,
                  onFocusChanged: (focus) {
                    if (!focus) {
                      myBloc.clearDataSearch();
                    }
                  },
                );
              },
            ),
          ),
          bottomNavigationBar:
              const BuildBottomBar(pageCode: TabCode.storeOnline),
        ),
      ),
    );
    // BlocProvider<MykiotStoreCubit>(
    //   create: (context) => myBloc..init(),
    //   child: Scaffold(
    //     backgroundColor: bg_4,
    //     appBar: const AppBarWithShoppingCart(),
    //     body: Container(
    //       height: heightDevice(context),
    //       width: widthDevice(context),
    //       padding: const EdgeInsets.symmetric(vertical: sp24, horizontal: sp16).copyWith(bottom: 0),
    //       child: BlocBuilder<MykiotStoreCubit, MykiotStoreState>(
    //         builder: (context, state) {
    //           return FSBar<VariantEntity>(
    //             hint: 'Tìm kiếm',
    //             floatingSearchBarController: myBloc.floatingSearchBarController,
    //             list: state.listSearch,
    //             goTo: () => null,
    //             onSubmitted: (value) => myBloc.getVariantsSearch(searchKey: value),
    //             itemBuilder: (context, item, index) {
    //               return GestureDetector(
    //                 onTap: () => context.router.push(VariantDetailMykiot(id: item.id)),
    //                 child: ListTile(
    //                   leading: BaseCacheImage(
    //                     url: item.image,
    //                     width: sp48,
    //                     height: sp48,
    //                   ),
    //                   title: Text(item.title),
    //                   subtitle: Text(
    //                     '${FormatCurrency(item.priceSell)}đ',
    //                     style: p5.copyWith(color: mainColor),
    //                   ),
    //                 ),
    //               );
    //             },
    //             body: bodyBuild(),
    //             shrinkWrap: true,
    //             progress: state.isLoadingSearch,
    //             onFocusChanged: (focus) {
    //               if (!focus) {
    //                 myBloc.clearDataSearch();
    //               }
    //             },
    //           );
    //         },
    //       ),
    //     ),
    //     bottomNavigationBar: const BuildBottomBar(pageCode: TabCode.storeOnline),
    //   ),
    // );
  }

  Widget bodyBuild() {
    return SingleChildScrollView(
      controller: myBloc.scrollController,
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: sp16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sản phẩm ưu đãi',
                style: p1.copyWith(color: blackColor),
              ),
              GestureDetector(
                onTap: () => context.router.push(
                  MykiotVariantPromotionRoute(
                    mykiotStoreCubit: myBloc,
                    cartCubit: cartCubit,
                  ),
                ),
                child: Text(
                  'Xem tất cả',
                  style: p5.copyWith(color: blue_1),
                ),
              ),
            ],
          ),
          const SizedBox(height: sp16),
          BlocBuilder<MykiotStoreCubit, MykiotStoreState>(
            builder: (context, state) {
              return !state.isLoadingProductPromotion &&
                      state.listVariantPromotion.isEmpty
                  ? const EmptyContainer()
                  : SizedBox(
                      width: widthDevice(context),
                      height: 295,
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          late VariantEntity variant;
                          if (!state.isLoadingProductPromotion) {
                            variant = state.listVariantPromotion[index];
                          }
                          return state.isLoadingProductPromotion
                              ? const ProductPromotionShimmer()
                              : GestureDetector(
                                  onTap: () => context.router.push(
                                    VariantDetailMykiot(
                                      id: variant.id,
                                      cartCubit: cartCubit,
                                    ),
                                  ),
                                  child: VariantPromoCard(variant: variant),
                                );
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: sp16),
                        itemCount: state.isLoadingProductPromotion
                            ? 2
                            : state.listVariantPromotion.length,
                      ),
                    );
            },
          ),
          const SizedBox(height: sp24),
          // Text(
          //   'Sản phẩm',
          //   style: p1.copyWith(color: blackColor),
          // ),
          // const SizedBox(height: sp16),
          // BlocBuilder<MykiotStoreCubit, MykiotStoreState>(
          //   builder: (context, state) {
          //     return Visibility(
          //       visible: !state.isLoadingProduct || state.listVariants.isNotEmpty,
          //       child: GridView.builder(
          //         shrinkWrap: true,
          //         physics: const NeverScrollableScrollPhysics(),
          //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //           crossAxisCount: 2,
          //           mainAxisSpacing: sp16,
          //           crossAxisSpacing: sp16,
          //           mainAxisExtent: 250,
          //         ),
          //         itemBuilder: (context, index) {
          //           final VariantEntity variant = state.listVariants[index];
          //           return GestureDetector(
          //             onTap: () => context.router.push(
          //               VariantDetailMykiot(
          //                 id: variant.id,
          //                 cartCubit: cartCubit,
          //               ),
          //             ),
          //             child: VariantMykiotCard(
          //               variant: variant,
          //             ),
          //           );
          //         },
          //         itemCount: state.listVariants.length,
          //       ),
          //     );
          //   },
          // ),
          // BlocBuilder<MykiotStoreCubit, MykiotStoreState>(
          //   builder: (context, state) {
          //     return Visibility(
          //       visible: state.isLoadingProduct,
          //       child: Column(
          //         children: [
          //           const SizedBox(height: sp16),
          //           GridView.builder(
          //             shrinkWrap: true,
          //             physics: const NeverScrollableScrollPhysics(),
          //             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //               crossAxisCount: 2,
          //               mainAxisSpacing: sp16,
          //               crossAxisSpacing: sp16,
          //               childAspectRatio: 1,
          //             ),
          //             itemBuilder: (context, index) {
          //               return const ProductMykiotShimmer();
          //             },
          //             itemCount: 4,
          //           ),
          //         ],
          //       ),
          //     );
          //   },
          // ),
        ],
      ),
    );
  }
}
