import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:one_click/domain/entity/product_detail_entity.dart';

class PropertyProduct extends StatelessWidget {
  const PropertyProduct({
    Key? key,
    required this.product,
  }) : super(key: key);

  final ProductDetailEntity product;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Thuộc tính',
            style: p1,
          ),
          const SizedBox(height: 12),
          product.properties.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: product.properties.length,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.properties[index].title,
                            style: p6,
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            runSpacing: 8,
                            spacing: 8,
                            children: product.properties[index].childProperties
                                .toSet()
                                .map(
                                  (title) => Container(
                                    decoration: BoxDecoration(
                                      color: borderColor_1,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    child: Text(
                                      title,
                                      style: p6,
                                    ),
                                  ),
                                )
                                .toSet()
                                .toList(),
                          )
                        ],
                      ),
                    );
                  },
                )
              : const Text(
                  'Không có thuộc tính',
                  style: p4,
                )
        ],
      ),
    );
  }
}
