import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_click/presentation/base/app_bar.dart';
import 'package:one_click/presentation/view/product_manager/child/product/cubit/product_cubit.dart';
import 'package:one_click/presentation/view/product_manager/child/product/widgets/filter_container.dart';

import 'cubit/product_state.dart';

@RoutePage()
class ProductFilterPage extends StatefulWidget {
  const ProductFilterPage({
    super.key,
    required this.productCubit,
  });

  final ProductCubit productCubit;

  @override
  State<ProductFilterPage> createState() => _ProductFilterPageState();
}

class _ProductFilterPageState extends State<ProductFilterPage> {
  StatusFilter statusSelected = StatusFilter.all;
  SystemFilter systemFilter = SystemFilter.all;
  InventoryFilter inventoryFilter = InventoryFilter.all;

  @override
  void initState() {
    super.initState();

    statusSelected = widget.productCubit.state.statusSelected;
    systemFilter = widget.productCubit.state.systemSelected;
    inventoryFilter = widget.productCubit.state.inventorySelected;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg_4,
      appBar: const BaseAppBar(title: 'Bộ lọc'),
      body: Container(
        width: widthDevice(context),
        height: heightDevice(context),
        padding: const EdgeInsets.symmetric(vertical: sp24, horizontal: sp16),
        child: BlocBuilder<ProductCubit, ProductState>(
          bloc: widget.productCubit,
          builder: (context, state) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FilterContainer<StatusFilter>(
                    title: 'Trạng thái',
                    listFilter: state.statusListFilter,
                    itemBuilder: (context, index, item) {
                      return GestureDetector(
                        onTap: () => setState(() {
                          statusSelected = item;
                        }),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: sp16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(child: Text(item.title)),
                              Visibility(
                                visible: statusSelected == item,
                                child: const Icon(
                                  Icons.check,
                                  size: sp16,
                                  color: mainColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: sp24),
                  FilterContainer<SystemFilter>(
                    title: 'Phân loại',
                    listFilter: state.systemListFilter,
                    itemBuilder: (context, index, item) {
                      return GestureDetector(
                        onTap: () => setState(() {
                          systemFilter = item;
                        }),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: sp16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(child: Text(item.title)),
                              Visibility(
                                visible: systemFilter == item,
                                child: const Icon(
                                  Icons.check,
                                  size: sp16,
                                  color: mainColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: sp24),
                  FilterContainer<InventoryFilter>(
                    title: 'Tồn kho',
                    listFilter: state.inventoryListFilter,
                    itemBuilder: (context, index, item) {
                      return GestureDetector(
                        onTap: () => setState(() {
                          inventoryFilter = item;
                        }),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: sp16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(child: Text(item.title)),
                              Visibility(
                                visible: inventoryFilter == item,
                                child: const Icon(
                                  Icons.check,
                                  size: sp16,
                                  color: mainColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(sp16),
        color: whiteColor,
        child: Row(
          children: [
            Expanded(
              child: Extrabutton(
                title: 'Đặt lại',
                event: () => widget.productCubit.filterChange(
                  status: StatusFilter.all,
                  system: SystemFilter.all,
                  inventory: InventoryFilter.all,
                ),
                largeButton: true,
                borderColor: borderColor_2,
                icon: null,
              ),
            ),
            const SizedBox(width: sp16),
            Expanded(
              child: MainButton(
                title: 'Áp dụng',
                event: () {
                  widget.productCubit.filterChange(
                    status: statusSelected,
                    system: systemFilter,
                    inventory: inventoryFilter,
                  );
                  context.router.pop();
                },
                largeButton: true,
                icon: null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
