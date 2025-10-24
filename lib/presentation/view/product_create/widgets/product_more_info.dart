import 'package:base_mykiot/base_lhe.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:one_click/presentation/base/overlay_input.dart';
import 'package:one_click/presentation/config/app_style/init_app_style.dart';
import 'package:one_click/presentation/view/product_create/cubit/product_create_cubit.dart';
import 'package:one_click/presentation/view/product_create/cubit/product_create_state.dart';
import 'package:one_click/presentation/view/product_manager/child/product/cubit/product_cubit.dart';
import 'package:one_click/shared/ext/index.dart';

import '../../../../domain/entity/brand.dart';
import '../../../base/select.dart';
import '../../../shared_view/widget/select_advance.dart';

class ProductMoreInfoView extends StatefulWidget {
  const ProductMoreInfoView({
    super.key,
    required this.expandableControllerMoreInfo,
    required this.onSelectCategory,
    required this.myBloc,
    required this.listBrandCtrl,
    required this.listcategoryCtrl,
  });

  final TextEditingController listBrandCtrl;
  final TextEditingController listcategoryCtrl;
  final ProductCreateCubit myBloc;
  final ExpandableController expandableControllerMoreInfo;
  final Function() onSelectCategory;

  @override
  State<ProductMoreInfoView> createState() => _ProductMoreInfoViewState();
}

