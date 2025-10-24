import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';

class DialogCreateProductGroup extends StatelessWidget {
  const DialogCreateProductGroup({
    super.key,
    this.onTapConfirm,
    this.onChanged,
  });

  final VoidCallback? onTapConfirm;
  final Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(sp24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Tạo nhóm sản phẩm',
              style: p1,
            ),
            const SizedBox(height: sp24),
            AppInput(
              label: 'Tên nhóm sản phẩm',
              hintText: 'Nhập tên nhóm sản phẩm',
              validate: (String? value) {},
              onChanged: onChanged,
            ),
            const SizedBox(height: sp24),
            Row(
              children: [
                Expanded(
                  child: Extrabutton(
                    title: 'Huỷ bỏ',
                    event: Navigator.of(context).pop,
                    largeButton: true,
                    borderColor: borderColor_2,
                    icon: null,
                  ),
                ),
                const SizedBox(width: sp16),
                Expanded(
                  child: MainButton(
                    title: 'Xác nhận',
                    event: onTapConfirm != null ? onTapConfirm! : () {},
                    largeButton: true,
                    icon: null,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
