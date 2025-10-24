import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_click/domain/entity/variant_entity.dart';
import 'package:one_click/presentation/base/app_bar.dart';
import 'package:one_click/presentation/base/card_base.dart';
import 'package:one_click/presentation/di/di.dart';
import 'package:one_click/presentation/routers/router.gr.dart';
import 'package:one_click/presentation/shared_view/widget/cache_image.dart';
import 'package:one_click/presentation/view/product_manager/child/product/cubit/product_cubit.dart';
import 'package:one_click/presentation/view/product_manager/child/product/cubit/product_state.dart';
import 'package:one_click/presentation/view/store_information/widgets/store_general_info_widget.dart';
import 'package:one_click/shared/ext/index.dart';
import 'package:one_click/shared/utils/event.dart';

@RoutePage()
class ProductDetailManagerPage extends StatefulWidget {
  const ProductDetailManagerPage({
    super.key,
    required this.id,
  });

  final int id;

  @override
  State<ProductDetailManagerPage> createState() =>
      _ProductDetailManagerPageState();
}

class _ProductDetailManagerPageState extends State<ProductDetailManagerPage> {
  // final myBloc = getIt.get<ProductDetailManagerPageCubit>();
  final myBloc = getIt.get<ProductCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductCubit>(
      create: (context) => myBloc..getVariantDetailManager(widget.id),
      child: Scaffold(
        appBar: const BaseAppBar(
          title: 'Chi tiết sản phẩm',
          actions: [],
        ),
        body: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            if (myBloc.isLoading) {
              return const BaseLoading();
            }
            // num discount=0;
            // if (state.variantEntity.promotion) {
            // }
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CardBase(
                          margin: const EdgeInsets.symmetric(horizontal: sp16) +
                              const EdgeInsets.only(top: sp24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AspectRatio(
                                aspectRatio: 1,
                                // width: double.infinity,
                                // height:
                                //     MediaQuery.of(context).size.height * 0.2,
                                // decoration: BoxDecoration(
                                //   border: Border.all(color: borderColor_1),
                                //   borderRadius: BorderRadius.circular(8),
                                // ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: BaseCacheImage(
                                    url: state.variantEntity!.image,
                                  ),
                                ),
                              ),
                              if (state.variantEntity!.promotion != null)
                                Container(
                                  margin: const EdgeInsets.only(top: sp16),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: sp8,
                                    horizontal: sp12,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(sp8),
                                    color: yellow_1,
                                  ),
                                  child: Text(
                                    '-${state.variantEntity?.promotion?.typeDiscount == 2 ? '${state.variantEntity?.promotion?.discount.round()}%' : '${FormatCurrency((state.variantEntity?.priceSellDefault ?? 0) - (state.variantEntity?.priceSell ?? 0))}đ'}',
                                    style: p8.copyWith(color: whiteColor),
                                  ),
                                ),
                              const SizedBox(height: 16),
                              Text(state.variantEntity!.title, style: p1),
                              const SizedBox(height: 8),
                              Text(
                                state.variantEntity!.code,
                                style: p3.copyWith(color: borderColor_4),
                              ),
                              const SizedBox(height: 16),
                              const Divider(
                                height: 1,
                                thickness: 1,
                                color: borderColor_2,
                              ),
                              const SizedBox(height: 16),
                              _priceSell(state.variantEntity),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        CardBase(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Thông tin sản phẩm',
                                style: p1,
                              ),
                              const SizedBox(height: sp16),
                              ItemRow(
                                title: 'Thương hiệu',
                                value: state.variantEntity!.productData.brand,
                                titleStyle: p4.copyWith(color: borderColor_4),
                              ),
                              ItemRow(
                                title: 'Ngành hàng',
                                value:
                                    state.variantEntity!.productData.category,
                                titleStyle: p4.copyWith(color: borderColor_4),
                              ),
                              ItemRow(
                                title: 'Nhóm sản phẩm',
                                value: state.variantEntity!.productData.group,
                                titleStyle: p4.copyWith(color: borderColor_4),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: MainButton(
                                title: 'Xóa sản phẩm này',
                                event: () {},
                                largeButton: true,
                                icon: null,
                              ).padding(24.pading),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        bottomNavigationBar: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            // final bloc = context.read<VariantDetailMykiotCubit>();
            return Container(
              padding: const EdgeInsets.all(sp16),
              color: whiteColor,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Extrabutton(
                      title: 'Chỉnh sửa',
                      event: () {
                        context.router.push(
                          ProductDetailRoute(
                            productId: state.variantEntity!.id,
                          ),
                          // ProductEditRoute(
                          //   productDetailEntity: state.productDetailEntity!,
                          //   onConfirm: () => myBloc.loadData(productId),
                          // ),
                        );
                      },
                      largeButton: true,
                      icon: null,
                      borderColor: null,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _priceSell(VariantEntity? variantEntity) {
    return variantEntity?.promotion != null
        ? Column(
            children: [
              ItemRow(
                title: 'Ưu đãi còn lại',
                value: '${variantEntity?.promotion?.quantity} sản phẩm',
                titleStyle: p4.copyWith(color: borderColor_4),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Giá bán',
                    style: p6,
                  ),
                  RichText(
                    text: TextSpan(
                      text:
                          '${FormatCurrency(variantEntity!.priceSellDefault)}đ ',
                      style: p6.copyWith(
                        color: borderColor_4,
                        decoration: TextDecoration.lineThrough,
                      ),
                      children: [
                        TextSpan(
                          text: ' ${FormatCurrency(variantEntity.priceSell)}đ',
                          style: p5.copyWith(
                            color: mainColor,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          )
        : Column(
            children: [
              ItemRow(
                title: 'Mã vạch',
                value: variantEntity!.barCode,
                titleStyle: p4.copyWith(color: borderColor_4),
              ),
              ItemRow(
                title: 'Giá bán',
                value: '${FormatCurrency(variantEntity.priceSell)}đ',
                titleStyle: p4.copyWith(color: borderColor_4),
              ),
            ],
          );
  }
}
