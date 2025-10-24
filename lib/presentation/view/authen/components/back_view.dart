import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:one_click/shared/constants/fa_code.dart';
import 'package:one_click/shared/ext/index.dart';

import '../../../../gen/assets.dart';
import '../../../base/custom_btn.dart';
import '../../../shared_view/widget/fa_icon.dart';

class BackView extends StatelessWidget {
  const BackView({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomBtn(
          onPressed: () => context.pop(),
          padding: 18.padingVer,
          title: 'Trở lại',
          prefix: FaIcon(code: FaCode.chevronLeft).padding(8.padingRight),
        ),
        const Spacer(),
        Image.asset(
          MyAssets.imgsLogo,
          width: 45,
          height: 45,
        ),
      ],
    );
  }
}
