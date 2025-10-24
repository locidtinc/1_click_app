import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';

import '../../../../shared/utils/event.dart';
import '../../order_create/cubit/order_create_state.dart';

class StatusOrderCard extends StatelessWidget {
  const StatusOrderCard({
    super.key,
    required this.title,
    required this.id,
    required this.typeOrder,
  });

  final String title;
  final int id;
  final TypeOrder? typeOrder;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: sp12,
        horizontal: sp16,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(sp8),
        color: typeOrder == TypeOrder.cHTH
            ? getBackgroundColorByStatus(
                id,
              )
            : getBackgroundColorByStatusSystem(
                id,
              ),
      ),
      child: Text(
        title == 'Chờ NPT xác nhận' || title == 'NPT từ chối' ? 'Chờ xác nhận' : title,
        style: p5.copyWith(
          color: typeOrder == TypeOrder.cHTH
              ? getColorByStatus(
                  id,
                )
              : getColorByStatusSystem(
                  id,
                ),
        ),
      ),
    );
  }
}
