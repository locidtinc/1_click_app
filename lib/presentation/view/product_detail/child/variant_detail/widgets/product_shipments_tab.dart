import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:one_click/presentation/base/base_container.dart';
import 'package:one_click/presentation/base/card_base.dart';
import 'package:one_click/presentation/config/app_style/init_app_style.dart';
import 'package:one_click/presentation/view/product_detail/child/variant_detail/cubit/variant_detail_cubit.dart';
import 'package:one_click/shared/ext/index.dart';
import 'package:one_click/shared/utils/event.dart';

class PrdShipmentWidget extends StatefulWidget {
  const PrdShipmentWidget({
    super.key,
    required this.bloc,
  });
  final VariantDetailCubit bloc;
  @override
  State<PrdShipmentWidget> createState() => _PrdShipmentWidgetState();
}

class _PrdShipmentWidgetState extends State<PrdShipmentWidget> {
  late ScrollController controller;

  @override
  void initState() {
    super.initState();
    controller = ScrollController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = widget.bloc;
    final shipments = bloc.state.shipmentsInfor;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: CardBase(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text.rich(
                TextSpan(
                  text: 'Tổng tồn kho: ',
                  style: p4,
                  children: [
                    TextSpan(
                      text: FormatCurrency(shipments?.quantityInventory ?? 0),
                      style: p2,
                    ),
                  ],
                ),
              ),
              12.height,
              Container(
                padding: 12.pading,
                decoration: BoxDecoration(
                  color: AppColors.bg_secondary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Text(
                          'Cận date',
                          style: p7.copyWith(
                            color: AppColors.text_primary,
                          ),
                        ),
                        8.height,
                        RichText(
                          text: TextSpan(
                            text: FormatCurrency(shipments?.quantityNearDate),
                            style: p4.copyWith(
                              color: AppColors.text_warning,
                            ),
                            children: [
                              TextSpan(
                                text:
                                    ' (trong ${FormatCurrency(shipments?.totalShipmentNearDate)} lô)',
                                style: p7.copyWith(
                                  color: AppColors.text_primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ).expanded(),
                    Container(
                      color: AppColors.border_tertiary,
                      width: 1,
                      height: 44,
                    ),
                    Column(
                      children: [
                        Text(
                          'Hết hạn',
                          style: p7.copyWith(
                            color: AppColors.text_primary,
                          ),
                        ),
                        8.height,
                        Text(
                          FormatCurrency(shipments?.quantityExpDate ?? ''),
                          style: p4.copyWith(
                            color: AppColors.red60,
                          ),
                        ),
                      ],
                    ).expanded(),
                  ],
                ),
              ),
              16.height,
              Scrollbar(
                controller: controller,
                child: SingleChildScrollView(
                  controller: controller,
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: BaseContainerV2(
                      child: DataTable(
                        headingRowHeight: 35,
                        border: TableBorder(borderRadius: 32.radius),
                        headingRowColor:
                            WidgetStateProperty.all(AppColors.bg_tertiary),
                        columns: [
                          DataColumn(
                            label: Text(
                              'Lô',
                              style: p6.copyWith(
                                color: AppColors.text_tertiary,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Hạn sử dụng',
                              style: p6.copyWith(
                                color: AppColors.text_tertiary,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Trạng thái',
                              style: p6.copyWith(
                                color: AppColors.text_tertiary,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Tồn kho',
                              style: p6.copyWith(
                                color: AppColors.text_tertiary,
                              ),
                            ),
                          ),
                        ],
                        rows: bloc.state.listProductShipments != null
                            ? bloc.state.listProductShipments!.map((item) {
                                return DataRow(
                                  cells: [
                                    DataCell(Text(item.id.toString())),
                                    DataCell(Text(item.endDate.toText())),
                                    DataCell(
                                      BaseContainerV2(
                                        borderRadius: 999,
                                        borderColor: getTextColor(item.status),
                                        color: getTextColor(item.status)
                                            ?.withOpacity(0.2),
                                        padding: 8.padingHor + 4.padingVer,
                                        child: Text(
                                          item.statusLabel ?? '',
                                          style: p6.copyWith(
                                            color: getTextColor(item.status),
                                            height: 1,
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(Text(
                                        FormatCurrency(item.quantity ?? 0))),
                                  ],
                                );
                              }).toList()
                            : [],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Color? getTextColor(num? code) {
  if (code == 0) {
    return AppColors.ultility_brand_60;
  }
  if (code == 1) {
    return AppColors.ultility_carrot_60;
  }
  if (code == 2) {
    return AppColors.ultility_negative_60;
  }

  return AppColors.ultility_brand_60;
}
