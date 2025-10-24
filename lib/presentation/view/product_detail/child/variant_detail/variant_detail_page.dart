import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_click/domain/entity/unit_entity.dart';
import 'package:one_click/presentation/base/app_bar.dart';
import 'package:one_click/presentation/base/card_base.dart';
import 'package:one_click/presentation/di/di.dart';
import 'package:one_click/presentation/shared_view/widget/cache_image.dart';
import 'package:one_click/presentation/view/product_detail/child/variant_detail/widgets/product_shipments_tab.dart';
import 'package:one_click/presentation/view/product_detail/cubit/product_detail_cubit.dart';
import 'package:one_click/presentation/view/product_detail/widgets/root_product_widget.dart';
import 'package:one_click/presentation/view/store_information/widgets/store_general_info_widget.dart';
import 'package:one_click/shared/ext/index.dart';
import 'package:one_click/shared/utils/event.dart';

import 'cubit/variant_detail_cubit.dart';
import 'cubit/variant_detail_state.dart';

@RoutePage()
class VariantDetailPage extends StatelessWidget {
  const VariantDetailPage({
    super.key,
    required this.id,
    this.codeSystemData,
    this.onConfirm,
    this.cubit,
  });

  final int id;
  final String? codeSystemData;
  final Function()? onConfirm;
  final ProductDetailCubit? cubit;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt.get<VariantDetailCubit>()
        ..getProductPatternDetail(id)
        ..init(id),
      child: BlocBuilder<VariantDetailCubit, VariantDetailState>(
        builder: (context, state) {
          final bloc = context.read<VariantDetailCubit>();
          return Scaffold(
            appBar: BaseAppBar(
              title: 'Chi tiết mẫu mã',
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: blackColor),
                onPressed: () => Navigator.of(context)
                    .pop(cubit?.loadData(state.variantEntity!.productData.id)),
              ),
            ),
            backgroundColor: borderColor_1,
            body: BlocBuilder<VariantDetailCubit, VariantDetailState>(
              builder: (context, state) {
                if (bloc.isLoading) {
                  return const BaseLoading();
                }
                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CardBase(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: sp16) +
                                      const EdgeInsets.only(top: sp24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: borderColor_1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: BaseCacheImage(
                                        url: state.variantEntity!.image,
                                      ),
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
                                  ItemRow(
                                    title: 'Mã vạch',
                                    value: state.variantEntity!.barCode,
                                    titleStyle:
                                        p4.copyWith(color: borderColor_4),
                                  ),
                                  ItemRow(
                                    title: 'Số lượng',
                                    value:
                                        '${state.variantEntity?.amount ?? 0}',
                                    titleStyle:
                                        p4.copyWith(color: borderColor_4),
                                  ),
                                  ItemRow(
                                    title: 'Giá bán',
                                    value:
                                        '${FormatCurrency(state.variantEntity!.priceSell)}đ',
                                    titleStyle:
                                        p4.copyWith(color: borderColor_4),
                                  ),
                                  ItemRow(
                                    title: 'Giá nhập',
                                    value:
                                        '${FormatCurrency(state.variantEntity!.priceImport)}đ',
                                    titleStyle:
                                        p4.copyWith(color: borderColor_4),
                                  ),
                                  ItemRow(
                                    title: 'Đơn vị',
                                    value: buildUnitChainString(
                                        state.variantEntity!.unit),
                                    titleStyle:
                                        p4.copyWith(color: borderColor_4),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            CardBase(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Trạng thái', style: p4),
                                  Text(
                                    state.variantEntity!.status
                                        ? 'Đang bán'
                                        : 'Đã ẩn',
                                    style: p3.copyWith(
                                      color: state.variantEntity!.status
                                          ? mainColor
                                          : borderColor_4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            RootProductWidget(
                              data: state.variantEntity!.productData,
                              codeSystemData: codeSystemData,
                            ),
                            // PrdShipmentWidget(
                            //   bloc: bloc,
                            // ),
                            16.height,
                            if (state.variantEntity != null)
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                width: double.infinity,
                                child: SupportButton(
                                  event: () async {
                                    await bloc.deleteVariant(context,
                                        state.variantEntity!, onConfirm);
                                    // onConfirm?.call();
                                  },
                                  title: 'Xoá sản phẩm',
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
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      color: whiteColor,
                      child: Extrabutton(
                        title: 'Chỉnh sửa',
                        event: () async {
                          await bloc.onTapEditVariant(context, id);
                          onConfirm?.call();
                        },
                        largeButton: true,
                        icon: const SizedBox(),
                        borderColor: borderColor_2,
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}

String buildUnitChainString(
  List<UnitEntity> units,
) {
  if (units.isEmpty) return '';
  final sortedUnits = [...units]
    ..sort((a, b) => (a.level ?? 0).compareTo(b.level ?? 0));
  final List<String> parts = [];
  for (final unit in sortedUnits) {
    parts.add('${unit.conversionValue} ${unit.title}');
  }
  return parts.join(' = ');
}
