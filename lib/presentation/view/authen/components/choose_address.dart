import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:one_click/gen/assets.dart';
import 'package:one_click/presentation/view/authen/models/confirm_account_payload.dart';
import 'package:one_click/shared/ext/index.dart';

import '../../../config/app_style/init_app_style.dart';

Widget ChooseAddress({
  AddressDataPayload? address,
  Function()? onTap,
  String? errorText,
  Color? bg,
}) {
  return InkWell(
    onTap: onTap,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: 16.pading,
          decoration: BoxDecoration(
            color: bg ?? AppColors.greyF5,
            borderRadius: 8.radius,
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (address != null) ...[
                    Text(
                      address.toText,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyle.bodySmMedium.copyWith(
                        color: AppColors.grey79,
                      ),
                    ),
                    4.height,
                    Text(
                      address.address ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyle.bodySmMedium.copyWith(
                        color: AppColors.grey79,
                      ),
                    ),
                    4.height,
                  ],
                  Row(
                    children: [
                      Text(
                        address == null ? 'Chọn địa chỉ' : 'Sửa địa chỉ',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppStyle.bodyBsMedium.copyWith(
                          color: AppColors.blue60,
                        ),
                      ),
                      Text(
                        ' *',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppStyle.bodyBsMedium.copyWith(
                          color: AppColors.fg_positive,
                        ),
                      ),
                    ],
                  ),
                ],
              ).expanded(),
              16.width,
              SvgPicture.asset(
                MyAssets.iconsIcLocation,
                width: 40,
                height: 40,
              ),
            ],
          ),
        ),
        if (errorText != null)
          Text(
            errorText,
            style: AppStyle.bodySmRegular.copyWith(
              color: AppColors.fg_positive,
            ),
          ).padding(10.pading),
      ],
    ),
  );
}
