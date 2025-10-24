import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:one_click/domain/entity/product_detail_entity.dart';

class StatusProduct extends StatelessWidget {
  const StatusProduct({
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
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Trạng thái',
                style: p4,
              ),
              Text(
                product.statusProduct ? 'Đang bán' : 'Đã ẩn',
                style: p3.copyWith(color: mainColor),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(
              thickness: 1,
              height: 1,
              color: borderColor_2,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Bán online',
                style: p4,
              ),
              Text(
                product.statusOnline ? 'Đang bán' : 'Đã ẩn',
                style: p3.copyWith(color: mainColor),
              ),
            ],
          )
        ],
      ),
    );
  }
}
