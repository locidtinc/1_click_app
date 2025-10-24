import 'dart:math';

import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DialogCustoms {
  static Future showErrorDialog(
    BuildContext context, {
    required Widget content,
    Function? click,
    Function? close,
    String? titleConfirm,
    String? titleClose,
    Color? backgroundColor,
  }) {
    return showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Card(
            shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.circular(sp16),
            ),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: sp24, horizontal: sp16),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(sp16),
              ),
              width: max(widthDevice(context) - sp32, 343),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    '${AssetsPath.icon}/ic_error.svg',
                  ),
                  const SizedBox(height: sp24),
                  Text(
                    'Cảnh báo',
                    style: h3.copyWith(color: greyColor),
                  ),
                  const SizedBox(height: sp12),
                  content,
                  const SizedBox(height: sp12),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Extrabutton(
                          title: titleClose ?? 'Quay lại',
                          event: () {
                            Navigator.of(context).pop();
                            if (close != null) close.call();
                          },
                          borderColor: borderColor_4,
                          largeButton: true,
                          icon: null,
                        ),
                      ),
                      if (click != null) const SizedBox(width: sp16),
                      if (click != null)
                        Expanded(
                          flex: 1,
                          child: SupportButton(
                            title: titleConfirm ?? 'Xác nhận',
                            event: () {
                              click();
                            },
                            largeButton: true,
                            icon: null,
                            color: whiteColor,
                            backgroundColor: backgroundColor,
                          ),
                        ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static Future showNotifyDialog(
    BuildContext context, {
    required Widget content,
    Function? click,
    Function? close,
    String? titleConfirm,
    String? titleClose,
    Color? backgroundColor,
  }) {
    return showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Card(
            shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.circular(sp16),
            ),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: sp24, horizontal: sp16),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(sp16),
              ),
              width: max(widthDevice(context) - sp32, 343),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    '${AssetsPath.icon}/ic_warning.svg',
                  ),
                  const SizedBox(height: sp24),
                  Text(
                    'Thông báo',
                    style: h3.copyWith(color: greyColor),
                  ),
                  const SizedBox(height: sp12),
                  content,
                  const SizedBox(height: sp16),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Extrabutton(
                          title: titleClose ?? 'Quay lại',
                          event: () {
                            Navigator.of(context).pop();
                            if (close != null) close.call();
                          },
                          borderColor: borderColor_2,
                          largeButton: true,
                          icon: null,
                        ),
                      ),
                      if (click != null) const SizedBox(width: sp16),
                      if (click != null)
                        Expanded(
                          flex: 1,
                          child: SupportButton(
                            title: titleConfirm ?? 'Xác nhận',
                            event: () {
                              click();
                            },
                            largeButton: true,
                            icon: null,
                            color: whiteColor,
                            backgroundColor: backgroundColor,
                          ),
                        ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static Future showSuccessDialog(
    BuildContext context, {
    required Widget content,
    Function? click,
    String? titleConfirm,
    Color? backgroundColor,
  }) {
    return showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Card(
            shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.circular(sp16),
            ),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: sp24, horizontal: sp16),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(sp16),
              ),
              width: max(widthDevice(context) - sp32, 343),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    '${AssetsPath.icon}/ic_success.svg',
                  ),
                  const SizedBox(height: sp24),
                  Text(
                    'Thành công',
                    style: h3.copyWith(color: greyColor),
                  ),
                  const SizedBox(height: sp12),
                  content,
                  const SizedBox(height: sp12),
                  if (click != null)
                    SizedBox(
                      width: double.infinity,
                      child: SupportButton(
                        title: titleConfirm ?? 'Xác nhận',
                        event: () {
                          click();
                        },
                        largeButton: true,
                        icon: null,
                        color: whiteColor,
                        backgroundColor: backgroundColor,
                      ),
                    )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
