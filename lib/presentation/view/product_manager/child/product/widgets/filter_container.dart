import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';

class FilterContainer<T> extends StatelessWidget {
  const FilterContainer({
    super.key,
    required this.title,
    required this.listFilter,
    required this.itemBuilder,
  });

  final String title;
  final List<T> listFilter;
  final ItemWidgetBuilder<T> itemBuilder;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: p7.copyWith(color: blackColor),
        ),
        const SizedBox(height: sp16),
        BaseContainer(
          context,
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder:(context, index) => itemBuilder(context, index, listFilter[index]),
            separatorBuilder:(context, index) => const Divider(height: 1),
            itemCount: listFilter.length,
          ),
        ),
      ],
    );
  }
}

typedef ItemWidgetBuilder<ItemType> = Widget Function(
  BuildContext context,
  int index,
  ItemType item,
);
