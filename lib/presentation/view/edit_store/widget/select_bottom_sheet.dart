import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';

class SelectBottomSheet extends StatelessWidget {
  const SelectBottomSheet({
    super.key,
    required this.listBusinessType,
    required this.onTapItem,
    this.isSelected = false,
    this.height,
    required this.title,
    this.isBank = false,
  });

  final List<dynamic> listBusinessType;
  final bool isSelected;
  final Function(int) onTapItem;
  final double? height;
  final String title;
  final bool isBank;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? MediaQuery.of(context).size.height * 0.3,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(sp16),
            child: Center(
              child: Text(
                title,
                style: p3,
              ),
            ),
          ),
          const Divider(thickness: 1, height: 1, color: borderColor_2),
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: listBusinessType.length,
              padding: const EdgeInsets.only(top: sp8, bottom: sp24),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => onTapItem(index),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: sp16,
                      vertical: sp12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            isBank
                                ? listBusinessType[index].shortName
                                : listBusinessType[index].title!,
                            style: p4,
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            Icons.check,
                            color: green_1,
                          )
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: sp16),
                  child: Divider(thickness: 1, height: 1, color: borderColor_2),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
