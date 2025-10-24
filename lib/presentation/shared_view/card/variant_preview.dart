import 'package:base_mykiot/base_lhe.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:one_click/domain/entity/product_preview.dart';
import 'package:one_click/domain/entity/variant_entity.dart';
import 'package:one_click/shared/utils/event.dart';

class VariantPreview extends StatelessWidget {
  const VariantPreview({
    super.key,
    required this.item,
    this.onTapItem,
  });

  final VariantEntity item;
  final VoidCallback? onTapItem;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onTap: onTapItem,
          splashColor: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.only(top: sp8),
            padding:
                const EdgeInsets.symmetric(horizontal: sp16, vertical: sp8),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(sp8),
              color: whiteColor,
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(0),
              leading: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(sp8),
                  border: Border.all(color: borderColor_1),
                ),
                width: 56,
                height: 56,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(sp8),
                  child: item.image.isEmpty
                      ? Image.asset(
                          '${AssetsPath.image}/img_product_default.png',
                        )
                      : Image.network(
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset(
                            '${AssetsPath.image}/img_product_default.png',
                          ),
                          item.image,
                          fit: BoxFit.cover,
                        ),
                  // : CachedNetworkImage(
                  //     progressIndicatorBuilder: (context, url, progress) => Center(
                  //       child: CircularProgressIndicator(
                  //         value: progress.progress,
                  //       ),
                  //     ),
                  //     imageUrl: item.image,
                  //   ),
                ),
              ),
              title: Text(
                item.title,
                style: p3.copyWith(color: blackColor),
              ),
              subtitle: Container(
                margin: const EdgeInsets.only(top: sp8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.code,
                      style: p4.copyWith(color: greyColor),
                    ),
                    Text('${FormatCurrency(item.priceSell)} đ'),
                  ],
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: true,
          child: Positioned(
            right: sp16,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(sp8),
                color: bg_4,
              ),
              child: Image.asset(
                '${AssetsPath.image}/ic_app.png',
                width: 22,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
