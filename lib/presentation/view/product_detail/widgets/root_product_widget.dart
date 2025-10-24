import 'package:base_mykiot/base_lhe.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:one_click/data/apis/end_point.dart';
import 'package:one_click/domain/entity/variant_entity.dart';
import 'package:one_click/presentation/base/card_base.dart';
import 'package:one_click/presentation/shared_view/widget/cache_image.dart';
import 'package:one_click/presentation/view/store_information/widgets/store_general_info_widget.dart';

class RootProductWidget extends StatelessWidget {
  const RootProductWidget({super.key, required this.data, this.codeSystemData});

  final ProductDataEntity data;
  final String? codeSystemData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text('Sản phẩm gốc', style: p1),
        ),
        CardBase(
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: borderColor_1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: BaseCacheImage(
                        width: 56,
                        height: 56,
                        url: data.image,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.title,
                          style: p3,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          data.code,
                          style: p3.copyWith(color: borderColor_4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(
                height: 1,
                thickness: 1,
                color: borderColor_2,
              ),
              const SizedBox(height: 16),
              ItemRow(
                title: 'Thương hiệu',
                value: data.brand,
                titleStyle: p4.copyWith(color: borderColor_4),
              ),
              ItemRow(
                title: 'Ngành hàng',
                value: data.category,
                titleStyle: p4.copyWith(color: borderColor_4),
              ),
              ItemRow(
                title: 'Nhóm sản phẩm',
                value: data.group,
                titleStyle: p4.copyWith(color: borderColor_4),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: borderColor_1,
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Phân loại',
                      style: p4.copyWith(color: borderColor_4),
                    ),
                    Text(
                      codeSystemData == Api.key ? 'Nội bộ' : 'My Kios',
                      style: p3,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
