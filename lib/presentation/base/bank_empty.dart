import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';

class BankEmpty extends StatelessWidget {
  const BankEmpty({super.key, this.onTapAddBank});

  final VoidCallback? onTapAddBank;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Thêm tài khoản ngân hàng để sử dụng chức năng thanh toán trực tuyến',
                style: p7.copyWith(color: greyColor),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: onTapAddBank,
                child: Text(
                  'Thêm tài khoản ngân hàng',
                  style: p5.copyWith(color: blue_1),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 32),
        Image.asset(
          '${AssetsPath.icon}/ic_credit_card.png',
          width: 40,
        ),
      ],
    );
  }
}
