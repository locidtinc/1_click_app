import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_click/presentation/base/drop_column.dart';
import 'package:one_click/presentation/base/input_column.dart';
import 'package:one_click/presentation/config/app_style/init_app_style.dart';
import 'package:one_click/presentation/view/product_create/cubit/product_create_cubit.dart';
import 'package:one_click/presentation/view/product_create/cubit/product_create_state.dart';
import 'package:one_click/shared/bg/bg_bts.dart';
import 'package:one_click/shared/ext/index.dart';

class BtsConfigBasePrice extends StatefulWidget {
  const BtsConfigBasePrice({super.key, required this.bloc});

  final ProductCreateCubit bloc;

  @override
  State<BtsConfigBasePrice> createState() => _BtsConfigBasePriceState();
}

class _BtsConfigBasePriceState extends State<BtsConfigBasePrice> {
  final key = GlobalKey<FormState>();
  final sell = TextEditingController();
  final import = TextEditingController();
  final vat = TextEditingController();

  @override
  void initState() {
    final base = widget.bloc.findBase(widget.bloc.state.listUnit);
    level = base?.level ?? 1;
    if (base != null) {
      sell.text = base.sellPrice.formatPrice();
      //import.text = base.importPrice.formatPrice();
    }
    import.text = widget.bloc.state.priceImport;
    vat.text = widget.bloc.state.vat.formatPrice();
    super.initState();
  }

  @override
  void dispose() {
    sell.dispose();
    import.dispose();
    vat.dispose();
    super.dispose();
  }

  int? level;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: key,
      child: BgBts(
        label: 'Thiết lập giá cơ sở',
        cancelText: 'Huỷ',
        onCancel: () {
          context.pop();
        },
        confirmText: 'Xác nhận',
        onConfirm: () {
          if (!key.currentState!.validate()) {
            return;
          }
          final double sellPrice =
              double.tryParse(sell.text.removeAllDot()) ?? 0;
          final double importPrice =
              double.tryParse(import.text.removeAllDot()) ?? 0;
          final double vatPrice = double.tryParse(vat.text) ?? 0;
          widget.bloc
              .updatePrices(level ?? -1, sellPrice, importPrice, vatPrice);
          context.pop();
        },
        child: BlocBuilder<ProductCreateCubit, ProductCreateState>(
          bloc: widget.bloc,
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropDownColumn(
                  label: 'Đơn vị tính giá cơ sở',
                  isRequired: true,
                  padding: 0.pading,
                  items: List.generate(
                    widget.bloc.state.listUnit.length,
                    (index) => DropdownMenuItem(
                      value: widget.bloc.state.listUnit[index].level,
                      child: Text(widget.bloc.state.listUnit[index].name ?? ''),
                    ),
                  ),
                  value: level,
                  onChanged: (value) {
                    level = value as int;
                  },
                ),
                // 16.height,
                // _buildPrice(),
                // 4.height,
                // FormField(
                //   validator: (val) {
                //     final double sellPrice = double.tryParse(sell.text.removeAllDot()) ?? 0;
                //     if (sellPrice.toInt() % 100 != 0) {
                //       return 'Giá bán phải là bội số của 100đ';
                //     }
                //     final double importPrice = double.tryParse(import.text.removeAllDot()) ?? 0;
                //     if (sellPrice <= importPrice) {
                //       return 'Giá bán phải lớn hơn giá nhập';
                //     }
                //     return null;
                //   },
                //   builder: (field) => Column(
                //     children: [
                //       Text(
                //         'Giá bán là bội số của 100đ',
                //         style: AppStyle.bodySmRegular.copyWith(
                //           color: AppColors.text_tertiary,
                //         ),
                //       ),
                //       if (field.hasError) 4.height,
                //       if (field.hasError)
                //         Text(
                //           field.errorText ?? '',
                //           style: AppStyle.bodySmRegular.copyWith(
                //             color: AppColors.red50,
                //           ),
                //         ),
                //     ],
                //   ),
                // ),
                // 16.height,
                // DropDownColumn(
                //   label: 'Thuế VAT (%)',
                //   isRequired: true,
                //   padding: 0.pading,
                //   items: vats
                //       .map(
                //         (e) => DropdownMenuItem(
                //           value: e,
                //           child: Text('$e%'),
                //         ),
                //       )
                //       .toList(),
                //   value: widget.bloc.state.vat.toInt(),
                //   onChanged: (value) {
                //     widget.bloc.setVAT(value?.toDouble() ?? 0);
                //   },
                // ),
                // FormField(
                //   validator: (value) {
                //     if(widget.bloc.vat < 0 || widget.bloc.vat > 100) {
                //       return 'Thuế VAT không hợp lệ';
                //     }
                //   },
                //   builder: (field) {
                //     return Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         InputColumn(
                //           label: 'Thuế VAT (%)',
                //           padding: 0.pading,
                //           controller: vat,
                //           prefixIcon: Row(
                //             mainAxisSize: MainAxisSize.min,
                //             children: [
                //               16.width,
                //               Text(
                //                 '%',
                //                 style: AppStyle.bodyBsRegular.copyWith(
                //                   color: AppColors.input_textDefault,
                //                 ),
                //               ),
                //             ],
                //           ),
                //           inputFormatters: [
                //             CurrencyTextInputFormatter.currency(locale: 'vi', symbol: ''),
                //           ],
                //           textInputType: TextInputType.number,
                //           onChanged: (p0) {
                //             widget.bloc.vat = p0.removeAllDot().toDouble ?? 0;
                //           },
                //         ),
                //         if(field.hasError)
                //           4.height,
                //         if(field.hasError)
                //           Text(
                //             field.errorText ?? '',
                //             style: AppStyle.bodySmRegular.copyWith(
                //               color: AppColors.red50,
                //             ),
                //           ),
                //       ],
                //     );
                //   },
                // )
              ],
            );
          },
        ),
      ),
    );
  }

  Row _buildPrice() {
    return Row(
      children: [
        InputColumn(
          label: 'Giá bán',
          isRequired: true,
          controller: sell,
          inputFormatters: [
            CurrencyTextInputFormatter.currency(locale: 'vi', symbol: ''),
          ],
          prefixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              16.width,
            ],
          ),
          textInputType: TextInputType.number,
          onChanged: (p0) {
            // widget.bloc.basePrice = p0.removeAllDot().toInt;
          },
        ).expanded(),
        12.width,
        InputColumn(
          label: 'Giá nhập ban đầu',
          hintText: 'Nhập giá nhập',
          isRequired: true,
          controller: import,
          inputFormatters: [
            CurrencyTextInputFormatter.currency(locale: 'vi', symbol: ''),
          ],
          prefixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              16.width,
            ],
          ),
          textInputType: TextInputType.number,
          onChanged: (p0) {
            widget.bloc.setImportPrice(p0.removeAllDot().parseDouble ?? 0);
          },
        ).expanded(),
      ],
    );
  }

  List<int> vats = [0, 5, 8, 10];
}
