import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:one_click/domain/entity/product_detail_entity.dart';
import 'package:one_click/domain/entity/product_preview.dart';
import 'package:one_click/domain/entity/variant_entity.dart';
import 'package:one_click/presentation/di/di.dart';
import 'package:one_click/presentation/routers/router.gr.dart';
import 'package:one_click/presentation/shared_view/card/product_preview_card.dart';
import 'package:one_click/presentation/shared_view/card/variant_preview.dart';
import 'package:one_click/presentation/shared_view/widget/empty.dart';
import 'package:one_click/presentation/view/product_manager/child/product/cubit/product_cubit.dart';
import 'package:one_click/presentation/view/product_manager/child/product/cubit/product_state.dart';
import 'package:one_click/shared/ext/index.dart';

class ProductView extends StatefulWidget {
  const ProductView({super.key});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  final myBloc = getIt.get<ProductCubit>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductCubit>(
      create: (context) => myBloc,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: sp24, horizontal: sp16)
            .copyWith(bottom: 0),
        height: heightDevice(context),
        width: widthDevice(context),
        child: RefreshIndicator(
          onRefresh: () async {
            myBloc.variantListController.onRefresh();
          },
          child: SingleChildScrollView(
            controller: myBloc.scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: MainButton(
                    title: 'Tạo sản phẩm',
                    event: () {
                      context.router.push(
                        ProductCreateRoute(
                          callPreviousPage: () =>
                              myBloc.variantListController.onRefresh(),
                        ),
                      );
                    },
                    largeButton: true,
                    icon: null,
                  ),
                ),
                const SizedBox(height: sp24),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: AppInput(
                        hintText: 'Nhập tên sản phẩm, barcode,...',
                        validate: (value) {},
                        backgroundColor: whiteColor,
                        onChanged: (value) => myBloc.searchKeyChange(value),
                      ),
                    ),
                    const SizedBox(width: sp16),
                    GestureDetector(
                      onTap: () => context.router
                          .push(ProductFilterRoute(productCubit: myBloc)),
                      child: Container(
                        width: sp48,
                        height: sp48,
                        decoration: BoxDecoration(
                          border: Border.all(color: borderColor_2),
                          borderRadius: BorderRadius.circular(sp8),
                          color: whiteColor,
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            '${AssetsPath.icon}/ic_filter.svg',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: sp24),
                SizedBox(
                  width: double.infinity,
                  child: Extrabutton(
                    title: 'Quét mã vạch',
                    event: () => context.router.push(
                      ProductBarCodeScanRoute(
                        onScanEvent: (String? barcode) => scanBarcode(barcode),
                      ),
                    ),
                    largeButton: true,
                    icon:
                        SvgPicture.asset('${AssetsPath.icon}/ic_scan_btn.svg'),
                    bgColor: whiteColor,
                    borderColor: borderColor_2,
                  ),
                ),
                const SizedBox(height: sp24),
                // BlocBuilder<ProductCubit, ProductState>(
                //   builder: (context, state) {
                //     return InfiniteList<ProductPreviewEntity>(
                //       shrinkWrap: true,
                //       getData: (page) {
                //         return myBloc.getListProductPreview(page);
                //       },
                //       itemBuilder: (context, item, index) {
                //         return ProductPreviewCard(
                //           item: item,
                //           onTapItem: () => context.read<ProductCubit>().onTapItem(context, item),
                //         );
                //       },
                //       scrollController: myBloc.scrollController,
                //       infiniteListController: myBloc.infiniteListController,
                //       //state.infiniteListController!,
                //       circularProgressIndicator: const BaseLoading(),
                //       noItemFoundWidget: const EmptyContainer(),
                //     );
                //   },
                // ),
                BlocBuilder<ProductCubit, ProductState>(
                  builder: (context, state) {
                    return Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Danh sách sản phẩm',
                            style: h6.copyWith(color: greyColor),
                          ),
                        ),
                        Text(
                          '${state.count} (mẫu mã)',
                          style: p7.copyWith(color: greyColor),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: sp16),

                BlocBuilder<ProductCubit, ProductState>(
                  builder: (context, state) {
                    return InfiniteList<VariantEntity>(
                      pageSize: state.limit,
                      shrinkWrap: true,
                      getData: (page) => myBloc.getListVariant(page),
                      itemBuilder: (context, item, index) {
                        return ProductPreviewCard(
                          itemVariant: item,
                          check: item.variantMykios,
                          itemPrd: item.productData,
                          onTapItem: () => context
                              .read<ProductCubit>()
                              .onTapPrdItem(
                                context,
                                item,
                                onConfirm: () =>
                                    myBloc.variantListController.onRefresh(),
                              ),
                        );
                      },
                      scrollController: myBloc.scrollController,
                      infiniteListController: myBloc.variantListController,
                      circularProgressIndicator: const BaseLoading(),
                      noItemFoundWidget: const EmptyContainer(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> scanBarcode(String? barcode) async {
    context.router.popUntil(
      (route) => route.settings.name == 'ProductManagerRoute',
    );
    final proudct = await myBloc.getProductByQrcode(barcode);
    if (proudct != null && context.mounted) {
      context.router.push(ProductDetailRoute(productId: proudct.id!));
    } else {
      //   DialogUtils.showErrorDialog(
      //     context,
      //     content: 'Không tim thấy sản phẩm phù hợp',
      //   );
      // }

      context.router.push(
        ProductCreateRoute(
          productDetailEntity: ProductDetailEntity(barcode: barcode ?? ''),
          callPreviousPage: () => myBloc.variantListController.onRefresh(),
        ),
      );
    }
  }
}
