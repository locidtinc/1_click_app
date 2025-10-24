import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectTimeWidget extends StatefulWidget {
  const SelectTimeWidget({
    super.key,
    required this.onSelectDate,
    required this.title,
  });

  final String title;
  final Function(DateTime) onSelectDate;

  @override
  State<SelectTimeWidget> createState() => _SelectTimeWidgetState();
}

class _SelectTimeWidgetState extends State<SelectTimeWidget> {
  DateTime _dateTimeSelect = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(sp16),
            child: Stack(
              children: [
                Center(
                  child: Text(
                    widget.title,
                    style: p3,
                  ),
                ),
                Positioned(
                  right: 0,
                  child: InkWell(
                    onTap: () => widget.onSelectDate(_dateTimeSelect),
                    child: Text(
                      'Chọn',
                      style: p3.copyWith(color: blue_1),
                    ),
                  ),
                )
              ],
            ),
          ),
          const Divider(thickness: 1, height: 1, color: borderColor_2),
          Expanded(
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.time,
              use24hFormat: true,
              onDateTimeChanged: (DateTime value) {
                setState(() {
                  _dateTimeSelect = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
