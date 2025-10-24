import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:one_click/domain/entity/brand.dart';
import 'package:one_click/presentation/view/product_manager/child/category/cubit/category_state.dart';
import 'package:one_click/shared/ext/index.dart';

import '../../../shared/constants/pref_keys.dart';

class BrandCard extends StatelessWidget {
  const BrandCard({
    super.key,
    required this.item,
    required this.typeCategory,
    this.onTap,
    this.onTapDelete,
  });

  final BrandEntity item;
  final TypeCategory typeCategory;
  final VoidCallback? onTap;
  final VoidCallback? onTapDelete;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: sp12),
            child: BaseContainer(
              context,
              Padding(
                padding: const EdgeInsets.all(sp8),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          if (typeCategory == TypeCategory.brand)
                            Container(
                              width: 56,
                              height: 56,
                              margin: const EdgeInsets.only(right: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  sp8,
                                ),
                                border: Border.all(
                                  color: borderColor_2,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  sp8,
                                ),
                                child: Image.network(
                                  item.image ?? PrefKeys.imgProductDefault,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.title, style: p3),
                              const SizedBox(height: sp16),
                              Text(
                                typeCategory == TypeCategory.category
                                    ? '${item.groups.length} nhóm sản phẩm'
                                    : typeCategory == TypeCategory.brand
                                        ? '${item.products.length} sản phẩm'
                                        : '${item.code} - ${item.products.length} sản phẩm',
                                style: p4.copyWith(color: greyColor),
                              )
                            ],
                          ).expanded()
                        ],
                      ),
                    ),
                    Visibility(
                      visible: !item.isSystem,
                      child: GestureDetector(
                        onTap: onTapDelete,
                        child: SvgPicture.asset(
                          '${AssetsPath.icon}/ic_delete.svg',
                          width: sp16,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Visibility(
            visible: item.isSystem,
            child: Positioned(
              right: sp12,
              child: Container(
                decoration: BoxDecoration(
                  color: bg_4,
                  borderRadius: BorderRadius.circular(sp8),
                ),
                padding: const EdgeInsets.all(2),
                child: SvgPicture.asset(
                  '${AssetsPath.icon}/logo_my_kiot.svg',
                  width: sp24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
