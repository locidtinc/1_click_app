import 'package:base_mykiot/base_lhe.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/svg.dart';

import '../../../base/switch.dart';

class SynchronizedStatus extends StatefulWidget {
  const SynchronizedStatus({
    super.key,
    required this.title,
    required this.status,
    required this.statusChange,
  });

  final String title;
  final bool status;
  final Function(bool value) statusChange;

  @override
  State<SynchronizedStatus> createState() => _SynchronizedStatusState();
}

class _SynchronizedStatusState extends State<SynchronizedStatus> {
  late ExpandableController expandableController;

  @override
  void initState() {
    super.initState();

    expandableController = ExpandableController()
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    expandableController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    expandableController.value = widget.status;
    return Container(
      padding: const EdgeInsets.all(sp16),
      decoration: BoxDecoration(
        color: borderColor_1,
        borderRadius: BorderRadius.circular(sp8),
      ),
      child: ExpandablePanel(
        controller: expandableController,
        theme: const ExpandableThemeData(
          tapHeaderToExpand: false,
          hasIcon: false,
        ),
        header: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Đồng bộ giá ${widget.title}',
              style: p6.copyWith(color: blackColor),
            ),
            BaseSwitch(
              value: widget.status,
              onToggle: (value) {
                widget.statusChange.call(value);
              },
            )
          ],
        ),
        collapsed: const SizedBox(),
        expanded: Container(
          margin: const EdgeInsets.only(top: sp12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                '${AssetsPath.icon}/ic_warning.svg',
                width: sp12,
              ),
              const SizedBox(width: sp8),
              Expanded(
                child: Text(
                  'Giá ${widget.title} của các mẫu mã dưới sẽ được đồng bộ theo giá mới',
                  style: p6.copyWith(color: greyColor),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
