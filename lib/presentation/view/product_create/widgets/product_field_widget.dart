import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:one_click/presentation/base/overlay_input.dart';
import 'package:one_click/presentation/config/app_style/init_app_style.dart';
import 'package:one_click/presentation/di/di.dart';
import 'package:one_click/presentation/routers/router.gr.dart';
import 'package:one_click/presentation/shared_view/widget/cache_image.dart';
import 'package:one_click/presentation/shared_view/widget/fa_icon.dart';
import 'package:one_click/presentation/view/product_manager/child/product/cubit/product_state.dart';
import 'package:one_click/shared/constants/fa_code.dart';
import 'package:one_click/shared/constants/format/number.dart';
import 'package:one_click/shared/ext/index.dart';

import '../../../../domain/entity/product_detail_entity.dart';
import '../../../../shared/utils/debounce.dart';
import '../../product_manager/child/product/cubit/product_cubit.dart';
import '../cubit/product_create_cubit.dart';
import '../cubit/product_create_state.dart';

class ProductFieldView extends StatefulWidget {
  const ProductFieldView({
    super.key,
    required this.expandableController,
    required this.priceImportTec,
    required this.priceSellTec,
    required this.productCreateCubit,
    this.onSelectProductScan,
    this.productDetailEntity,
  });

  final ExpandableController expandableController;
  final TextEditingController priceImportTec;
  final TextEditingController priceSellTec;
  final ProductCreateCubit productCreateCubit;
  final Function(ProductDetailEntity product)? onSelectProductScan;
  final ProductDetailEntity? productDetailEntity;
  @override
  State<ProductFieldView> createState() => _ProductFieldViewState();
}

class _ProductFieldViewState extends State<ProductFieldView> {
  final productBloc = getIt.get<ProductCubit>();
  late final TextEditingController productNameTec;
  late final TextEditingController barcodeTec;

  @override
  void initState() {
    super.initState();
    final product = widget.productDetailEntity;
    productNameTec = TextEditingController(text: product?.title ?? '');
    barcodeTec = TextEditingController(text: product?.barcode ?? '');
    widget.priceSellTec.text = formatPrice(product?.priceSell ?? 0);
    widget.priceImportTec.text = formatPrice(product?.priceImport ?? 0);
    productNameTec.addListener(() {
      widget.productCreateCubit.productNameChange(productNameTec.text);
    });
    if (product != null) {
      widget.productCreateCubit.selectProductScan(product);
      widget.productCreateCubit
        ..productNameChange(product.title)
        ..barCodeChange(product.barcode)
        ..priceSellChange(formatPrice(product.priceSell))
        ..priceImportChange(formatPrice(product.priceImport));
    }
  }

