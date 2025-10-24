import 'package:base_mykiot/base_lhe.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../base/select.dart';

class ProductInfoExtraContainer extends StatefulWidget {
  const ProductInfoExtraContainer({
    super.key,
    required this.listBrandDropdonw,
    required this.listCategoryDropdonw,
    required this.listGroupDropdonw,
    this.brandSelect,
    this.categorySelect,
    this.groupSelect,
    this.brandSelected,
    this.categorySelected,
    this.groupSelected,
  });

  final List<DropdownMenuItem> listBrandDropdonw;
  final List<DropdownMenuItem> listCategoryDropdonw;
  final List<DropdownMenuItem> listGroupDropdonw;
  final dynamic brandSelected;
  final dynamic categorySelected;
  final dynamic groupSelected;
  final Function(dynamic)? brandSelect;
  final Function(dynamic)? categorySelect;
  final Function(dynamic)? groupSelect;

  @override
  State<ProductInfoExtraContainer> createState() =>
      _ProductInfoExtraContainerState();
}

class _ProductInfoExtraContainerState extends State<ProductInfoExtraContainer> {
  late ExpandableController expandableControllerMoreInfo;

  @override
  void initState() {
    super.initState();

    expandableControllerMoreInfo = ExpandableController(initialExpanded: true)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      controller: expandableControllerMoreInfo,
      child: ExpandablePanel(
        theme: const ExpandableThemeData(hasIcon: false),
        header: Container(
          padding: const EdgeInsets.symmetric(
            vertical: sp16,
            horizontal: sp16,
          ),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.vertical(
              top: const Radius.circular(sp8),
              bottom: Radius.circular(
                expandableControllerMoreInfo.expanded ? sp0 : sp8,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Thông tin thêm',
                style: p1,
              ),
              AnimatedRotation(
                turns: !expandableControllerMoreInfo.expanded ? 0 : 0.5,
                duration: const Duration(milliseconds: 300),
                child: SvgPicture.asset(
                  '${AssetsPath.icon}/ic_arrow_down.svg',
                ),
              )
            ],
          ),
        ),
        collapsed: const SizedBox(),
        expanded: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(sp16).copyWith(top: sp0),
          decoration: const BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(sp8),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(),
              const SizedBox(height: sp16),
              // Info Variant
              CommonDropdown(
                label: 'Thương hiệu',
                onChanged: (value) => widget.brandSelect?.call(value),
                items: widget.listBrandDropdonw,
                hintText: 'Chọn thương hiệu',
                value: widget.brandSelected,
              ),
              const SizedBox(height: sp16),
              CommonDropdown(
                label: 'Ngành hàng',
                onChanged: (value) => widget.categorySelect?.call(value),
                items: widget.listCategoryDropdonw,
                hintText: 'Chọn ngành hàng',
                value: widget.categorySelected,
              ),
              const SizedBox(height: sp16),
              CommonDropdown(
                label: 'Nhóm sản phẩm',
                onChanged: (value) => widget.groupSelect?.call(value),
                items: widget.listGroupDropdonw,
                hintText: 'Chọn nhóm sản phẩm',
                value: widget.groupSelected, showIconRemove: null,
              ),
              const SizedBox(height: sp4),
              Text(
                'Nhóm sản phẩm sẽ dựa theo ngành hàng',
                style: p7.copyWith(color: greyColor),
              ),
              const SizedBox(height: sp16),
              Container(
                padding: const EdgeInsets.all(sp16),
                decoration: BoxDecoration(
                  color: bg_4,
                  borderRadius: BorderRadius.circular(sp8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Phân loại',
                      style: p6.copyWith(color: blackColor),
                    ),
                    Text(
                      'Nội bộ',
                      style: p5.copyWith(color: blackColor),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
