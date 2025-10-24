import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../domain/entity/product_preview.dart';
import '../../../shared/constants/pref_keys.dart';
import '../../../shared/utils/event.dart';

class ProductAddedCard extends StatelessWidget {
  const ProductAddedCard({
    super.key,
    required this.deleteProduct,
    required this.product,
    this.warningItem,
    this.isDelete = false,
  });

  final ProductPreviewEntity product;
  final Function(ProductPreviewEntity product) deleteProduct;
  final Widget? warningItem;
  final bool isDelete;

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      context,
      Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ListTile(
                  contentPadding: const EdgeInsets.all(sp0),
                  leading: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      border: Border.all(color: borderColor_2),
                      borderRadius: BorderRadius.circular(sp8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(sp8),
                      child: Image.network(
                        product.imageUrl.isEmpty
                            ? PrefKeys.imgProductDefault
                            : product.imageUrl,
                      ),
                    ),
                  ),
                  title: Text(
                    product.productName,
                    style: p3.copyWith(color: blackColor),
                  ),
                  subtitle: Container(
                    margin: const EdgeInsets.only(top: sp12),
                    child: RichText(
                      text: TextSpan(
                        text: '${product.productCode} -',
                        style: p4.copyWith(color: greyColor),
                        children: [
                          TextSpan(
                            text: ' ${FormatCurrency(product.productPrice)}đ',
                            style: p4.copyWith(color: mainColor),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: sp16),
              if (isDelete)
                GestureDetector(
                  onTap: () => deleteProduct.call(product),
                  child: SvgPicture.asset(
                    '${AssetsPath.icon}/ic_trash.svg',
                    color: greyColor,
                  ),
                )
            ],
          ),
          if (warningItem != null)
            Visibility(
              visible: warningItem != null,
              child: Column(
                children: [
                  const SizedBox(height: sp16),
                  warningItem!,
                ],
              ),
            ),
        ],
      ),
    );
  }
}
