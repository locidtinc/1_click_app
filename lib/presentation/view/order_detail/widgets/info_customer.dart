import 'package:base_mykiot/base_lhe.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_svg/svg.dart';
import 'package:one_click/shared/utils/function.dart';

import '../../../../domain/entity/order_detail.dart';
import '../../../../shared/constants/pref_keys.dart';
import '../../../shared_view/widget/row_item.dart';

class InfoCustomerCard extends StatelessWidget {
  const InfoCustomerCard({
    super.key,
    required this.orderDetail,
  });

  final OrderDetailEntity? orderDetail;

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      context,
      Padding(
        padding: const EdgeInsets.all(sp8),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage: CachedNetworkImageProvider(
                    (orderDetail?.customerData?.image?.isEmpty ?? true
                            ? PrefKeys.avatarDefault
                            : orderDetail?.customerData?.image) ??
                        'https://img.freepik.com/premium-vector/3d-simple-user-icon-isolated_169241-7120.jpg',
                  ),
                ),
                const SizedBox(width: sp16),
                Text(
                  orderDetail?.customerData?.fullName ?? 'Khách lẻ',
                  style: p3.copyWith(color: blackColor),
                )
              ],
            ),
            const SizedBox(height: sp16),
            const Divider(height: 1),
            const SizedBox(height: sp16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.email,
                  size: sp16,
                ),
                const SizedBox(width: sp12),
                Expanded(
                  child: Text(
                    orderDetail?.customerData?.email ?? 'Không có thông tin',
                    style: p6.copyWith(color: blackColor),
                  ),
                )
              ],
            ),
            const SizedBox(height: sp12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.location_pin,
                  size: sp16,
                ),
                const SizedBox(width: sp12),
                Expanded(
                  child: Text(
                    orderDetail?.customerData?.address?.address ??
                        'Không có thông tin',
                    style: p6.copyWith(color: blackColor),
                  ),
                )
              ],
            ),
            if (orderDetail?.customerData?.phone != null &&
                (orderDetail?.customerData?.phone?.isNotEmpty ?? false))
              const SizedBox(height: sp24),
            if (orderDetail?.customerData?.phone != null &&
                (orderDetail?.customerData?.phone?.isNotEmpty ?? false))
              SizedBox(
                width: double.infinity,
                child: Extrabutton(
                  title: 'Gọi tới khách hàng',
                  event: () async {
                    makePhoneCall(
                      orderDetail!.customerData!.phone!,
                    );
                  },
                  largeButton: true,
                  borderColor: borderColor_2,
                  icon: SvgPicture.asset(
                    '${AssetsPath.icon}/ic_phone.svg',
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
