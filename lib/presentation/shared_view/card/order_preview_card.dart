import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:one_click/domain/entity/order_preview.dart';
import 'package:one_click/presentation/routers/router.gr.dart';
import 'package:one_click/presentation/view/order_create/cubit/order_create_state.dart';
import 'package:one_click/presentation/view/order_detail/widgets/status_order.dart';
import 'package:one_click/shared/constants/pref_keys.dart';

import '../../../shared/utils/event.dart';
import '../widget/row_item.dart';

class OrderPreviewCard extends StatelessWidget {
  const OrderPreviewCard({
    super.key,
    required this.item,
  });

  final OrderPreviewEntity item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.router.push(
        OrderDetailRoute(
          order: item.id,
          typeOrder: item.typeOrder ?? TypeOrder.cHTH,
          isDrafOrder: item.status.id == PrefKeys.idOrderDrafStatus,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(sp24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(sp8),
          color: whiteColor,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   item.isOnline == null ? 'MyKios' : 'Khách lẻ',
                    //   style: p3.copyWith(color: blackColor),
                    // ),
                    Text(
                      item.customerData?.fullName ?? 'Khách lẻ',
                      style: p3.copyWith(color: blackColor),
                    ),
                    const SizedBox(height: sp8),
                    Text(
                      item.code,
                      style: p7.copyWith(color: greyColor),
                    ),
                  ],
                ),
                StatusOrderCard(
                  title: item.status.title,
                  id: item.status.id,
                  typeOrder: item.typeOrder,
                ),
                // Container(
                //   padding: const EdgeInsets.symmetric(
                //     vertical: sp12,
                //     horizontal: sp16,
                //   ),
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(sp8),
                //     color: getBackgroundColorByStatus(item.status.id),
                //   ),
                //   child: Text(
                //     item.status.title,
                //     style: p5.copyWith(color: getColorByStatus(item.status.id)),
                //   ),
                // )
              ],
            ),
            const SizedBox(
              height: sp16,
            ),
            const Divider(),
            const SizedBox(
              height: sp16,
            ),
            if (item.isOnline != null)
              RowItem(
                title: 'Loại đơn hàng',
                content: item.isOnline! ? 'Online' : 'Trực tiếp',
              ),
            if (item.isOnline != null)
              const SizedBox(
                height: sp12,
              ),
            RowItem(title: 'Thời gian', content: item.createdAt),
            const SizedBox(
              height: sp12,
            ),
            RowItem(
              title: 'Tổng tiền (VNĐ)',
              content: FormatCurrency(item.total - item.discount),
            ),
            if (item.typeOrder == TypeOrder.cHTH && item.isOnline == false)
              const SizedBox(
                height: sp16,
              ),
            if (item.typeOrder == TypeOrder.cHTH && item.isOnline == false)
              // SizedBox(
              //   width: double.infinity,
              //   child: Text(
              //     item.statusPayment.title,
              //     style: p7.copyWith(color: item.statusPayment.color),
              //     textAlign: TextAlign.right,
              //   ),
              // ),
              RowItem(
                  title: 'Hình thức TT',
                  content: item.statusPayment.title,
                  contetnColor: item.statusPayment.color),
          ],
        ),
      ),
    );
  }
}
