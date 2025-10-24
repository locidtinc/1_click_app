import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:one_click/domain/entity/product_preview.dart';
import 'package:one_click/domain/entity/variant_entity.dart';
import 'package:one_click/shared/ext/index.dart';
import 'package:one_click/shared/utils/event.dart';

class ProductPreviewCard extends StatelessWidget {
  const ProductPreviewCard({
    super.key,
    this.item,
    this.onTapItem,
    this.itemPrd,
    this.check,
    this.itemVariant,
  });
  final VariantEntity? itemVariant;
  final ProductPreviewEntity? item;
  final ProductDataEntity? itemPrd;
  final bool? check;
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
                  child: (item?.imageUrl.isEmpty ?? true) &&
                          (itemVariant?.image.isEmpty ?? true)
                      ? Image.asset(
                          '${AssetsPath.image}/img_product_default.png',
                        )
                      : Image.network(
                          item?.imageUrl ?? itemVariant?.image ?? '',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset(
                            '${AssetsPath.image}/img_product_default.png',
                          ),
                        ),
                ),
              ),
              title: Text(
                item?.productName ?? itemVariant?.title ?? '',
                style: p3.copyWith(color: blackColor),
              ),
              subtitle: Container(
                margin: const EdgeInsets.only(top: sp8),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item?.productCode ?? itemVariant?.code ?? '',
                          style: p4.copyWith(color: greyColor),
                        ),
                        Text(
                          '${FormatCurrency(item?.productPrice ?? itemVariant?.priceSell ?? '')} đ',
                          style: p6.copyWith(
                            color: red_1,
                          ),
                        ),
                      ],
                    ),
                    8.height,
                    itemVariant != null && itemVariant?.quantityInStock != 0
                        ? Row(
                            children: [
                              Text(
                                'Tồn kho: ${itemVariant?.quantityInStock?.toInt()}',
                                style: p5.copyWith(color: greyColor),
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              const Icon(
                                Icons.error,
                                color: red_1,
                              ),
                              8.width,
                              Text(
                                'Không đủ tồn kho',
                                style: p6.copyWith(color: red_1),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: item?.isAdminCreated ?? check ?? false,
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
