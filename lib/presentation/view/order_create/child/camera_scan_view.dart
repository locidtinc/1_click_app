import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_click/domain/entity/variant_create_order.dart';
import 'package:one_click/presentation/shared_view/card/variant_create_order_card.dart';

import '../../../shared_view/widget/bar_code_scan.dart';
import '../cubit/order_create_cubit.dart';
import '../cubit/order_create_state.dart';

class CameraScanView extends StatefulWidget {
  const CameraScanView({
    super.key,
    required this.orderCreateCubit,
  });

  final OrderCreateCubit orderCreateCubit;

  @override
  State<CameraScanView> createState() => _CameraScanViewState();
}

class _CameraScanViewState extends State<CameraScanView> {
  bool isExpanded = false;

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
      child: Container(
        height: heightDevice(context) - 224 - 22,
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
                : QRViewExample(
                    orderCreateCubit: widget.orderCreateCubit,
                  ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: isExpanded
                    ? MediaQuery.of(context).size.height * 0.65
                    : MediaQuery.of(context).size.height - 200 - 300,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: sp16),
                      child: Container(
                        color: whiteColor,
                        child: BlocBuilder<OrderCreateCubit, OrderCreateState>(
                          bloc: widget.orderCreateCubit,
                          builder: (context, state) {
                            final listVariantSelect = state.listVariantSelect;
                            return ListView.separated(
                              itemBuilder: (context, index) {
                                final variant = listVariantSelect[index];
                                return VariantCreateOrderCard(
                                  variant: variant,
                                  toggleCheckbox: (value) {
                                    widget.orderCreateCubit
                                        .deleteVariant(variant);
                                  },
                                  // amountTec: TextEditingController(
                                  //   text: variant.amount.toString(),
                                  // ),
                                  quantityChange: (
                                    VariantCreateOrderEntity variant,
                                    int value,
                                  ) =>
                                      widget.orderCreateCubit
                                          .changeAmount(variant, value),
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                height: sp16,
                              ),
                              itemCount: listVariantSelect.length,
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
    );
  }
}
