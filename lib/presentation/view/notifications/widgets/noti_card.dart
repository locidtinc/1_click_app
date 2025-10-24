import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:one_click/data/models/noti_model.dart';

import '../../../../shared/utils/event.dart';

class NotiCard extends StatelessWidget {
  const NotiCard({super.key, required this.notiEntity});

  final NotiModel notiEntity;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: whiteColor,
      padding: const EdgeInsets.all(sp16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: bg_4,
            radius: sp24,
            child: Center(
              child: SvgPicture.asset('${AssetsPath.icon}/ic_noti_card.svg'),
            ),
          ),
          const SizedBox(width: sp16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      notiEntity.title ?? '',
                      style: p5,
                    ),
                    const Icon(
                      Icons.more_vert,
                      size: sp16,
                      color: greyColor,
                    ),
                  ],
                ),
                const SizedBox(height: sp8),
                Text(
                  '${notiEntity.content}',
                  style: p6.copyWith(color: borderColor_4, height: 1.5),
                ),
                const SizedBox(height: sp12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: '${timeBetween(
                          startTime: notiEntity.createAt ?? DateTime.now(),
                          endTime: DateTime.now(),
                        )} trước  ', //'${notiEntity.createAt?.isBefore(DateTime.now())}  ',
                        style: p5.copyWith(color: blue_1),
                        children: [
                          TextSpan(
                            style: p7.copyWith(color: greyColor),
                            text: DateFormat('dd/MM/y').format(
                              notiEntity.createAt ?? DateTime.now(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: !(notiEntity.isReaded ?? true),
                      child: const CircleAvatar(
                        backgroundColor: mainColor,
                        radius: sp4,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