  @override
  void dispose() {
    productNameTec.dispose();
    barcodeTec.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ProductCreateCubit>();
    return BlocListener<ProductCreateCubit, ProductCreateState>(
      listener: (context, state) {},
      child: ExpandableNotifier(
        controller: widget.expandableController,
        child: ExpandablePanel(
          theme: const ExpandableThemeData(hasIcon: false),
          header: Container(
            padding: const EdgeInsets.all(sp16),
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.vertical(
                top: const Radius.circular(sp8),
                bottom: Radius.circular(
                  widget.expandableController.expanded ? sp0 : sp8,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Thông tin sản phẩm',
                  style: p1,
                ),
                AnimatedRotation(
                  turns: !widget.expandableController.expanded ? 0 : 0.5,
                  duration: const Duration(milliseconds: 300),
                  child: SvgPicture.asset(
                    '${AssetsPath.icon}/ic_arrow_down.svg',
                  ),
                ),
              ],
            ),
          ),
          collapsed: const SizedBox(),
          expanded: Container(
            padding: const EdgeInsets.all(sp16),
            decoration: const BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(sp8),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Nhập mã',
                    style: p5.copyWith(color: blackColor),
                  ),
                ),
                8.height,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    AppInput(
                      validate: (value) {},
                      hintText: 'Nhập mã vạch',
                      // contentPadding: 12.pading,
                      // borderRadius: 8,
                      controller: barcodeTec,
                      // lazyLoad: (isMore) => productBloc.searchPrdByBarcode(
                      //   search: barcodeTec.text,
                      //   isMore: isMore,
                      // ),
                      // itemHeight: 90,
                      // onChanged: (product) async {
                      //   DialogUtils.showLoadingDialog(
                      //     context,
                      //     content: 'Đang tải...',
                      //   );
                      //   // Nhập mã
                      //   final prd = await bloc.getProductDetailV2(product.id);
                      //   if (context.mounted && prd.id != null) {
                      //     context.pop();
                      //     productNameTec.text = prd.title;
                      //     barcodeTec.text = prd.barcode;
                      //     widget.onSelectProductScan?.call(prd);
                      //     bloc.selectProductScan(
                      //       prd,
                      //     );
                      //   }
                      // },
                      onChanged: (value) => bloc.barCodeChange(value),

                      // itemBuilder: (context, item, index) {
                      //   return Row(
                      //     children: [
                      //       BaseCacheImage(
                      //         url: item.imageUrl,
                      //         height: 50,
                      //         width: 50,
                      //       ).radius(4.radius),
                      //       12.width,
                      //       Column(
                      //         crossAxisAlignment: CrossAxisAlignment.stretch,
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           Row(
                      //             crossAxisAlignment: CrossAxisAlignment.end,
                      //             children: [
                      //               FaIcon(code: FaCode.barcodeRead, size: 12),
                      //               4.width,
                      //               Text(
                      //                 item.barcode,
                      //                 overflow: TextOverflow.ellipsis,
                      //                 style: p9.copyWith(
                      //                   color: AppColors.grey79,
                      //                 ),
                      //               ).expanded(),
                      //             ],
                      //           ),
                      //           4.height,
                      //           Text(
                      //             item.productName,
                      //             overflow: TextOverflow.ellipsis,
                      //             style: p3,
                      //           ),
                      //           4.height,
                      //           Text(
                      //             item.productPrice.toPrice(type: 'đ'),
                      //             overflow: TextOverflow.ellipsis,
                      //             style: p6,
                      //           ),
                      //         ],
                      //       ).expanded(),
                      //     ],
                      //   ).padding(12.pading);
                      // },
                    ).expanded(),
                    const SizedBox(width: sp8),
                    GestureDetector(
                      onTap: () => context.router.push(
                        ProductScanForCreate(
                          onChoseProduct: (product) {
                            setState(() {
                              productNameTec.text = product.title;
                              barcodeTec.text = product.barcode;
                            });
                            widget.onSelectProductScan?.call(product);
                            bloc.selectProductScan(product);
                          },
                          onScanEvent: (String? barcode) {
                            bloc.barCodeChange(barcode ?? '');
                            context.router.popUntil(
                              (route) =>
                                  route.settings.name == 'ProductCreateRoute',
                            );
                            setState(() {
                              barcodeTec.text = barcode ?? '';
                            });
                          },
                          productCreateCubit: widget.productCreateCubit,
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(sp16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(sp8),
                          border: Border.all(color: borderColor_2),
                        ),
                        child: SvgPicture.asset(
                          '${AssetsPath.icon}/ic_scan_btn.svg',
                        ),
                      ),
                    ),
                  ],
                ),
                // AppInput(
                //   controller: barcodeTec,
                //   label: 'Nhập mã',
                //   hintText: 'Nhập mã sản phẩm',
                //   validate: (value) {},
                //   onChanged: (value) => bloc.barCodeChange(value),
                //   textInputType: TextInputType.name,
                // ),
                const SizedBox(height: sp16),
                // AppInput(
                //   controller: productNameTec,
                //   label: 'Tên sản phẩm',
                //   required: true,
                //   hintText: 'Nhập tên sản phẩm',
                //   validate: (value) {},
                //   onChanged: (value) => bloc.productNameChange(value),
                //   textInputType: TextInputType.name,
                // ),
                RichText(
                  text: TextSpan(
                    text: 'Nhập tên sản phẩm',
                    style: p5.copyWith(color: blackColor),
                    children: [
                      TextSpan(text: ' *', style: p5.copyWith(color: red_1))
                    ],
                  ),
                ),
                8.height,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    OverlayInput(
                      hintText: 'Nhập tên sản phẩm',
                      contentPadding: 12.pading,
                      borderRadius: 8,
                      controller: productNameTec,
                      isRequired: true,
                      lazyLoad: (isMore) {
                        widget.productCreateCubit
                            .productNameChange(productNameTec.text);
                        return productBloc.searchPrd(
                          search: productNameTec.text,
                          isMore: isMore,
                        );
                      },
                      itemHeight: 90,
                      onChanged: (product) async {
                        DialogUtils.showLoadingDialog(
                          context,
                          content: 'Đang tải...',
                        );
                        // Nhập mã
                        final prd = await bloc.getProductDetailV2(product.id);
                        if (context.mounted && prd.id != null) {
                          context.pop();
                          productNameTec.text = prd.title;
                          barcodeTec.text = prd.barcode;
                          widget.onSelectProductScan?.call(prd);
                          bloc.selectProductScan(
                            prd,
                          );
                        }
                      },
                      itemBuilder: (context, item, index) {
                        return Row(
                          children: [
                            BaseCacheImage(
                              url: item.imageUrl,
                              height: 50,
                              width: 50,
                            ).radius(4.radius),
                            12.width,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    FaIcon(code: FaCode.barcodeRead, size: 12),
                                    4.width,
                                    Text(
                                      item.barcode,
                                      overflow: TextOverflow.ellipsis,
                                      style: p9.copyWith(
                                        color: AppColors.grey79,
                                      ),
                                    ).expanded(),
                                  ],
                                ),
                                4.height,
                                Text(
                                  item.productName,
                                  overflow: TextOverflow.ellipsis,
                                  style: p3,
                                ),
                              ],
                            ).expanded(),
                          ],
                        ).padding(12.pading);
                      },
                    ).expanded(),
                    // const SizedBox(width: sp8),
                    // GestureDetector(
                    //   onTap: () => context.router.push(
                    //     ProductScanForCreate(
                    //       onChoseProduct: (product) {
                    //         setState(() {
                    //           productNameTec.text = product.title;
                    //           barcodeTec.text = product.barcode;
                    //         });
                    //         widget.onSelectProductScan?.call(product);
                    //         bloc.selectProductScan(product);
                    //       },
                    //       onScanEvent: (String? barcode) {
                    //         bloc.barCodeChange(barcode ?? '');
                    //         context.router.popUntil(
                    //           (route) => route.settings.name == 'ProductCreateRoute',
                    //         );
                    //         setState(() {
                    //           barcodeTec.text = barcode ?? '';
                    //         });
                    //       },
                    //       productCreateCubit: widget.productCreateCubit,
                    //     ),
                    //   ),
                    //   child: Container(
                    //     padding: const EdgeInsets.all(sp16),
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(sp8),
                    //       border: Border.all(color: borderColor_2),
                    //     ),
                    //     child: SvgPicture.asset(
                    //       '${AssetsPath.icon}/ic_scan_btn.svg',
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                const SizedBox(height: sp16),
                Row(
                  children: [
                    Expanded(
                      child:
                          BlocBuilder<ProductCreateCubit, ProductCreateState>(
                        builder: (context, state) {
                          return InputCurrency(
                            label: 'Giá bán',
                            hintText: 'Nhập giá bán',
                            controller: widget.priceSellTec,
                            validate: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập giá bán';
                              }
                              return null;
                            },
                            onChanged: (value) => bloc.priceSellChange(value),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16.0,
                                horizontal: 12,
                              ),
                              child: Text(
                                'VNĐ',
                                style: p6.copyWith(
                                  color: borderColor_4,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: sp16),
                    Expanded(
                      child:
                          BlocBuilder<ProductCreateCubit, ProductCreateState>(
                        builder: (context, state) {
                          return InputCurrency(
                            label: 'Giá nhập',
                            hintText: 'Nhập giá nhập',
                            controller: widget.priceImportTec,
                            validate: (_) => null,
                            onChanged: (value) {
                              bloc.priceImportChange(value);
                            },
                            suffixIcon: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16.0,
                                horizontal: 12,
                              ),
                              child: Text(
                                'VNĐ',
                                style: p6.copyWith(
                                  color: borderColor_4,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
