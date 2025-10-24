import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entity/variant_create_order.dart';
import '../../../shared_view/card/variant_create_order_card.dart';
import '../cubit/order_create_cubit.dart';
import '../cubit/order_create_state.dart';

class TypeBarcodeView extends StatefulWidget {
  const TypeBarcodeView({
    super.key,
    required this.orderCreateCubit,
  });

  final OrderCreateCubit orderCreateCubit;

  @override
  State<TypeBarcodeView> createState() => _TypeBarcodeViewState();
}

class _TypeBarcodeViewState extends State<TypeBarcodeView> {
  final TextEditingController barcodeTec = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: sp24),
      height: heightDevice(context),
      width: widthDevice(context),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: sp16),
            child: Column(
              children: [
                Text(
                  'Mã vạch',
                  style: p3.copyWith(color: blackColor),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: sp16),
                AppInput(
                  controller: barcodeTec,
                  hintText: 'Nhập mã vạch',
                  textInputType: TextInputType.name,
                  validate: (value) {},
                  backgroundColor: whiteColor,
                ),
                const SizedBox(height: sp24),
                SizedBox(
                  width: double.infinity,
                  child: MainButton(
                    title: 'Thêm sản phẩm',
                    event: () => widget.orderCreateCubit
                        .getVariantByScanBarcode(context, barcodeTec.text),
                    largeButton: true,
                    icon: null,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: sp24),
          BlocBuilder<OrderCreateCubit, OrderCreateState>(
            bloc: widget.orderCreateCubit,
            builder: (context, state) {
              final listVariantSelect = state.listVariantSelect;
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final variant = listVariantSelect[index];
                  return VariantCreateOrderCard(
                    variant: variant,
                    // amountTec: TextEditingController(
                    //   text: variant.amount.toString(),
                    // ),
                    quantityChange: (
                      VariantCreateOrderEntity variant,
                      int value,
                    ) =>
                        widget.orderCreateCubit.changeAmount(variant, value),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(
                  height: sp16,
                ),
                itemCount: listVariantSelect.length,
              );
            },
          ),
        ],
      ),
    );
  }
}
