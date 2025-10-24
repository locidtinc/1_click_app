import 'package:base_mykiot/base_lhe.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_click/domain/entity/variant_entity.dart';
import 'package:one_click/presentation/di/di.dart';
import 'package:one_click/presentation/shared_view/order/cubit/order_cubit.dart';
import 'package:one_click/presentation/shared_view/order/cubit/order_state.dart';
import 'package:one_click/presentation/shared_view/widget/cache_image.dart';
import 'package:one_click/shared/ext/index.dart';
import 'package:one_click/shared/utils/event.dart';

class OrderWidget extends StatefulWidget {
  const OrderWidget({
    super.key,
    required this.variant,
    required this.titleButton,
    required this.onTap,
  });

  final VariantEntity variant;
  final String titleButton;
  final Function(int, int) onTap;

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  final myBloc = getIt.get<OrderCubit>();

  late TextEditingController amountTec;

  @override
  void initState() {
    super.initState();

    amountTec = TextEditingController(text: '0');
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderCubit>(
      create: (_) => myBloc,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  margin: const EdgeInsets.symmetric(horizontal: sp16) +
                      const EdgeInsets.only(top: sp24),
                  decoration: BoxDecoration(
                    border: Border.all(color: borderColor_1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: BaseCacheImage(
                      url: widget.variant.image,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: sp24),
                      Text(
                        widget.variant.title,
                        style: p5,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (widget.variant.promotion != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Ưu đãi còn lại: ${widget.variant.promotion!.quantity} sản phẩm',
                            style: p6.copyWith(color: borderColor_4),
                          ),
                        ),
                      const SizedBox(height: sp8),
                      widget.variant.promotion != null
                          ? RichText(
                              text: TextSpan(
                                text:
                                    '${FormatCurrency(widget.variant.priceSellDefault)}đ',
                                style: p6.copyWith(
                                  color: borderColor_4,
                                  decoration: TextDecoration.lineThrough,
                                ),
                                children: [
                                  TextSpan(
                                    text:
                                        ' ${FormatCurrency(widget.variant.priceSell)}đ',
                                    style: p5.copyWith(
                                      color: mainColor,
                                      decoration: TextDecoration.none,
                                    ),
                                  )
                                ],
                              ),
                            )
                          : Text(
                              'Giá bán: ${FormatCurrency(widget.variant.priceSellDefault)}đ')
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: sp12),
            const Divider(
              color: borderColor_2,
              height: 1,
              thickness: 1,
            ),
            const SizedBox(height: sp16),
            Container(
              decoration: BoxDecoration(
                color: borderColor_1,
                borderRadius: BorderRadius.circular(sp8),
              ),
              margin: const EdgeInsets.symmetric(horizontal: sp16),
              padding: const EdgeInsets.all(sp8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Số lượng', style: p6),
                  BlocBuilder<OrderCubit, OrderState>(
                    builder: (context, state) {
                      if ((amountTec.text) != state.quantity.toString() &&
                          amountTec.text.isNotEmpty) {
                        amountTec.text = state.quantity.toString();
                      }
                      return Container(
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
                              onTap: myBloc.reduced,
                              child: const Icon(
                                Icons.remove,
                                size: sp24,
                                color: borderColor_4,
                              ),
                            ),
                            Expanded(
                              child: TextFormField(
                                // key: Key(state.quantity.toString()),
                                controller: amountTec,
                                // initialValue: state.quantity.toString(),
                                onChanged: (value) =>
                                    myBloc.onChangeQuantity.call(value),
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
                              onTap: myBloc.incremented,
                              child: const Icon(
                                Icons.add,
                                size: sp24,
                                color: borderColor_4,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: sp24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: sp16),
              child: BlocBuilder<OrderCubit, OrderState>(
                builder: (context, state) {
                  final discount = widget.variant.promotion != null
                      ? widget.variant.priceSell *
                          (widget.variant.promotion!.discount) /
                          100
                      : 0;
                  final total = widget.variant.priceSell * state.quantity;
                  return MainButton(
                    title:
                        '${widget.titleButton} - ${total == 0 ? '0' : FormatCurrency(total)}đ',
                    event: () {
                      Navigator.of(context).pop();
                      widget.onTap(
                        state.quantity,
                        discount.toInt() * state.quantity,
                      );
                    },
                    largeButton: true,
                    icon: null,
                  );
                },
              ),
            ),
            const SizedBox(height: sp24),
          ],
        ),
      ),
    );
  }
}
