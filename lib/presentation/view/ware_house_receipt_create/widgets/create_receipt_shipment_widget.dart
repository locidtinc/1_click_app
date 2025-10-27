import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:one_click/data/models/receipt_import_detail_model.dart';
import 'package:one_click/domain/entity/variant_entity.dart';
import 'package:one_click/presentation/base/base_container.dart';
import 'package:one_click/presentation/base/dotted_border_button.dart';
import 'package:one_click/presentation/base/input_column.dart';
import 'package:one_click/presentation/base/overlay_input.dart';
import 'package:one_click/presentation/base/select.dart';
import 'package:one_click/presentation/config/app_style/init_app_style.dart';
import 'package:one_click/presentation/config/bloc/bloc_status.dart';
import 'package:one_click/presentation/shared_view/widget/cache_image.dart';
import 'package:one_click/presentation/view/ware_house_receipt_create/cubit/create_warehouse_receipt_cubit.dart';
import 'package:one_click/presentation/view/ware_house_receipt_create/cubit/create_warehouse_receipt_state.dart';
import 'package:one_click/presentation/view/ware_house_receipt_create/widgets/scan_page.dart';
import 'package:one_click/presentation/view/ware_house_receipt_create/widgets/scan_view.dart';
import 'package:one_click/shared/ext/index.dart';
import 'package:one_click/shared/utils/event.dart';

class CreateReceiptShipmentWidget extends StatefulWidget {
  const CreateReceiptShipmentWidget({
    super.key,
    required this.bloc,
    required this.shipmentKey,
  });
  final CreateWarehouseReceiptCubit bloc;
  final GlobalKey<FormState> shipmentKey;

  @override
  State<CreateReceiptShipmentWidget> createState() =>
      _CreateReceiptShipmentWidgetState();
}

