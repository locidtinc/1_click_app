import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:one_click/domain/entity/store_entity.dart';
import 'package:one_click/presentation/base/bank_empty.dart';
import 'package:one_click/presentation/base/card_base.dart';

class StoreBank extends StatelessWidget {
  const StoreBank({
    super.key,
    this.card,
    this.onTapAddBank,
    this.onTapEditBank,
  });

  final CardDataEntity? card;
  final VoidCallback? onTapAddBank;
  final VoidCallback? onTapEditBank;

  @override
  Widget build(BuildContext context) {
    return CardBase(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.symmetric(horizontal: 16) +
          const EdgeInsets.only(top: 16),
      child: card == null
          ? BankEmpty(
              onTapAddBank: onTapAddBank,
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tài khoản ngân hàng',
                  style: p4.copyWith(color: borderColor_4),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: borderColor_2),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        '${AssetsPath.icon}/ic_credit_card_2.svg',
                      ),
                      const SizedBox(width: 8),
                      Text(card?.shortName ?? '', style: p5),
                      const SizedBox(width: 4),
                      Text(
                        '***${card?.cardNumber.substring(card!.cardNumber.length - 3)}',
                        style: p6.copyWith(color: borderColor_4),
                      ),
                      const Spacer(),
                      if (onTapEditBank != null)
                        InkWell(
                          onTap: onTapEditBank,
                          child: Text(
                            'Chỉnh sửa',
                            style: p5.copyWith(color: blue_1),
                          ),
                        )
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
