import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_click/presentation/base/app_bar.dart';
import 'package:one_click/presentation/config/app_style/init_app_style.dart';
import 'package:one_click/presentation/di/di.dart';
import 'package:one_click/presentation/routers/router.gr.dart';
import 'package:one_click/presentation/shared_view/widget/cache_image.dart';
import 'package:one_click/presentation/shared_view/widget/empty.dart';
import 'package:one_click/presentation/view/ware_house/cubit/warehouse_cubit_v2.dart';
import 'package:one_click/presentation/view/ware_house/cubit/warehouse_state.dart';
import 'package:one_click/shared/ext/index.dart';

@RoutePage()
class WarehouseListPageV2 extends StatefulWidget {
  const WarehouseListPageV2({super.key});

  @override
  State<WarehouseListPageV2> createState() => _WarehouseListPageV2State();
}

class _WarehouseListPageV2State extends State<WarehouseListPageV2> {
  final myBloc = getIt.get<WarehouseCubitV2>();
  late ScrollController _scroll;
  @override
  void initState() {
    super.initState();
    _scroll = ScrollController();
    _scroll.onMore(() => myBloc.getListInventory(isMore: true));
    // myBloc.initData(timeFilter.last);
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocProvider(
          create: (context) => myBloc
            // ..getListWareHouse()
            ..getListInventory(),
          child: Scaffold(
            backgroundColor: whiteColor,
            appBar: BaseAppBar(
              title: 'Danh sách kho',
              actions: [
                PopupMenuButton(
                  offset: const Offset(0, 30),
                  itemBuilder: (context) {
                    return [
                      // const PopupMenuItem<String>(
                      //   value: '0',
                      //   child: Text('Quản lý phiếu nhập kho'),
                      // ),
                      const PopupMenuItem<String>(
                        value: '1',
                        child: Text('Tạo phiếu nhập'),
                      ),
                      // const PopupMenuItem<String>(
                      //   value: '2',
                      //   child: Text('Tạo phiếu xuất'),
                      // ),
                    ];
                  },
                  onSelected: (value) {
                    switch (value) {
                      case '0':
                      // context.router.push(
                      //   ManagerWarehouseImportRoute(
                      //     id: state.warehouseSelect?.id ?? 0,
                      //   ),
                      // );
                      case '1':
                        context.router.push(
                          const CreateWarehouseReceiptRoute(),
                        );
                      case '2':
                        break;
                      default:
                    }
                  },
                  // );
                  //   },
                ),
              ],
            ),
            body: _body(),
          ),
        ),
      );

  Widget _body() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<WarehouseCubitV2, WarehouseState>(
            builder: (context, state) {
              if (state.isLoading) return const BaseLoading();
              if (state.inventories.isEmpty) return const EmptyContainer();
              return Expanded(
                child: RefreshIndicator(
                  onRefresh: () => myBloc.getListInventory(),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView.separated(
                      controller: _scroll,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final inventory = state.inventories[index];
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            // context.router.push(
                            //   ProductDetailV2Route(
                            //     id: inventory.product?.id ?? 0,
                            //     onRefresh: () {},
                            //   ),
                            // );
                            context.router.push(VariantDetailRoute(
                                id: inventory.variant!, onConfirm: () {}));
                          },
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  BaseCacheImage(
                                    url: inventory.product?.image ?? '',
                                    width: 64,
                                    height: 64,
                                    fit: BoxFit.cover,
                                  ),
                                  16.width,
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        inventory.product?.code ?? '',
                                        style: p9.copyWith(
                                          color: AppColors.text_primary,
                                        ),
                                      ),
                                      4.height,
                                      Text(
                                        inventory.product?.productName ?? '',
                                        style: p7,
                                      ),
                                      4.height,
                                      Row(
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              text: 'Tồn ',
                                              style: p9.copyWith(
                                                color: AppColors.text_primary,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text:
                                                      (inventory.inventory ?? 0)
                                                          .formatPrice(),
                                                  style: p7,
                                                ),
                                              ],
                                            ),
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              text: ' Số lô ',
                                              style: p9.copyWith(
                                                color: AppColors.text_primary,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: (inventory
                                                              .totalShipment ??
                                                          0)
                                                      .formatPrice(),
                                                  style: p7,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ).expanded(),
                                ],
                              ),
                              12.height,
                              Container(
                                padding: 12.pading,
                                decoration: BoxDecoration(
                                  color: AppColors.bg_secondary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          'Cận date',
                                          style: p7.copyWith(
                                            color: AppColors.text_primary,
                                          ),
                                        ),
                                        8.height,
                                        RichText(
                                          text: TextSpan(
                                            text: (inventory.quantityNearDate ??
                                                    0)
                                                .formatPrice(),
                                            style: p3.copyWith(
                                              color: AppColors.text_warning,
                                            ),
                                            children: [
                                              TextSpan(
                                                text:
                                                    ' (trong ${(inventory.totalShipmentNearDate ?? 0).formatPrice()} lô)',
                                                style: p7.copyWith(
                                                  color: AppColors.text_primary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ).expanded(),
                                    Container(
                                      color: AppColors.border_tertiary,
                                      width: 1,
                                      height: 44,
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          'Hết hạn',
                                          style: p7.copyWith(
                                            color: AppColors.text_primary,
                                          ),
                                        ),
                                        8.height,
                                        Text(
                                          (inventory.quantityExpDate ?? 0)
                                              .formatPrice(),
                                          style: p3.copyWith(
                                            color: AppColors.red60,
                                          ),
                                        ),
                                      ],
                                    ).expanded(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => 16.height,
                      itemCount: state.inventories.length,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      );
}

class FilterButtonModel {
  final String title;
  final dynamic value;

  const FilterButtonModel({
    required this.title,
    this.value,
  });
}
