import 'package:base_mykiot/base_lhe.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../domain/entity/product_edit_properties.dart';

/// [PropertieFieldContainer] use when [ProductDetailEntity] has only 1 [VariantResponseEntity] also default variant or empty [List] - [ProductEditPropertiesEntity]
class PropertieFieldContainer extends StatefulWidget {
  const PropertieFieldContainer({
    super.key,
    required this.propertie,
    required this.addPropertieValue,
    required this.deletePropertieValue,
  });

  final ProductEditPropertiesEntity propertie;
  final Function(String value) addPropertieValue;
  final Function(String value) deletePropertieValue;

  @override
  State<PropertieFieldContainer> createState() =>
      _PropertieFieldContainerState();
}

class _PropertieFieldContainerState extends State<PropertieFieldContainer> {
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
                widget.propertie.name,
                style: p1,
              ),
              AnimatedRotation(
                turns: expandableController.expanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 300),
                child: SvgPicture.asset(
                  '${AssetsPath.icon}/ic_arrow_down.svg',
                ),
              )
            ],
          ),
        ),
        collapsed: const SizedBox(),
        expanded: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(sp8),
          ),
          child: Container(
            padding: const EdgeInsets.all(sp16),
            decoration: const BoxDecoration(
              color: whiteColor,
              border: Border(
                top: BorderSide(color: borderColor_2),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(sp16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(sp8),
                    color: borderColor_1,
                  ),
                  child: Text(
                    widget.propertie.name,
                    style: p6,
                  ),
                ),
                const SizedBox(height: sp16),
                AppInput(
                  label: 'Giá trị thuộc tính',
                  required: true,
                  hintText: 'Nhập tên sản phẩm',
                  validate: (value) {},
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
                    children: widget.propertie.value
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
                            child: Text(e, style: p6),
                          ),
                        )
                        .toList(),
                  ),
                ),
                if (widget.propertie.newValue.isNotEmpty)
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
