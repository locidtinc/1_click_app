import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:one_click/domain/entity/variant_create_order.dart';

import '../../../shared/utils/event.dart';
import '../widget/cache_image.dart';

class VariantCreateOrderConfirmCard extends StatefulWidget {
  const VariantCreateOrderConfirmCard({
    super.key,
    required this.variant,
    required this.quantityChange,
    required this.toggleCheckbox,
    required this.priceSellChange,
  });

  final VariantCreateOrderEntity variant;
  final Function(VariantCreateOrderEntity variant, int value) quantityChange;
  final Function(VariantCreateOrderEntity variant, String value)
      priceSellChange;
  final Function(bool? value) toggleCheckbox;

  @override
  State<VariantCreateOrderConfirmCard> createState() =>
      _VariantCreateOrderConfirmCardState();
}

class _VariantCreateOrderConfirmCardState
    extends State<VariantCreateOrderConfirmCard> {
  late TextEditingController amountTec;
  late TextEditingController priceSellTec;
  late FocusNode amountFn;

  @override
  void initState() {
    super.initState();
    amountTec = TextEditingController(text: widget.variant.amount.toString());
    priceSellTec =
        TextEditingController(text: widget.variant.priceSell.toString());
    amountFn = FocusNode()
      ..addListener(() {
        if (!amountFn.hasFocus && amountTec.text.isEmpty) {
          widget.quantityChange(
            widget.variant,
            1,
          );
          setState(() {
            amountTec.text = '1';
          });
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: whiteColor,
      padding: const EdgeInsets.all(sp16),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(sp8),
                  border: Border.all(color: borderColor_2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(sp8),
                  child: BaseCacheImage(url: widget.variant.image ?? ''),
                ),
              ),
              const SizedBox(width: sp16),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            widget.variant.title,
                            style: p5.copyWith(color: blackColor),
                          ),
                        ),
                        const SizedBox(width: sp16),
                        GestureDetector(
                          onTap: () => widget.toggleCheckbox(false),
                          child: SvgPicture.asset(
                            '${AssetsPath.icon}/ic_trash.svg',
                            color: greyColor,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: sp12),
                    Text(
                      '${widget.variant.optionsData.map((e) => e.values)}',
                      style: p5.copyWith(color: blue_1),
                    ),
                    const SizedBox(height: sp12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tồn kho: ${widget.variant.inventory}',
                          style: p5.copyWith(color: borderColor_4),
                        ),
                        Text(
                          '${FormatCurrency(widget.variant.priceSell * widget.variant.amount)}đ',
                          style: p3.copyWith(color: mainColor),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: sp24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: Stack(
                  children: [
                    AppInput(
                      label: 'Số lượng',
                      controller: amountTec,
                      textInputType: TextInputType.number,
                      hintText: 'Nhập số lượng',
                      validate: (value) {},
                      textAlign: TextAlign.center,
                      onChanged: (value) => widget.quantityChange(
                        widget.variant,
                        int.parse(value),
                      ),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6)
                      ],
                    ),
                    Positioned(
                      bottom: sp16,
                      left: sp16,
                      child: GestureDetector(
                        onTap: () {
                          if (widget.variant.amount == 0) return;
                          widget.quantityChange(
                            widget.variant,
                            widget.variant.amount - 1,
                          );
                          amountTec.text = '${widget.variant.amount - 1}';
                        },
                        child: const Icon(
                          Icons.remove,
                          size: sp24,
                          color: borderColor_4,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: sp16,
                      right: sp16,
                      child: GestureDetector(
                        onTap: () {
                          widget.quantityChange(
                            widget.variant,
                            widget.variant.amount + 1,
                          );
                          amountTec.text = '${widget.variant.amount + 1}';
                        },
                        child: const Icon(
                          Icons.add,
                          size: sp24,
                          color: borderColor_4,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(width: sp16),
              Expanded(
                child: InputCurrency(
                  label: 'Đơn giá',
                  hintText: 'Nhập giá sản phẩm',
                  validate: () {},
                  onChanged: (value) =>
                      widget.priceSellChange(widget.variant, value),
                  controller: priceSellTec,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    // LengthLimitingTextInputFormatter(6)
                  ],
                  suffixIcon: SizedBox(
                    width: 50,
                    child: Center(
                      child: Text(
                        'VNĐ',
                        style: p6.copyWith(color: greyColor),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
