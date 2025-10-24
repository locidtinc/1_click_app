import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:one_click/domain/entity/store_entity.dart';
import 'package:one_click/presentation/view/store_information/widgets/store_general_info_widget.dart';

class StoreBusinessInfo extends StatelessWidget {
  const StoreBusinessInfo({super.key, required this.store});

  final StoreEntity store;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      margin: const EdgeInsets.all(16).copyWith(bottom: 0, top: 0),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          ItemRow(title: 'Người đại diện', value: store.deputyName),
          ItemRow(title: 'Người liên hệ', value: store.contact),
          // ItemRow(title: 'Email', value: store.email),
          if (store.business != 3)
            ItemRow(title: 'Mã số thuế', value: store.taxCode),
          if (store.business != 3)
            ItemRow(title: 'Mã số doanh nghiệp', value: store.businessCode),
          ItemRow(title: 'Diện tích kho (m²)', value: store.warehouseArea),
        ],
      ),
    );
  }
}
