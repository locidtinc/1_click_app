import 'package:base_mykiot/base_lhe.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../domain/entity/product_edit_properties.dart';

class PropertieFieldContainerNew extends StatefulWidget {
  const PropertieFieldContainerNew({
    super.key,
    required this.propertie,
    required this.addPropertieValue,
    required this.deletePropertieValue,
    required this.deletePropertie,
    this.namePropertieChange,
  });

  final ProductEditPropertiesEntity propertie;
  final Function(String value)? namePropertieChange;
  final Function(String value) addPropertieValue;
  final Function(String value) deletePropertieValue;
  final Function() deletePropertie;

  @override
  State<PropertieFieldContainerNew> createState() =>
      _PropertieFieldContainerNewState();
}

class _PropertieFieldContainerNewState
    extends State<PropertieFieldContainerNew> {
  late ExpandableController expandableController;

  @override
  void initState() {
    super.initState();

    expandableController = ExpandableController(initialExpanded: true)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    expandableController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      controller: expandableController,
      child: ExpandablePanel(
        theme: const ExpandableThemeData(hasIcon: false),
        header: Container(
          padding: const EdgeInsets.all(sp16),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.vertical(
              top: const Radius.circular(sp8),
              bottom: Radius.circular(
                expandableController.expanded ? sp0 : sp8,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.propertie.name.isEmpty
                    ? 'Tên thuộc tính'
                    : widget.propertie.name,
                style: p1,
              ),
              AnimatedRotation(
                turns: expandableController.expanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 300),
                child: SvgPicture.asset(
                  '${AssetsPath.icon}/ic_arrow_down.svg',
                ),
              ),
            ],
          ),
        ),
        collapsed: const SizedBox(),
        expanded: Container(
          padding: const EdgeInsets.all(sp16),
          decoration: const BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(sp8),
            ),
          ),
          child: Column(
            children: [
              AppInput(
                // controller: widget.propertie.name,
                required: true,
                label: 'Tên thuộc tính',
                hintText: 'Nhập giá trị thuộc tính',
                validate: (value) {},
                onChanged: (value) => widget.namePropertieChange?.call(value),
              ),
              const SizedBox(height: sp16),
              AppInput(
                label: 'Giá trị thuộc tính',
                required: true,
                hintText: 'Nhập tên sản phẩm',
                validate: (value) {},
                controller: TextEditingController(),
                textInputType: TextInputType.name,
                onConfirm: (value) {
                  if (value.isNotEmpty) {
                    widget.addPropertieValue(value);
                  }
                },
              ),
              const SizedBox(height: sp12),
              SizedBox(
                width: widthDevice(context),
                child: Wrap(
                  alignment: WrapAlignment.start,
                  direction: Axis.horizontal,
                  spacing: sp8,
                  runSpacing: sp8,
                  children: widget.propertie.newValue
                      .map(
                        (e) => Container(
                          margin: const EdgeInsets.only(right: sp8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(sp4),
                            color: bg_4,
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: sp4,
                            horizontal: sp8,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                e,
                                style: p6,
                              ),
                              const SizedBox(width: sp8),
                              GestureDetector(
                                onTap: () {
                                  widget.deletePropertieValue(e);
                                },
                                child: const Icon(
                                  Icons.close,
                                  size: sp16,
                                  color: greyColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: sp16),
              SizedBox(
                width: double.infinity,
                child: Extrabutton(
                  title: '',
                  event: () {
                    widget.deletePropertie();
                  },
                  largeButton: true,
                  borderColor: borderColor_2,
                  icon: Text(
                    'Xoá thuộc tính',
                    style: p5.copyWith(color: red_1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
