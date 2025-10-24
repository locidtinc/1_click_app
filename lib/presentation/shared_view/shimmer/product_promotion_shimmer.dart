import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'placeholders.dart';

class ProductPromotionShimmer extends StatelessWidget {
  const ProductPromotionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      enabled: true,
      child: const SizedBox(
        width: 237 + 32,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            BannerPlaceholder(
              height: 200,
            ),
            SizedBox(height: sp16),
            TitlePlaceholder(width: double.infinity),
          ],
        ),
      ),
    );
  }
}
