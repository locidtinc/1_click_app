import 'package:base_mykiot/base_lhe.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SelectAddressWidget extends StatefulWidget {
  const SelectAddressWidget({
    super.key,
    this.value,
    this.hintText,
    this.onTap,
    this.onSearch,
  });

  final String? value;
  final String? hintText;
  final VoidCallback? onTap;
  final Function(String value)? onSearch;

  @override
  State<SelectAddressWidget> createState() => _SelectAddressWidgetState();
}

class _SelectAddressWidgetState extends State<SelectAddressWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: sp16, vertical: 0),
        decoration: BoxDecoration(
          // color: value == null ? borderColor_1 : whiteColor,
          borderRadius: BorderRadius.circular(sp8),
          border:
              widget.value == null ? Border.all(color: borderColor_2) : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  widget.value != null
                      ? '${AssetsPath.icon}/ic_circle.svg'
                      : '${AssetsPath.icon}/ic_selected.svg',
                ),
                const SizedBox(width: sp16),
                Expanded(
                  child: widget.value == null
                      ? TextField(
                          onChanged: (value) => widget.onSearch?.call(value),
                          decoration: InputDecoration(
                            hintText: widget.hintText,
                            hintStyle: p5.copyWith(color: greyColor),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: sp16),
                            border: InputBorder.none,
                            // suffixIcon:
                            //     const Icon(Icons.cancel_rounded, size: sp16),
                            // suffixIconColor: greyColor,
                          ),
                        )
                      : Text(
                          widget.value ?? widget.hintText!,
                          style: p5.copyWith(
                            color: blackColor,
                          ),
                        ),
                ),
              ],
            ),
            if (widget.value != null)
              const Padding(
                padding: EdgeInsets.only(left: 6, top: 4),
                child: DottedLine(
                  direction: Axis.vertical,
                  lineLength: 24,
                  dashColor: borderColor_3,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
