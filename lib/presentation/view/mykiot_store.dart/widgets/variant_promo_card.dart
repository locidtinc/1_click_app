import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:one_click/domain/entity/variant_entity.dart';
import 'package:one_click/presentation/routers/router.gr.dart';

import '../../../../shared/utils/event.dart';
import '../../../shared_view/widget/cache_image.dart';
import '../../shopping_cart/cubit/shopping_cart_cubit.dart';

class VariantPromoCard extends StatelessWidget {
  const VariantPromoCard({
    super.key,
    required this.variant,
  });

  final VariantEntity variant;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 237 + 24,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(sp8),
        color: whiteColor,
      ),
      padding: const EdgeInsets.all(sp8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(sp8),
            child: BaseCacheImage(
              url: variant.image,
              width: 237,
              height: 129,
            ),
          ),
          const SizedBox(height: sp16),
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: sp8, horizontal: sp12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(sp8),
              color: yellow_1,
            ),
            child: Text(
              '-${variant.promotion?.typeDiscount == 2 ? '${variant.promotion?.discount.round()}%' : '${FormatCurrency(variant.priceSellDefault - variant.priceSell)}đ'}',
              style: p8.copyWith(color: whiteColor),
            ),
          ),
          const SizedBox(height: sp12),
          Text(
            variant.title,
            style: p6,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: sp12),
          RichText(
            text: TextSpan(
              text: '${FormatCurrency(variant.priceSellDefault.round())}đ',
              style: const TextStyle(
                color: greyColor,
                decoration: TextDecoration.lineThrough,
                decorationColor: greyColor,
                decorationThickness: 2.0,
              ),
            ),
          ),
          const SizedBox(height: sp12),
          Text(
            '${FormatCurrency(variant.priceSell.round())}đ',
            style: p5.copyWith(
              color: mainColor,
            ),
          )
        ],
      ),
    );
  }
}
