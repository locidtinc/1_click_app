import 'package:base_mykiot/base_lhe.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:one_click/data/models/payload/product/product_properties.dart';
import 'package:one_click/domain/entity/product_detail_entity.dart';

class PropertieFieldView extends StatelessWidget {
  const PropertieFieldView({
    super.key,
    required this.propertie,
    required this.addPropertieValue,
    required this.deletePropertieValue,
    required this.deletePropertie,
  });

  final ProductPropertiesModel propertie;
  final Function(String value) addPropertieValue;
  final Function(String value) deletePropertieValue;
  final Function() deletePropertie;

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      controller: propertie.controller,
      child: ExpandablePanel(
        theme: const ExpandableThemeData(hasIcon: false),
        header: Container(
          padding: const EdgeInsets.all(sp16),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.vertical(
              top: const Radius.circular(sp8),
              bottom: Radius.circular(
                propertie.controller!.expanded ? sp0 : sp8,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                propertie.name!.text.isEmpty
                    ? 'Tên thuộc tính'
                    : propertie.name!.text,
                style: p1,
              ),
              AnimatedRotation(
                turns: propertie.controller!.expanded ? 0.5 : 0,
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
                controller: propertie.name,
                label: 'Tên thuộc tính',
                // hintText: 'Nhập giá trị thuộc tính',
                hintText:
                    'Ví dụ: khối lượng, đóng gói, dung tích, số lượng, ...',

                validate: (value) {},
              ),
              const SizedBox(height: sp16),
              AppInput(
                label: 'Giá trị thuộc tính',
                required: true,
                // hintText: 'Nhập tên thuộc tính',
                hintText: 'Ví dụ: hương vị, chai, hộp, 500ml, 50g, ...',
                validate: (value) {},
                controller: TextEditingController(),
                textInputType: TextInputType.name,
                onConfirm: (value) {
                  if (value.isNotEmpty) {
                    addPropertieValue('${propertie.name?.text} $value');
                  }
                },
                fn: propertie.focusNode,
              ),
              const SizedBox(height: sp12),
              SizedBox(
                width: widthDevice(context),
                child: Wrap(
                  alignment: WrapAlignment.start,
                  direction: Axis.horizontal,
                  spacing: sp8,
                  runSpacing: sp8,
                  children: propertie.value!
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
                                  deletePropertieValue(e);
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
                    deletePropertie();
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
