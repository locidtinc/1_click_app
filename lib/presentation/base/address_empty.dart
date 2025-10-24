import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:one_click/presentation/base/card_base.dart';

class AddressEmpty extends StatelessWidget {
  const AddressEmpty({super.key, this.onTapAddAddress});

  final VoidCallback? onTapAddAddress;

  @override
  Widget build(BuildContext context) {
    return CardBase(
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Thêm địa chỉ để xác định địa điểm bán hàng và vận chuyển',
                  style: p7.copyWith(color: greyColor),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: onTapAddAddress,
                  child: Text(
                    'Thêm địa chỉ',
                    style: p5.copyWith(color: blue_1),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 32),
          SvgPicture.asset('${AssetsPath.icon}/ic_location.svg'),
        ],
      ),
    );
  }
}
