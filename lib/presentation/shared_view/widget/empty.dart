import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';

class EmptyContainer extends StatelessWidget {
  const EmptyContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      context,
      Column(
        children: [
          const Icon(
            Icons.hourglass_empty_rounded,
            size: sp48,
            color: greyColor,
          ),
          const SizedBox(height: sp24),
          Text(
            'Danh sách rỗng',
            style: p1.copyWith(color: greyColor),
          ),
          const SizedBox(
            height: sp12,
          ),
        ],
      ),
    );
  }
}
