import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:one_click/domain/entity/store_entity.dart';

import 'store_general_info_widget.dart';

class StoreReferentInfo extends StatelessWidget {
  const StoreReferentInfo({super.key, required this.store});

  final StoreEntity store;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: sp24, vertical: sp12),
      margin: const EdgeInsets.all(16).copyWith(bottom: 0, top: 0),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(sp8),
      ),
      child: Column(
        children: [
          ItemRow(title: 'Mã giới thiệu', value: store.referralCode),
          ItemRow(
              title: 'Người giới thiệu', value: store.parentAccount?.fullName),
          ItemRow(
              title: 'Đơn vị giới thiệu',
              value: store.parentAccount?.keyAccount),
        ],
      ),
    );
  }
}
