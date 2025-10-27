import 'package:base_mykiot/base_lhe.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:one_click/domain/entity/variant_create_order.dart';
import 'package:one_click/presentation/shared_view/widget/cache_image.dart';
import 'package:one_click/presentation/view/order_create/cubit/order_create_state.dart';
import 'package:one_click/shared/button/base_check_box_v2.dart';
import 'package:one_click/shared/ext/index.dart';
import 'package:one_click/shared/utils/event.dart';

///This widget use when use create orderSystem to Admin
///
///
class VariantCreateOrderCard extends StatefulWidget {
  const VariantCreateOrderCard({
    super.key,
    required this.variant,
    this.toggleCheckbox,
    required this.quantityChange,
    this.canDelete = true,
    this.typeOrder,
  });
  final TypeOrder? typeOrder;
  final VariantCreateOrderEntity variant;
  final Function(bool? value)? toggleCheckbox;
  final Function(VariantCreateOrderEntity variant, int value) quantityChange;
  final bool canDelete;

  @override
  State<VariantCreateOrderCard> createState() => _VariantCreateOrderCardState();
}

class _VariantCreateOrderCardState extends State<VariantCreateOrderCard> {
  late ExpandableController expandableController;
  late TextEditingController amountTec;
  late FocusNode amountFn;
  final Map<String, TextEditingController> textCtrls = {};
  TextEditingController getController(String id) {
    if (!textCtrls.containsKey(id)) {
      textCtrls[id] = TextEditingController();
    }
    return textCtrls[id]!;
  }

  @override
  void dispose() {
    amountTec.dispose();
    amountFn.dispose();
    expandableController.dispose();
    textCtrls.forEach(
      (key, value) {
        value.dispose();
      },
    );
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    amountTec = TextEditingController(text: '${widget.variant.amount}');
    amountFn = FocusNode()
      ..addListener(() {
        if (!amountFn.hasFocus && amountTec.text == '') {
          setState(() {
            amountTec.text = '1';
          });
        }
      });
    expandableController =
        ExpandableController(initialExpanded: widget.variant.isChoose)
          ..addListener(() {
            setState(() {});
          });
  }

  @override
  Widget build(BuildContext context) {
    if (int.parse(amountTec.text) != widget.variant.amount) {
      amountTec.text = widget.variant.amount.toString();
    }
    if (expandableController.expanded != widget.variant.isChoose) {
      expandableController.value = widget.variant.isChoose;
    }
    return Visibility(
      // visible: widget.typeOrder == TypeOrder.ad
      // || widget.variant.inventory != 0
      // ,
      child: Container(
        padding: const EdgeInsets.all(sp16),
        color: whiteColor,
        child: ExpandablePanel(
          controller: expandableController,
          collapsed: const SizedBox(),
          theme: const ExpandableThemeData(
            tapHeaderToExpand: false,
            hasIcon: false,
          ),
          header: Row(
            children: [
              if (widget.toggleCheckbox != null)
                BaseCheckboxV2(
                  fillColor: borderColor_1,
                  checkColor: mainColor,
                  value: widget.variant.isChoose,
                  onChanged: (value) {
                    expandableController.toggle();
                    widget.toggleCheckbox!.call(value);
                  },
                ),
              if (widget.toggleCheckbox != null) const SizedBox(width: sp16),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.variant.title,
                            style: p5.copyWith(color: blackColor),
                          ),
                        ),
                        const SizedBox(width: sp16),
                        Visibility(
                          visible: widget.canDelete,
                          child: GestureDetector(
                            onTap: () {
                              widget.toggleCheckbox?.call(false);
                            },
                            child: SvgPicture.asset(
                              '${AssetsPath.icon}/ic_trash.svg',
                              color: greyColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: sp8),
                    Text(
                      '${widget.variant.optionsData.isNotEmpty ? widget.variant.optionsData.map((e) => e.values) : 'Mẫu mã mặc định'}',
                      style: p5.copyWith(color: blue_1),
                    ),
                    const SizedBox(height: sp8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        widget.variant.inventory != 0
                            ? Text(
                                'Tồn kho: ${widget.variant.inventory}',
                                style: p6.copyWith(color: greyColor),
                              )
                            : Row(
                                children: [
                                  const Icon(
                                    Icons.error,
                                    color: red_1,
                                  ),
                                  8.width,
                                  Text(
                                    'Không đủ tồn kho',
                                    style: p6.copyWith(color: red_1),
                                  ),
                                ],
                              ),
                        const Spacer(),
                        Visibility(
                          visible:
                              widget.variant.promotionItem?.promotion != null,
                          child: Text(
                            '${FormatCurrency(widget.variant.priceSellDefault)}đ',
                            //variant.code,
                            style: p6.copyWith(
                              color: greyColor,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ),
                        Visibility(
                          visible:
                              widget.variant.promotionItem?.promotion != null,
                          child: const SizedBox(width: sp8),
                        ),
                      ],
                    ),
                    8.height,
                    Text(
                      '${FormatCurrency(widget.variant.priceSell)}đ',
                      style: p3.copyWith(color: mainColor),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
            ],
          ),
          expanded: Container(
            margin: const EdgeInsets.only(top: sp16),
            padding: const EdgeInsets.all(sp8),
            decoration: BoxDecoration(
              color: borderColor_1,
              borderRadius: BorderRadius.circular(sp8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Số lượng ',
                    style: p6.copyWith(color: blackColor),
                  ),
                ),
                Container(
                  // width: 200,
                  padding: const EdgeInsets.symmetric(
                    vertical: sp12,
                    horizontal: sp16,
                  ),
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(sp8),
                    border: Border.all(color: borderColor_2),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          widget.quantityChange(
                            widget.variant,
                            widget.variant.amount <= 1
                                ? 0
                                : widget.variant.amount - 1,
                          );
                          // setState(() {
                          //   amountTec.text = (widget.variant.amount - 1).toString();
                          // });
                        },
                        child: Container(
                          color: mainColor,
                          child: const Icon(
                            Icons.remove,
                            size: sp24,
                            color: whiteColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: sp20),
                      SizedBox(
                        width: 60,
                        height: 20,
                        child: TextField(
                          focusNode: amountFn,
                          controller: amountTec,
                          // controller: getController(widget.variant.id.toString()),
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(6),
                          ],
                          onChanged: (value) {
                            widget.quantityChange(
                              widget.variant,
                              int.parse(value).round(),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: sp20),
                      GestureDetector(
                        onTap: () {
                          widget.quantityChange(
                            widget.variant,
                            widget.variant.amount + 1,
                          );
                          // setState(() {
                          //   amountTec.text = (widget.variant.amount + 1).toString();
                          // });
                        },
                        child: Container(
                          color: mainColor,
                          child: const Icon(
                            Icons.add,
                            size: sp24,
                            color: whiteColor,
                          ),
                        ),
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