class _ProductMoreInfoViewState extends State<ProductMoreInfoView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductCreateCubit, ProductCreateState>(
      bloc: widget.myBloc,
      listenWhen: (previous, current) =>
          previous.brand != current.brand ||
          previous.productcategory != current.productcategory,
      listener: (context, state) {
        final selectedBrand = state.listBrand.cast<BrandEntity?>().firstWhere(
              (e) => e?.id == state.brand,
              orElse: () => null,
            );
        final selectedCategory =
            state.listCategory.cast<BrandEntity?>().firstWhere(
                  (e) => e?.id == state.productcategory,
                  orElse: () => null,
                );
        widget.listBrandCtrl.text = selectedBrand?.title ?? '';
        widget.listcategoryCtrl.text = selectedCategory?.title ?? '';
      },
      child: ExpandableNotifier(
        controller: widget.expandableControllerMoreInfo,
        child: ExpandablePanel(
          theme: const ExpandableThemeData(hasIcon: false),
          header: Container(
            padding: const EdgeInsets.symmetric(
              vertical: sp16,
              horizontal: sp16,
            ),
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.vertical(
                top: const Radius.circular(sp8),
                bottom: Radius.circular(
                  widget.expandableControllerMoreInfo.expanded ? sp0 : sp8,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Thông tin thêm',
                  style: p1,
                ),
                AnimatedRotation(
                  turns:
                      !widget.expandableControllerMoreInfo.expanded ? 0 : 0.5,
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
            width: double.infinity,
            padding: const EdgeInsets.all(sp16).copyWith(top: sp0),
            decoration: const BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(sp8),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                const SizedBox(height: sp16),
                // Info Variant
                // CommonDropdown(
                //   label: 'Thương hiệu',
                //   onChanged: (value) =>
                //       context.read<ProductCreateCubit>().brandChange(value),
                //   items: listBrandDropdonw,
                //   hintText: 'Chọn thương hiệu',
                // ),
                BlocBuilder<ProductCreateCubit, ProductCreateState>(
                  bloc: widget.myBloc,
                  builder: (context, state) {
                    return
                        //    SelectAdvanced<BrandEntity>(
                        //     label: 'Thương hiệu',
                        //     value: state.listBrand
                        //         .cast<BrandEntity?>()
                        //         .firstWhere(
                        //           (e) => e?.id == state.brand,
                        //           orElse: () => null,
                        //         )
                        //         ?.title,
                        //     itemBuilder: (BuildContext context, item, int index) {
                        //       return Padding(
                        //         padding: const EdgeInsets.symmetric(
                        //           vertical: sp8,
                        //           horizontal: sp16,
                        //         ),
                        //         child: Text(item.title),
                        //       );
                        //     },
                        //     hintText: 'Chọn thương hiệu',
                        //     listItem: state.listBrand,
                        //     onSelect: (item) =>
                        //         context.read<ProductCreateCubit>().brandChange(item.id),
                        //     onAddNew: (value) =>
                        //         context.read<ProductCreateCubit>().createBrand(value),
                        //     onClearValue: () =>
                        //         context.read<ProductCreateCubit>().brandChange(null),
                        //   );
                        // },

                        Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Chọn thương hiệu',
                          style: h6.copyWith(color: blackColor),
                        ),
                        8.height,
                        OverlayInput(
                          hintText: 'Chọn thương hiệu',
                          contentPadding: 12.pading,
                          borderRadius: 8,
                          controller: widget.listBrandCtrl,
                          lazyLoad: (isMore) {
                            return widget.myBloc.getListProductBrand(
                                search: widget.listBrandCtrl.text,
                                isMore: isMore);
                          },
                          onChanged: (brandEntity) async {
                            widget.listBrandCtrl.text = brandEntity.title;
                            context
                                .read<ProductCreateCubit>()
                                .brandChange(brandEntity.id);
                          },
                          onAddNew: (value) => context
                              .read<ProductCreateCubit>()
                              .createBrand(value),
                          itemBuilder: (context, item, index) {
                            return Row(
                              children: [
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          item.title,
                                          overflow: TextOverflow.ellipsis,
                                        ).expanded(),
                                      ],
                                    ),
                                  ],
                                ).expanded(),
                              ],
                            ).padding(12.pading);
                          },
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: sp16),
                BlocBuilder<ProductCreateCubit, ProductCreateState>(
                  bloc: widget.myBloc,
                  builder: (context, state) {
                    return
                        //   SelectAdvanced<BrandEntity>(
                        //     label: 'Ngành hàng',
                        //     value: state.listCategory
                        //         .cast<BrandEntity?>()
                        //         .firstWhere(
                        //           (e) => e?.id == state.productcategory,
                        //           orElse: () => null,
                        //         )
                        //         ?.title,
                        //     itemBuilder: (BuildContext context, item, int index) {
                        //       return Padding(
                        //         padding: const EdgeInsets.symmetric(
                        //           vertical: sp8,
                        //           horizontal: sp16,
                        //         ),
                        //         child: Text(item.title),
                        //       );
                        //     },
                        //     hintText: 'Chọn ngành hàng',
                        //     listItem: state.listCategory,
                        //     onSelect: (item) {
                        //       myBloc.categoryChange(item.id);
                        //       myBloc.groupChange(null);
                        //       onSelectCategory();
                        //     },
                        //     onAddNew: (value) => context.read<ProductCreateCubit>().createCategory(value),
                        //     onClearValue: () => context.read<ProductCreateCubit>().categoryChange(null),
                        //   );
                        // },
                        Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Chọn ngành hàng',
                          style: h6.copyWith(color: blackColor),
                        ),
                        8.height,
                        OverlayInput(
                          hintText: 'Chọn ngành hàng',
                          borderRadius: 8,
                          controller: widget.listcategoryCtrl,
                          lazyLoad: (isMore) {
                            return widget.myBloc.getListProductCategory(
                                search: widget.listcategoryCtrl.text,
                                isMore: isMore);
                          },
                          onChanged: (brandEntity) async {
                            widget.listcategoryCtrl.text = brandEntity.title;
                            widget.myBloc.categoryChange(brandEntity.id);
                            widget.myBloc.groupChange(null);
                            widget.onSelectCategory();
                          },
                          itemBuilder: (context, item, index) {
                            return Row(
                              children: [
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          item.title,
                                          overflow: TextOverflow.ellipsis,
                                        ).expanded(),
                                      ],
                                    ),
                                  ],
                                ).expanded(),
                              ],
                            ).padding(12.pading);
                          },
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: sp16),
                BlocBuilder<ProductCreateCubit, ProductCreateState>(
                  builder: (context, state) {
                    return SelectAdvanced<BrandEntity>(
                      label: 'Nhóm sản phẩm',
                      value: state.listGroup
                          .cast<BrandEntity?>()
                          .firstWhere(
                            (e) => e?.id == state.productgroup,
                            orElse: () => null,
                          )
                          ?.title,
                      itemBuilder: (BuildContext context, item, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: sp8,
                            horizontal: sp16,
                          ),
                          child: Text(item.title),
                        );
                      },
                      onSelect: (item) {
                        widget.myBloc.groupChange(item.id);
                      },
                      listItem: state.listGroup,
                      onAddNew: (value) =>
                          context.read<ProductCreateCubit>().createGroup(value),
                      onClearValue: () =>
                          context.read<ProductCreateCubit>().groupChange(null),
                    );
                  },
                ),
                const SizedBox(height: sp4),
                Text(
                  'Nhóm sản phẩm sẽ dựa theo ngành hàng',
                  style: p7.copyWith(color: greyColor),
                ),
                const SizedBox(height: sp16),
                Container(
                  padding: const EdgeInsets.all(sp16),
                  decoration: BoxDecoration(
                    color: bg_4,
                    borderRadius: BorderRadius.circular(sp8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Phân loại',
                        style: p6.copyWith(color: blackColor),
                      ),
                      Text(
                        'Nội bộ',
                        style: p5.copyWith(color: blackColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
