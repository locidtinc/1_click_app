import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:one_click/domain/entity/store_entity.dart';
import 'package:one_click/shared/ext/index.dart';

import '../../../../shared/constants/app_constant.dart';

class StoreGeneralInfo extends StatelessWidget {
  const StoreGeneralInfo({super.key, required this.store});

  final StoreEntity store;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      margin: const EdgeInsets.all(16).copyWith(bottom: 0),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // ItemRow(title: 'Mã cửa hàng', value: store.storeCode),
          ItemRow(title: 'Mã cửa hàng', value: store.keyAccount),
          ItemRow(title: 'Tên cửa hàng', value: store.nameStore),
          ItemRow(title: 'Số điện thoại', value: store.phoneNumber),
          ItemRow(
            title: 'Website',
            value: AppConstant.genWebsite(store.website ?? ''),
            isWebsite: true,
          ),
          // ItemRow(title: 'Email', value: store.email),
        ],
      ),
    );
  }
}

class ItemRow extends StatelessWidget {
  const ItemRow({
    super.key,
    required this.title,
    this.value,
    this.titleStyle,
    this.isWebsite = false,
  });

  final String title;
  final String? value;
  final TextStyle? titleStyle;
  final bool isWebsite;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: titleStyle ?? p4),
          const SizedBox(width: sp24),
          isWebsite
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 200,
                      child: Text(
                        value != null && value!.isNotEmpty
                            ? value!
                            : 'Chưa có dữ liệu',
                        style: value != null && value!.isNotEmpty
                            ? p3.copyWith(color: blue_1)
                            : p4.copyWith(color: greyColor),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        textAlign: TextAlign.right,
                      ),
                    ).expanded(),
                    const SizedBox(width: sp12),
                    GestureDetector(
                      onTap: () async {
                        await Clipboard.setData(
                          ClipboardData(text: value ?? ''),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Đã copy vào clipboard'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      child: SvgPicture.asset('${AssetsPath.icon}/ic_copy.svg'),
                    ),
                  ],
                ).expanded()
              : Expanded(
                  child: Text(
                    value == null || value!.isEmpty
                        ? 'Chưa có dữ liệu'
                        : value!,
                    style: value != null && value!.isNotEmpty
                        ? p3
                        : p4.copyWith(color: greyColor),
                    textAlign: TextAlign.end,
                  ),
                ),
        ],
      ),
    );
  }
}