class _CreateReceiptShipmentWidgetState
    extends State<CreateReceiptShipmentWidget>
    with AutomaticKeepAliveClientMixin {
  final lotPriceCtrl = TextEditingController();
  @override
  void initState() {
    super.initState();
    if (widget.bloc.state.listShipment.isEmpty) {
      widget.bloc.addLot();
    }
  }

  @override
  void dispose() {
    lotPriceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final bloc = widget.bloc;
    return BlocConsumer<CreateWarehouseReceiptCubit,
        CreateWarehouseReceiptState>(
      listener: (context, state) {
        if (state.status == BlocStatus.submitSuccess) {
          // lotPriceCtrl.clear();
        } else if (state.status == BlocStatus.reload) {
          bloc.totalPrice(state.listShipment);
          lotPriceCtrl.text = bloc.state.totalPrice.toString();
        }
        // lotPriceCtrl.text = bloc.totalPrice.formatCurrency;
      },
      builder: (context, state) {
        return Form(
          key: widget.shipmentKey,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InputColumn(
                  controller: lotPriceCtrl,
                  // initialValue: FormatCurrency(bloc.state.totalPrice),
                  inputFormatters: [
                    CurrencyTextInputFormatter.currency(
                      locale: 'vi',
                      symbol: '',
                    ),
                  ],
                  fillColor: AppColors.white,
                  prefixIcon: _moneyPrefix(),
                  padding: 0.pading,
                  maxLength: 30,
                  label: 'Giá trị phiếu nhập',
                  isRequired: true,
                  onChanged: (val) {
                    bloc.updateTotalPrice(num.tryParse(val.removeAllDot()));
                  },
                ),
                16.height,
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final shipment = bloc.state.listShipment[index];
                    return ShipmentInfor(
                      shipment: shipment,
                      index: index,
                      bloc: bloc,
                    );
                  },
                  separatorBuilder: (context, index) => 16.height,
                  itemCount: bloc.state.listShipment.length,
                ),
                16.height,
                UploadButton(
                  preIcon: const Icon(
                    Icons.add,
                    color: Colors.blue,
                  ),
                  title: 'Thêm lô',
                  onTap: () {
                    DialogUtils.showErrorDialog(
                      context,
                      content: 'Bạn có muốm thêm mới lô không?',
                      accept: () {
                        context.router.pop();
                        bloc.addLot();
                      },
                      close: () => context.router.pop(),
                    );
                  },
                ),
              ],
            ).padding(16.pading),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class ShipmentInfor extends StatefulWidget {
  const ShipmentInfor({
    super.key,
    required this.shipment,
    required this.index,
    required this.bloc,
  });
  final ReceiptImportDetailModel shipment;
  final int index;
  final CreateWarehouseReceiptCubit bloc;

  @override
  State<ShipmentInfor> createState() => _ShipmentInforState();
}

class _ShipmentInforState extends State<ShipmentInfor> {
  final textCtrl = TextEditingController();
  late TextEditingController startDateController;
  late TextEditingController endDateController;
  late TextEditingController shipmentPriceController;

  @override
  void initState() {
    super.initState();
    startDateController = TextEditingController(
      text: widget.shipment.startDate.toTextDefaulft,
    );
    endDateController = TextEditingController(
      text: widget.shipment.endDate.toTextDefaulft,
    );
    shipmentPriceController = TextEditingController(
      text: widget.shipment.variantData?.shipmentPrice?.toString() ?? '0',
    );
  }

  @override
  void dispose() {
    textCtrl.dispose();
    startDateController.dispose();
    endDateController.dispose();
    shipmentPriceController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ShipmentInfor oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.shipment.startDate != oldWidget.shipment.startDate) {
        startDateController.text = widget.shipment.startDate.toTextDefaulft;
        endDateController.text = widget.shipment.endDate.toTextDefaulft;
      }
      if (widget.shipment.endDate != oldWidget.shipment.endDate) {
        endDateController.text = widget.shipment.endDate.toTextDefaulft;
      }
      if (widget.shipment.variantData?.inputPrice !=
              oldWidget.shipment.variantData?.inputPrice ||
          widget.shipment.variantData?.inputQuantity !=
              oldWidget.shipment.variantData?.inputQuantity) {
        shipmentPriceController.text =
            widget.shipment.variantData?.shipmentPrice.toString() ?? '0';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = widget.bloc;
    final shipment = widget.shipment;
    return BaseContainerV2(
      padding: 16.pading,
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Lô hàng ${widget.index + 1}',
                style: h3,
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  // bloc.updateShipment(
                  //   widget.index,
                  //   isShow: !(shipment.isExpand),
                  // );
                },
                child: Icon(
                  shipment.isExpand == true
                      ? Icons.keyboard_arrow_down_sharp
                      : Icons.keyboard_arrow_up,
                ),
              ),
              8.width,
              GestureDetector(
                onTap: () {
                  DialogUtils.showErrorDialog(
                    context,
                    content: 'Bạn có muốn xoá lô không?',
                    accept: () {
                      context.router.pop();
                      bloc.deleteShipment(widget.index);
                    },
                    close: () => context.router.pop(),
                  );
                },
                child: const Icon(
                  Icons.delete_outline,
                  color: AppColors.text_tertiary,
                ),
              ),
            ],
          ),
          Visibility(
            visible: shipment.isExpand,
            child: Column(
              children: [
                Visibility(
                  // visible: false,
                  child: InputColumn(
                    initialValue: shipment.code,
                    label: 'Mã lô',
                    isRequired: true,
                    onChanged: (value) {
                      bloc.updateShipment(widget.index, shipmentCode: value);
                    },
                  ),
                ),
                8.height,
                Row(
                  children: [
                    InputColumn(
                      key: UniqueKey(),
                      controller: startDateController,
                      readOnly: true,
                      label: 'Ngày sản xuất',
                      isRequired: true,
                      padding: 0.pading,
                      maxLength: 30,
                      onTap: () {
                        final date = shipment.startDate;
                        showDatePicker(
                          context: context,
                          initialDate: date,
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100),
                          locale: const Locale('vi'),
                        ).then((value) {
                          if (value != null) {
                            bloc.updateShipment(
                              widget.index,
                              startDate: value,
                              endDate: shipment.endDate ??
                                  value.add(const Duration(days: 365 * 3)),
                            );
                          }
                        });
                      },
                      suffixIcon: const SizedBox(
                        width: 48,
                        height: 48,
                        child:
                            Center(child: Icon(Icons.calendar_month_outlined)),
                      ),
                      validate: (value) {
                        if (value == null || value == '') {
                          return 'Nhập ngày sản xuất';
                        }
                        return null;
                      },
                    ).expanded(),
                    16.width,
                    InputColumn(
                      key: UniqueKey(),
                      controller: endDateController,
                      readOnly: true,
                      label: 'Hạn sử dụng',
                      padding: 0.pading,
                      maxLength: 30,
                      isRequired: true,
                      onTap: () {
                        // final date = inputDateCtrl.text.toDateV2;
                        showDatePicker(
                          context: context,
                          initialDate: shipment.endDate,
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100),
                          locale: const Locale('vi'),
                        ).then((value) {
                          if (value != null) {
                            bloc.updateShipment(widget.index, endDate: value);
                          }
                        });
                      },
                      suffixIcon: const SizedBox(
                        width: 48,
                        height: 48,
                        child:
                            Center(child: Icon(Icons.calendar_month_outlined)),
                      ),
                      validate: (value) {
                        if (value == null || value == '') {
                          return 'Nhập hạn sử dụng';
                        }
                        return null;
                      },
                    ).expanded(),
                  ],
                ),
                16.height,
                if (shipment.variantData == null)
                  Row(
                    children: [
                      OverlayInput<VariantEntity>(
                        itemBuilder: (context, item, index) {
                          return Row(
                            children: [
                              Row(
                                children: [
                                  BaseCacheImage(
                                    url: item.image,
                                    width: 56,
                                    height: 56,
                                    fit: BoxFit.cover,
                                  ).padding(8.padingHor),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    item.title,
                                    maxLines: 2,
                                    style: p6,
                                  ),
                                  Text(
                                    item.code,
                                    style: p6.copyWith(
                                      color: AppColors.text_tertiary,
                                    ),
                                  ),
                                ],
                              ).expanded(),
                            ],
                          );
                        },
                        onChanged: (item) {
                          bloc.addProd(widget.index, item);
                        },
                        hintText: 'Tìm tên, mã sản phẩm',
                        itemHeight: 65,
                        lazyLoad: (isMore) => bloc.getListVariant(
                          textCtrl.text,
                          isMore: isMore,
                        ),
                        controller: textCtrl,
                        borderRadius: 999,
                        header: Text(
                          'Chọn sản phẩm',
                          style: AppStyle.headingMd.copyWith(
                            color: AppColors.text_quaternary,
                          ),
                        ).padding(16.pading.copyWith(top: 12, bottom: 6)),
                        elevation: 1,
                        prefix: Padding(
                          padding: 1.pading.copyWith(right: 8),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: AppColors.bg_secondary,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(999),
                                bottomLeft: Radius.circular(999),
                              ),
                            ),
                            height: 30,
                            width: 30,
                            alignment: Alignment.center,
                            child: const BaseContainerV2(
                              borderRadius: 999,
                              borderColor: AppColors.greyF5,
                              color: AppColors.greyF5,
                              width: 40,
                              height: 40,
                              child: Icon(
                                Icons.inventory_2_outlined,
                                color: greyColor,
                                size: 24,
                              ),
                            ),
                          ),
                        ),

                        //  InkWell(
                        //   onTap: () {
                        //     context.push(
                        //       ScanPage(
                        //         onScan: (type, value) async {
                        //           if (type == TypeScanView.barcode) {
                        //             // final res = await widget.bloc.getListWarehouseProduct(value);
                        //             // if (res.isNotEmpty) {
                        //             //   bloc.addProd(
                        //             //     widget.index,
                        //             //     res.firstOrNull,
                        //             //   );
                        //             // } else
                        //             {
                        //               ScaffoldMessenger.of(context).showSnackBar(
                        //                 SnackBar(
                        //                   content: const Text(
                        //                     'Sản phẩm không tồn tại',
                        //                   ),
                        //                   backgroundColor: AppColors.ultility_positive_60,
                        //                   duration: 2.seconds,
                        //                 ),
                        //               );
                        //             }
                        //           }
                        //         },
                        //       ),
                        //     );
                        //   },
                        //   child: Row(
                        //     mainAxisSize: MainAxisSize.min,
                        //     mainAxisAlignment: MainAxisAlignment.start,
                        //     children: [
                        //       Padding(
                        //         padding: 1.pading.copyWith(right: 0),
                        //         child: Container(
                        //           decoration: const BoxDecoration(
                        //             color: AppColors.bg_secondary,
                        //             borderRadius: BorderRadius.only(
                        //               topLeft: Radius.circular(999),
                        //               bottomLeft: Radius.circular(999),
                        //             ),
                        //           ),
                        //           height: 48,
                        //           width: 48,
                        //           alignment: Alignment.center,
                        //           child: SvgPicture.asset(
                        //             '${AssetsPath.icon}/ic_scan_btn.svg',
                        //           ),
                        //         ),
                        //       ),
                        //       const VerticalDivider(
                        //         color: AppColors.input_borderDefault,
                        //         thickness: 1,
                        //         width: 0,
                        //       ).size(height: 48),
                        //       8.width,
                        //       const Icon(
                        //         Icons.search,
                        //         color: AppColors.input_iconDefault,
                        //       ),
                        //       4.width,
                        //     ],
                        //   ),
                        // ),
                      ).expanded(),
                      16.width,
                      // const BaseContainerV2(
                      //   borderRadius: 999,
                      //   borderColor: AppColors.greyF5,
                      //   color: AppColors.greyF5,
                      //   width: 40,
                      //   height: 40,
                      //   child: Icon(
                      //     Icons.add,
                      //     size: 30,
                      //   ),
                      // ),
                    ],
                  )
                else
                  _productInfor(
                    widget.index,
                    shipment.variantData,
                    shipmentPriceController,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _productInfor(int shipmentIndex, VariantEntity? item,
      TextEditingController shipmentPriceController) {
    final bloc = widget.bloc;
    return BaseContainerV2(
      padding: 8.pading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              BaseCacheImage(
                url: item?.image ?? '',
                width: 43,
                height: 43,
              ),
              8.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item?.title ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.clip,
                    style: p6,
                  ),
                  Text(
                    item?.code ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    style: p7.copyWith(color: AppColors.grey79),
                  ),
                ],
              ).expanded(),
              GestureDetector(
                onTap: () {
                  DialogUtils.showErrorDialog(
                    titleClose: 'Huỷ bỏ',
                    context,
                    content: 'Bạn có muốn xoá sản phẩm này?',
                    accept: () {
                      context.router.pop();
                      bloc.updateShipment(widget.index, isDelete: true);
                    },
                    close: () => context.router.pop(),
                  );
                },
                child: const Icon(
                  Icons.cancel,
                  color: AppColors.bg_disable,
                ),
              ),
            ],
          ),
          16.height,
          BaseContainerV2(
            color: AppColors.bg_primary_hover,
            borderColor: AppColors.bg_primary_hover,
            padding: 8.pading,
            child: Column(
              children: [
                Row(
                  children: [
                    InputColumn(
                      initialValue: FormatCurrency(item?.inputQuantity),
                      inputFormatters: [
                        CurrencyTextInputFormatter.currency(
                          locale: 'vi',
                          symbol: '',
                        ),
                      ],
                      textInputType: TextInputType.number,
                      fillColor: AppColors.white,
                      label: 'Số lượng nhập',
                      isRequired: true,
                      padding: 0.pading,
                      maxLength: 30,
                      onChanged: (val) {
                        final value = int.tryParse(val.removeAllDot()) ?? 0;
                        bloc.updateShipment(
                          shipmentIndex,
                          inputQuantity: value,
                        );
                      },
                      validate: (value) {
                        if (value == null || value == '') {
                          return 'Nhập số lượng';
                        } else if ((double.tryParse(value) ?? 0) <= 0) {
                          return 'Số lượng >0';
                        }
                        return null;
                      },
                    ).expanded(flex: 2),
                    8.width,
                    CommonDropdown(
                      showIconRemove: false,
                      value: item?.unit.firstOrNull,
                      radius: 8,
                      borderColor: AppColors.border_primary,
                      items: List.generate(
                        item?.unit.length ?? 0,
                        (index) => DropdownMenuItem(
                          value: item?.unit[index],
                          child: Text(
                            item?.unit[index].title ?? '',
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        bloc.updateShipment(shipmentIndex, unit: value);
                      },
                      required: true,
                      label: 'Đơn vị',
                      hintText: 'Chọn đơn vị',
                      color: AppColors.white,
                    ).flexible(),
                  ],
                ),
                16.height,
                InputColumn(
                  initialValue: FormatCurrency(item?.inputPrice),
                  inputFormatters: [
                    CurrencyTextInputFormatter.currency(
                      locale: 'vi',
                      symbol: '',
                    ),
                  ],
                  textInputType: TextInputType.number,
                  fillColor: AppColors.white,
                  prefixIcon: _moneyPrefix(),
                  label: 'Đơn giá nhập',
                  isRequired: true,
                  padding: 0.pading,
                  maxLength: 30,
                  onChanged: (val) {
                    final value = int.tryParse(val.removeAllDot()) ?? 0;
                    bloc.updateShipment(
                      shipmentIndex,
                      inputPrice: value,
                    );
                  },
                  validate: (value) {
                    if (value == null || value == '') {
                      return 'Nhập đơn giá';
                    } else if ((double.tryParse(value) ?? 0) <= 0) {
                      return 'Đơn giá > 0';
                    }
                    return null;
                  },
                ),
                16.height,
                InputColumn(
                  controller: shipmentPriceController,
                  // initialValue: FormatCurrency(item?.shipmentPrice),
                  inputFormatters: [
                    CurrencyTextInputFormatter.currency(
                      locale: 'vi',
                      symbol: '',
                    ),
                  ],
                  textInputType: TextInputType.number,
                  fillColor: AppColors.white,
                  prefixIcon: _moneyPrefix(),
                  label: 'Giá trị lô hàng',
                  padding: 0.pading,
                  readOnly: true,
                  maxLength: 30,
                  onChanged: (val) {
                    final value = int.tryParse(val.removeAllDot()) ?? 0;
                    bloc.updateShipment(
                      shipmentIndex,
                      shipmentPrice: value,
                    );
                  },
                ),
                16.height,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Container _moneyPrefix() {
  return Container(
    height: 48,
    width: 48,
    child: Center(
      child: Text(
        'đ',
        style: p4.copyWith(
          decoration: TextDecoration.underline,
        ),
      ),
    ),
  );
}
