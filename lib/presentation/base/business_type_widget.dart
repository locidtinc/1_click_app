import 'package:flutter/material.dart';
import 'package:one_click/presentation/base/card_base.dart';
import 'package:one_click/presentation/base/select_box_widget.dart';

class BusinessTypeWidget extends StatelessWidget {
  const BusinessTypeWidget({
    super.key,
    this.onChangeOpenTime,
    this.onChangeCloseTime,
    this.businessType,
    this.openTime,
    this.closeTime,
    this.onTap,
  });

  final VoidCallback? onChangeOpenTime;
  final VoidCallback? onChangeCloseTime;
  final String? businessType;
  final String? openTime;
  final String? closeTime;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return CardBase(
      child: Column(
        children: [
          SelectBoxWidget(
            title: 'Loại hình kinh doanh',
            hintText: 'Chọn loại hình kinh doanh',
            value: businessType,
            onTap: onTap,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SelectBoxWidget(
                  title: 'Giờ mở cửa',
                  hintText: '',
                  value: openTime,
                  onTap: onChangeOpenTime,
                  isSelectBox: false,
                  isSelectTime: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SelectBoxWidget(
                  title: 'Giờ đóng cửa',
                  hintText: '',
                  value: closeTime,
                  onTap: onChangeCloseTime,
                  isSelectBox: false,
                  isSelectTime: true,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
