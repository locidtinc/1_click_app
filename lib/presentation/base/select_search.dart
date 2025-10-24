import 'package:base_mykiot/base_lhe.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class BaseSelectSearch<T> extends StatelessWidget {
  BaseSelectSearch({
    super.key,
    required this.items,
    this.selectedValue,
    required this.onChanged,
    required this.searchMatchFn,
    this.hint,
    this.hintSearch,
  });

  final List<DropdownMenuItem<T>> items;
  final T? selectedValue;
  final Function(T? value) onChanged;
  final bool Function(DropdownMenuItem<T> item, String searchValue)
      searchMatchFn;
  final String? hint;
  final String? hintSearch;

  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<T>(
        isExpanded: true,
        hint: Text(
          hint ?? 'Select Item',
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).hintColor,
          ),
        ),
        items: items,
        value: selectedValue,
        onChanged: (value) => onChanged.call(value),
        buttonStyleData: ButtonStyleData(
          width: 200,
          padding: const EdgeInsets.symmetric(horizontal: sp16, vertical: sp4),
          decoration: BoxDecoration(
            border: Border.all(color: borderColor_2),
            borderRadius: BorderRadius.circular(sp8),
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 300,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(sp8),
            ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
        ),
        dropdownSearchData: DropdownSearchData(
          searchController: textEditingController,
          searchInnerWidgetHeight: 56,
          searchInnerWidget: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(sp8),
            ),
            height: 60,
            padding: const EdgeInsets.only(
              top: 8,
              bottom: 4,
              right: 8,
              left: 8,
            ),
            child: TextFormField(
              expands: true,
              maxLines: null,
              controller: textEditingController,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: sp12,
                  vertical: sp16,
                ),
                hintText: hintSearch ?? 'Search for an item...',
                hintStyle: p6,
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: borderColor_2),
                  borderRadius: BorderRadius.circular(sp8),
                ),
                focusColor: blue_1,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: accentColor_7),
                  borderRadius: BorderRadius.circular(sp8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: borderColor_2),
                  borderRadius: BorderRadius.circular(sp8),
                ),
              ),
            ),
          ),
          searchMatchFn: (item, searchValue) =>
              searchMatchFn.call(item, searchValue),
        ),
        //This to clear the search value when you close the menu
        onMenuStateChange: (isOpen) {
          if (!isOpen) {
            textEditingController.clear();
          }
        },
      ),
    );
  }
}
