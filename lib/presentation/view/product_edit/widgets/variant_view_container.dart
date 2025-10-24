import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:one_click/presentation/base/switch.dart';
import '../../../../domain/entity/product_detail_entity.dart';
import '../../../shared_view/widget/cache_image.dart';

class VariantViewContainer extends StatelessWidget {
  const VariantViewContainer({super.key, required this.variant});

  final VariantResponseEntity variant;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(sp8),
        border: Border.all(color: borderColor_2),
        color: whiteColor,
      ),
      padding: const EdgeInsets.symmetric(vertical: sp8, horizontal: sp16),
      child: Row(
        children: [
          BaseSwitch(value: variant.status, onToggle: (value) => null),
          const SizedBox(width: sp16),
          Expanded(
            child: ListTile(
              contentPadding: const EdgeInsets.all(sp0),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(sp8),
                child: Container(
                  height: 56,
                  width: 56,
                  decoration: BoxDecoration(
                    border: Border.all(color: borderColor_2),
                  ),
                  child: BaseCacheImage(
                    url: variant.image,
                  ),
                ),
              ),
              title: Text(
                variant.title,
                style: p3,
              ),
              subtitle: Container(
                margin: const EdgeInsets.only(top: sp12),
                child: Text(
                  variant.code,
                  style: p6.copyWith(color: greyColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
