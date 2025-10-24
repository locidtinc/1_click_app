import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_click/presentation/di/di.dart';
import 'package:one_click/presentation/shared_view/order/cubit/order_cubit.dart';
import 'package:one_click/presentation/shared_view/order/cubit/order_state.dart';

class CountWidget extends StatelessWidget {
  const CountWidget({
    super.key,
    this.quantity = 0,
    this.remaining = 0,
    required this.onTapReduced,
    required this.onTapIncremented,
  });

  final int quantity;
  final int remaining;
  final Function(int) onTapReduced;
  final Function(int) onTapIncremented;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderCubit>(
      create: (_) => getIt.get<OrderCubit>()..initData(quantity),
      child: Container(
        decoration: BoxDecoration(
          color: borderColor_1,
          borderRadius: BorderRadius.circular(sp8),
        ),
        padding: const EdgeInsets.all(sp8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                text: 'Số lượng',
                style: p6.copyWith(color: blackColor),
                children: [
                  if (remaining != 0)
                    TextSpan(
                      text: ' (còn lại: $remaining)',
                      style: p6.copyWith(color: borderColor_4),
                    )
                ],
              ),
            ),
            BlocBuilder<OrderCubit, OrderState>(
              builder: (context, state) => Container(
                width: MediaQuery.of(context).size.width * 0.3,
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(sp8),
                  border: Border.all(color: borderColor_2),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: sp12,
                  vertical: sp8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        context.read<OrderCubit>().reduced();
                        onTapReduced(state.quantity - 1);
                      },
                      child: const Icon(
                        Icons.remove,
                        size: sp24,
                        color: borderColor_4,
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        key: Key(state.quantity.toString()),
                        initialValue: state.quantity.toString(),
                        onChanged: context.read<OrderCubit>().onChangeQuantity,
                        maxLines: 1,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        context.read<OrderCubit>().incremented();
                        onTapIncremented(state.quantity + 1);
                      },
                      child: const Icon(
                        Icons.add,
                        size: sp24,
                        color: borderColor_4,
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
