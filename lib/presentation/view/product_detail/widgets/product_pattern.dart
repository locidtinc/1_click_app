import 'package:base_mykiot/base_lhe.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:one_click/domain/entity/product_detail_entity.dart';
import 'package:one_click/shared/utils/event.dart';

class ProductPattern extends StatelessWidget {
  const ProductPattern({
    Key? key,
    required this.product,
    this.onTapItem,
  }) : super(key: key);
  final ProductDetailEntity product;
  final Function(int)? onTapItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ExpandableNotifier(
        initialExpanded: true,
        child: ExpandablePanel(
          theme: const ExpandableThemeData(
            expandIcon: Icons.arrow_drop_down_sharp,
            collapseIcon: Icons.arrow_drop_up_sharp,
          ),
          header: Text(
            'Mẫu mã (${product.variant.length})',
            style: p1,
          ),
          collapsed: const SizedBox(),
          expanded: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: product.variant.length,
            itemBuilder: (context, index) {
              return Visibility(
                visible: product.variant[index].variant_mykios == true,
                child: InkWell(
                  onTap: () => onTapItem!(index),
                  child: _itemPattern(product.variant[index]),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _itemPattern(VariantResponseEntity item) {
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              width: 56,
              height: 56,
              progressIndicatorBuilder: (context, url, progress) => Center(
                child: CircularProgressIndicator(
                  value: progress.progress,
                ),
              ),
              imageUrl: item.image,
              errorWidget: (context, error, value) => Container(
                width: 56,
                height: 56,
                color: borderColor_1,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: p3,
                      ),
                    ),
                    const SizedBox(width: 24),
                    Text(
                      item.quantity.toString(),
                      style: p5,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: item.options
                      .map(
                        (e) => Text(
                          '${e.values}${item.options.length > 1 ? ', ' : ''}',
                          style: p6.copyWith(color: borderColor_4),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 4),
                Text(
                  item.code,
                  style: p4.copyWith(color: borderColor_4),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.status ? 'Đang bán' : 'Đã ẩn',
                      style:
                          p4.copyWith(color: item.status ? green_1 : greyColor),
                    ),
                    Text(
                      '${FormatCurrency(item.priceSell)}đ',
                      style: p3.copyWith(color: mainColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
