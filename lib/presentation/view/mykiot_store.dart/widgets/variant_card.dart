import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:one_click/presentation/routers/router.gr.dart';

import '../../../../domain/entity/variant_entity.dart';
import '../../../../shared/utils/event.dart';
import '../../../shared_view/widget/cache_image.dart';

class VariantMykiotCard extends StatelessWidget {
  const VariantMykiotCard({
    super.key,
    required this.variant,
  });

  final VariantEntity variant;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(sp8),
        color: whiteColor,
      ),
      padding: const EdgeInsets.all(sp8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: borderColor_1),
                borderRadius: BorderRadius.circular(sp8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(sp8),
                child: BaseCacheImage(
                  url: variant.image,
                  height: 80,
                  width: double.infinity,
                ),
              ),
            ),
          ),
          const SizedBox(height: sp12),
          Text(
            variant.title,
            style: p6,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: sp12),
          Text(
            '${FormatCurrency(variant.priceSell)}đ',
            style: p5.copyWith(color: mainColor),
          )
        ],
      ),
    );
  }
}
