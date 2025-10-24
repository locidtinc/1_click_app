import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_click/presentation/base/app_bar.dart';
import 'package:one_click/presentation/di/di.dart';
import 'package:one_click/presentation/routers/router.gr.dart';
import 'package:one_click/presentation/view/product_detail/cubit/product_detail_cubit.dart';
import 'package:one_click/presentation/view/product_detail/cubit/product_detail_state.dart';
import 'package:one_click/presentation/view/product_detail/widgets/product_detail_info.dart';
import 'package:one_click/presentation/view/product_detail/widgets/product_pattern.dart';
import 'package:one_click/presentation/view/product_detail/widgets/property_product.dart';
import 'package:one_click/presentation/view/product_detail/widgets/status_product.dart';

@RoutePage()
class ProductDetailPage extends StatelessWidget {
  ProductDetailPage({Key? key, required this.productId}) : super(key: key);

  final int productId;

  final myBloc = getIt.get<ProductDetailCubit>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(title: 'Chi tiết sản phẩm'),
      backgroundColor: borderColor_1,
      body: BlocProvider<ProductDetailCubit>(
        create: (context) => myBloc..loadData(productId),
        child: BlocBuilder<ProductDetailCubit, ProductDetailState>(
          builder: (context, state) {
            final bloc = context.read<ProductDetailCubit>();
            if (bloc.isLoading) {
              return const Center(
                child: BaseLoading(),
              );
            }
            return Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await myBloc.loadData(productId);
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // if (state.productDetailEntity!.images.isNotEmpty)
                          ProductDetailInfo(
                            product: state.productDetailEntity!,
                            onPressed: bloc.onTapItemImage,
                            selectedImage: state.selectedImage,
                          ),

                          Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.symmetric(horizontal: 16) +
                                const EdgeInsets.only(bottom: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Mô tả sản phẩm',
                                  style: p4.copyWith(color: borderColor_4),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  state.productDetailEntity!.description
                                          .isNotEmpty
                                      ? state.productDetailEntity!.description
                                      : 'Không có mô tả sản phẩm',
                                  style: p4,
                                ),
                              ],
                            ),
                          ),
                          StatusProduct(product: state.productDetailEntity!),
                          PropertyProduct(product: state.productDetailEntity!),
                          ProductPattern(
                            product: state.productDetailEntity!,
                            onTapItem: (index) => context.router.push(
                              VariantDetailRoute(
                                id: state
                                    .productDetailEntity!.variant[index].id,
                                codeSystemData:
                                    state.productDetailEntity?.codeSystemData,
                                cubit: myBloc,
                              ),
                            ),
                          ),
                          if (state.productDetailEntity?.codeSystemData !=
                              'ADMIN')
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              width: double.infinity,
                              child: SupportButton(
                                title: 'Xoá sản phẩm',
                                event: () =>
                                    bloc.deleteProduct(context, productId),
                                largeButton: true,
                                icon: const SizedBox(),
                                backgroundColor: whiteColor,
                                color: mainColor,
                              ),
                            ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),
                BlocBuilder<ProductDetailCubit, ProductDetailState>(
                  builder: (context, state) {
                    return Visibility(
                      visible:
                          !(state.productDetailEntity?.isAdminCreated ?? true),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        color: whiteColor,
                        child: Extrabutton(
                          title: 'Chỉnh sửa',
                          event: () => context.router.push(
                            ProductEditRoute(
                              productDetailEntity: state.productDetailEntity!,
                              onConfirm: () => myBloc.loadData(productId),
                            ),
                          ),
                          largeButton: true,
                          icon: const SizedBox(),
                          borderColor: borderColor_2,
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
