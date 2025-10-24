import 'package:flutter/material.dart';
import 'package:one_click/shared/ext/index.dart';

import '../../../../data/models/store_model/address/type_data.dart';
import '../../../config/app_style/init_app_style.dart';

class BtsAddress extends StatelessWidget {
  final List<TypeData> list;
  final String title;
  const BtsAddress({super.key, required this.title, required this.list});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: 20.radiusTop,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 48,
                        height: 4,
                        margin: 8.pading,
                        decoration: const BoxDecoration(
                          color: AppColors.border_tertiary,
                        ),
                      ),
                    ],
                  ),
                  8.height,
                  Text(
                    'Chọn ',
                    textAlign: TextAlign.center,
                    style: AppStyle.headingMd.copyWith(
                      color: AppColors.text_secondary,
                    ),
                  ).padding(6.pading),
                ],
              ),
              Positioned(
                top: 8,
                right: 8,
                child: InkWell(
                  onTap: () => context.pop(),
                  child: Container(
                    padding: 16.pading,
                    decoration: const BoxDecoration(
                      color: AppColors.button_brand_alpha_backgroundDisabled,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: AppColors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Flexible(
            child: ListView(
              padding: EdgeInsets.zero,
              children: List.generate(
                list.length,
                (index) => ListTile(
                  title: Text(
                    list[index].title ?? '',
                    style: AppStyle.bodyBsRegular,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
