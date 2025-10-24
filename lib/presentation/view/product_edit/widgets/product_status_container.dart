import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';

import '../../../base/switch.dart';

class ProductStatusContainer extends StatelessWidget {
  const ProductStatusContainer({
    super.key,
    required this.statusProduct,
    required this.statusOnline,
    required this.statusProductChange,
    required this.statusOnlineChange,
  });

  final bool statusProduct;
  final bool statusOnline;
  final Function(bool value) statusProductChange;
  final Function(bool value) statusOnlineChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(sp16),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(sp8),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Trạng thái',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
              ),
              Text(
                statusProduct ? 'Đang bán' : 'Không bán',
                style: TextStyle(
                  color: statusProduct ? mainColor : greyColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: sp8),
              BaseSwitch(
                value: statusProduct,
                onToggle: (value) => statusProductChange.call(value),
              )
            ],
          ),
          Column(
            children: [
              Visibility(
                visible: statusProduct,
                child: const Divider(height: 32),
              ),
              Visibility(
                visible: statusProduct,
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Bán online',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: sp16),
                    BaseSwitch(
                      value: statusOnline,
                      onToggle: (value) => statusOnlineChange.call(value),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
