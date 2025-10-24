import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_click/domain/entity/product_detail_entity.dart';
import 'package:one_click/domain/entity/variant_create_order.dart';
import 'package:one_click/presentation/di/di.dart';
import 'package:one_click/presentation/routers/router.gr.dart';
import 'package:one_click/presentation/shared_view/card/variant_create_order_card.dart';
import 'package:one_click/presentation/shared_view/widget/bar_code_scan.dart';
import 'package:one_click/presentation/view/order_create/cubit/order_create_cubit.dart';
import 'package:one_click/presentation/view/order_create/cubit/order_create_state.dart';
import 'package:one_click/presentation/view/product_create/cubit/product_create_cubit.dart';
import 'package:one_click/presentation/view/product_create/cubit/product_create_state.dart';
import 'package:one_click/presentation/view/product_create/product_create_page.dart';
import 'package:one_click/presentation/view/product_manager/child/product/cubit/product_cubit.dart';
import 'package:one_click/presentation/view/qr/qr_barcode_prd.dart';
import 'package:one_click/shared/constants/pref_keys.dart';
import 'package:one_click/shared/ext/index.dart';

class QrBottomCreateprd extends StatefulWidget {
  const QrBottomCreateprd({
    super.key,
  });
  @override
  State<QrBottomCreateprd> createState() => _QrBottomCreateprdState();
}

class _QrBottomCreateprdState extends State<QrBottomCreateprd> {
  bool isExpanded = false;
  final myBloc = getIt.get<ProductCreateCubit>();
  final myBlocProduct = getIt.get<ProductCubit>();
  final TextEditingController barcodeTec = TextEditingController();
  final FocusNode fn = FocusNode();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        setState(() {
          if (details.delta.dy < 0) {
            // Nếu người dùng vuốt lên
            isExpanded = true;
          } else if (details.delta.dy > 0) {
            // Nếu người dùng vuốt xuống
            isExpanded = false;
          }
        });
      },
      child: BlocProvider(
        create: (context) => myBlocProduct,
        child: Container(
          height: heightDevice(context) - 150 - 22,
          width: widthDevice(context),
          child: Stack(
            children: [
              // const QRViewExample(),
              isExpanded
                  ? Container(
                      height: 300,
                      width: widthDevice(context),
                      color: blackColor,
                    )
                  : QrBarcodePrd(
                      productCreateCubit: myBloc,
                    ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: isExpanded
                      ? MediaQuery.of(context).size.height * 0.65
                      : MediaQuery.of(context).size.height - 150 - 300,
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: sp16),
                        child: Container(
                          color: whiteColor,
                          child: BlocBuilder<ProductCreateCubit,
                              ProductCreateState>(
                            bloc: myBloc,
                            builder: (context, state) {
                              if (barcodeTec.text.isEmpty &&
                                  state.barCode.isNotEmpty) {
                                barcodeTec.text = state.barCode;
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  fn.requestFocus();
                                });
                              }
                              final listProductScan = state.listProductScan;
                              return listProductScan.isNotEmpty
                                  ? ListView.separated(
                                      itemBuilder: (context, index) {
                                        final product = listProductScan[index];
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              'Mã vạch: ${product.barcode}',
                                              style: p5.copyWith(
                                                  color: blackColor),
                                            ),
                                            const SizedBox(height: sp16),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 56,
                                                        height: 56,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      sp8),
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl: product
                                                                    .images
                                                                    .isNotEmpty
                                                                ? product
                                                                    .images[0]
                                                                : PrefKeys
                                                                    .imgProductDefault,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          width: sp16),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              product.title,
                                                              style: p3.copyWith(
                                                                  color:
                                                                      blackColor),
                                                            ),
                                                            const SizedBox(
                                                                height: sp12),
                                                            Text(
                                                              product.code,
                                                              style: p4.copyWith(
                                                                  color:
                                                                      greyColor),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          width: sp16),
                                                      MainButton(
                                                        title: 'Chọn',
                                                        event: () {
                                                          context.router.push(
                                                            ProductCreateRoute(
                                                              productDetailEntity:
                                                                  product,
                                                              callPreviousPage: () =>
                                                                  myBlocProduct
                                                                      .variantListController
                                                                      .onRefresh(),
                                                            ),
                                                          );
                                                        },
                                                        largeButton: true,
                                                        icon: null,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 24),
                                            SizedBox(
                                              width: widthDevice(context),
                                              child: Extrabutton(
                                                title: 'Chỉ nhập mã vạch',
                                                event: () =>
                                                    context.router.push(
                                                  ProductCreateRoute(
                                                    productDetailEntity:
                                                        ProductDetailEntity(
                                                            barcode: product
                                                                .barcode),
                                                    callPreviousPage: () =>
                                                        myBlocProduct
                                                            .variantListController
                                                            .onRefresh(),
                                                  ),
                                                ),
                                                largeButton: true,
                                                borderColor: borderColor_2,
                                                icon: null,
                                              ),
                                            ),
                                          ],
                                        ).padding(16.pading);
                                      },
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(
                                        height: sp16,
                                      ),
                                      itemCount: listProductScan.length,
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: sp16),
                                      child: Column(
                                        children: [
                                          const SizedBox(height: sp16),
                                          Text(
                                            'Mã vạch',
                                            style:
                                                p3.copyWith(color: blackColor),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: sp16),
                                          AppInput(
                                            controller: barcodeTec,
                                            hintText: 'Nhập mã vạch',
                                            textInputType: TextInputType.name,
                                            validate: (value) {},
                                            backgroundColor: whiteColor,
                                            fn: fn,
                                          ),
                                          const SizedBox(height: sp24),
                                          SizedBox(
                                            width: double.infinity,
                                            child: MainButton(
                                              title: 'Thêm sản phẩm',
                                              event: () {
                                                context.router.push(
                                                  ProductCreateRoute(
                                                    productDetailEntity:
                                                        ProductDetailEntity(
                                                            barcode: barcodeTec
                                                                .text),
                                                    callPreviousPage: () =>
                                                        myBlocProduct
                                                            .variantListController
                                                            .onRefresh(),
                                                  ),
                                                );
                                                barcodeTec.clear();
                                              },
                                              largeButton: true,
                                              icon: null,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            width: 36,
                            height: sp4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(sp4),
                              color: whiteColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
