import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_click/domain/entity/customer.dart';
import 'package:one_click/domain/entity/order_preview.dart';
import 'package:one_click/domain/entity/qr_code_payment.dart';
import 'package:one_click/presentation/base/app_bar.dart';
import 'package:one_click/presentation/config/app_style/init_app_style.dart';
import 'package:one_click/presentation/di/di.dart';
import 'package:one_click/presentation/routers/router.gr.dart';
import 'package:one_click/presentation/shared_view/card/variant_create_order_card.dart';
import 'package:one_click/presentation/shared_view/card/variant_create_order_confirm_card.dart';
import 'package:one_click/presentation/shared_view/widget/chip_custom.dart';
import 'package:one_click/presentation/shared_view/widget/row_item.dart';
import 'package:one_click/presentation/view/card_bank/cubit/card_bank_cubit.dart';
import 'package:one_click/presentation/view/customer_create/customer_create_popup.dart';
import 'package:one_click/presentation/view/home/cubit/home_cubit.dart';
import 'package:one_click/presentation/view/order_create/cubit/order_create_cubit.dart';
import 'package:one_click/presentation/view/order_create/cubit/order_create_state.dart';
import 'package:one_click/presentation/view/order_create/widgets/confirm_payment.dart';
import 'package:one_click/presentation/view/order_create/widgets/select_customer.dart';
import 'package:one_click/presentation/view/order_manager/child/all_order/cubit/all_order_cubit.dart';
import 'package:one_click/presentation/view/variant_detail_mykiot/cubit/variant_detail_mykiot_cubit.dart';
import 'package:one_click/shared/ext/index.dart';

import '../../../domain/entity/variant_create_order.dart';
import '../../../shared/utils/event.dart';

@RoutePage()
class OrderCreateConfirmPage extends StatelessWidget {
  OrderCreateConfirmPage({
    super.key,
    required this.orderCreateCubit,
    this.isOnline,
  });
  final bool? isOnline;
  final OrderCreateCubit orderCreateCubit;
  final InfiniteListController<AllOrderCubit> infiniteListController =
      InfiniteListController<AllOrderCubit>.init();
  final customerController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: bg_4,
        appBar: const BaseAppBar(title: 'Xác nhận đơn hàng'),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: sp24),
          height: heightDevice(context),
          width: widthDevice(context),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: sp16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BaseContainer(
                        context,
                        Padding(
                          padding: const EdgeInsets.all(sp8),
                          child:
                              BlocBuilder<OrderCreateCubit, OrderCreateState>(
                            bloc: orderCreateCubit,
                            builder: (context, state) {
                              return state.typeOrder == TypeOrder.cHTH
                                  ? Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: SelectCustomer(
                                                label: 'Khách hàng',
                                                controller: customerController,
                                                hintText: 'Chọn khách hàng',
                                                selectedCustomer:
                                                    state.selectedCustomer,
                                                itemBuilder:
                                                    (context, item, index) {
                                                  return ListTile(
                                                    title: Text(
                                                        '${item.fullName}'),
                                                    subtitle:
                                                        Text('${item.phone}'),
                                                  );
                                                },
                                                listItem: state.listCustomer,
                                                onSelect: (item) =>
                                                    orderCreateCubit
                                                        .customerChange(
                                                  item.id ?? 0,
                                                ),
                                                isLoadingInit:
                                                    state.loadingInit,
                                              ),
                                            ),
                                            const SizedBox(width: sp16),
                                            GestureDetector(
                                              onTap: () => showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    CustomerCreatePopup(
                                                  value:
                                                      customerController.text,
                                                  onConfirm: (CustomerEntity?
                                                      customer) async {
                                                    if (customer != null) {
                                                      await orderCreateCubit
                                                          .getListCustomer();
                                                      orderCreateCubit
                                                          .customerChange(
                                                              customer.id ?? 0);
                                                    }
                                                  },
                                                ),
                                              ),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    sp8,
                                                  ),
                                                  color: mainColor,
                                                ),
                                                width: 48,
                                                child: const AspectRatio(
                                                  aspectRatio: 1,
                                                  child: Icon(
                                                    Icons.add,
                                                    size: sp16,
                                                    color: whiteColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  // CommonDropdown(
                                  //     items: state.listCustomerDropdown,
                                  //     hintText: 'Chọn khách hàng',
                                  //     label: 'Khách hàng',
                                  //     onChanged: (id) =>
                                  //         orderCreateCubit.customerChange(id),
                                  //   )
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // CommonDropdown(
                                        //   items: state.listCustomerDropdown,
                                        //   hintText: 'Chọn nhà cung cấp',
                                        //   label: 'Nhà cung cấp',
                                        //   onChanged: (id) => orderCreateCubit
                                        //       .customerChange(id),
                                        // ),
                                        AppInput(
                                          label: 'Nhà cung cấp',
                                          controller: TextEditingController(
                                            text: 'MyKios',
                                          ),
                                          readOnly: true,
                                          hintText: 'hintText',
                                          validate: (value) {},
                                        ),
                                        const SizedBox(height: sp16),
                                        RowItem(
                                          title: 'Giảm giá',
                                          content:
                                              '${FormatCurrency(state.totalPriceDefault - state.totalPrice)}đ',
                                        ),
                                        const SizedBox(height: sp12),
                                        RowItem(
                                          title: 'Tổng tiền',
                                          content:
                                              '${FormatCurrency(state.totalPrice)}đ',
                                          contetnColor: mainColor,
                                        ),
                                      ],
                                    );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: sp16),
                      BaseContainer(
                        context,
                        Padding(
                          padding: const EdgeInsets.all(sp8),
                          child: AppInput(
                            label: 'Thêm ghi chú',
                            hintText: 'Nhập ghi chú',
                            validate: (value) {},
                            onChanged: (value) =>
                                orderCreateCubit.noteChange(value),
                          ),
                        ),
                      ),
                      const SizedBox(height: sp12),
                      Row(
                        children: [
                          Text(
                            'Sản phẩm đã chọn',
                            style: p1.copyWith(color: blackColor),
                          ).expanded(),
                          TextButton.icon(
                            onPressed: () {
                              context.router.popUntil(
                                (route) =>
                                    route.settings.name ==
                                    OrderCreateRoute.name,
                              );
                            },
                            label: Text(
                              'Thêm mới sản phẩm',
                              style: p5.copyWith(),
                            ),
                            icon: const Icon(
                              Icons.add_circle_outline,
                              size: sp20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: sp12,
                ),
                BlocBuilder<OrderCreateCubit, OrderCreateState>(
                  bloc: orderCreateCubit,
                  builder: (context, state) {
                    final listVariant = state.listVariantSelect;
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final variant = listVariant[index];
                        return state.typeOrder == TypeOrder.cHTH
                            ? VariantCreateOrderConfirmCard(
                                key: ValueKey(variant.id),
                                variant: variant,
                                quantityChange: (variant, value) =>
                                    orderCreateCubit.changeAmount(
                                  variant,
                                  value,
                                ),
                                toggleCheckbox: (bool? value) =>
                                    orderCreateCubit.checkboxToggle(variant),
                                priceSellChange: (
                                  VariantCreateOrderEntity variant,
                                  String value,
                                ) =>
                                    orderCreateCubit.priceChange(
                                  variant,
                                  value,
                                ),
                              )
                            : VariantCreateOrderCard(
                                // amountTec: TextEditingController(
                                //   text: variant.amount.toString(),
                                // ),
                                toggleCheckbox: (bool? value) =>
                                    orderCreateCubit.checkboxToggle(variant),
                                variant: variant,
                                quantityChange: (variant, value) =>
                                    orderCreateCubit.changeAmount(
                                  variant,
                                  value,
                                ),
                              );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: sp16),
                      itemCount: listVariant.length,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          color: whiteColor,
          padding: const EdgeInsets.symmetric(vertical: sp24, horizontal: sp16),
          child: BlocBuilder<OrderCreateCubit, OrderCreateState>(
            bloc: orderCreateCubit,
            builder: (context, state) {
              return state.typeOrder == TypeOrder.cHTH
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Tổng tiền',
                              style: p4.copyWith(color: greyColor),
                            ),
                            BlocBuilder<OrderCreateCubit, OrderCreateState>(
                              bloc: orderCreateCubit,
                              builder: (context, state) {
                                return Text(
                                  '${FormatCurrency(state.totalPrice)}đ',
                                  style: p3.copyWith(color: mainColor),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: sp24),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Extrabutton(
                                title: 'Lưu nháp',
                                event: () => createDrafOrderEvent(context),
                                largeButton: true,
                                borderColor: borderColor_2,
                                icon: null,
                              ),
                            ),
                            const SizedBox(width: sp16),
                            Expanded(
                              child: MainButton(
                                title: 'Thanh toán',
                                event: () {
                                  // if (state.selectedCustomer != null) {
                                  payment(context);
                                  // } else {
                                  //   DialogUtils.showErrorDialog(context, content: 'Chưa nhập khách hàng');
                                  // }
                                },
                                largeButton: true,
                                icon: null,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : SizedBox(
                      width: double.infinity,
                      child: MainButton(
                        title: 'Xác nhận đặt hàng',
                        event: () => createOrderEvent(
                          context,
                          TypePayment.cash,
                        ),
                        largeButton: true,
                        icon: null,
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }

  /// Before create Order, user must chose type payment [TypePayment]
  void payment(BuildContext _) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: _,
      builder: (context) => ConfirmPaymentBts(
        onConfirm: (TypePayment typePayment) => createOrderEvent(
          context,
          typePayment,
        ),
        totalPrice: orderCreateCubit.state.totalPrice,
      ),
    );
  }

  /// create order by post API
  Future<void> createOrderEvent(
    BuildContext context,
    TypePayment typePayment,
  ) async {
    final blocAllOder = getIt.get<AllOrderCubit>();
    final myBloc = getIt.get<HomeCubit>();
    orderCreateCubit.validateCreateOrder();
    if (orderCreateCubit.state.failureCreateOrder != null) {
      DialogUtils.showErrorDialog(
        context,
        content: orderCreateCubit.state.failureCreateOrder?.errMsg ?? '',
      );
      return;
    }

    DialogUtils.showLoadingDialog(
      context,
      content: 'Đang tạo đơn vui lòng đợi',
    );
    final res = await orderCreateCubit.createOrder(isOnline);

    QrCodePayment? resPayment;

    if (typePayment == TypePayment.qrCode) {
      resPayment = await orderCreateCubit.qrCodePayment();
      if (resPayment == null && context.mounted) {
        Navigator.of(context).pop();
        DialogUtils.showErrorDialog(
          context,
          content: 'Đơn hàng được tạo thành công\nLỗi tạo QrCode',
        );
        return;
      }
    }
    if (context.mounted) {
      Navigator.of(context).pop();
    }
    if (res.response.code == 200 && context.mounted) {
      //infiniteListController
      Future.delayed(const Duration(milliseconds: 100), () {
        infiniteListController.onRefresh();
      });
      context.router.popUntil(
        (route) =>
            route.settings.name ==
            (orderCreateCubit.state.typeOrder == TypeOrder.cHTH
                ? 'OrderManagerRoute'
                : 'OrderImportRoute'),
      );
      if (typePayment == TypePayment.qrCode) {
        final card = await getIt.get<CardBankCubit>().getCard();
        context.router.push(
          QrCodePaymentRoute(
            qrcodeInfo: resPayment,
            cardEntity: card,
            orderDetailEntity: res.response.data!,
            onConfirm: () => orderCreateCubit.updatePayment(context),
          ),
        );
      } else {
        context.router.push(
          OrderDetailRoute(
            order: res.response.data!,
            typeOrder: orderCreateCubit.state.typeOrder,
          ),
        );
      }
      myBloc.getDailyOrder();
    } else {
      DialogUtils.showErrorDialog(
        context,
        content: 'Tạo đơn hàng thất bại, vui lòng kiểm tra tồn kho',
      );
    }
  }

  /// create draf order save to shared
  void createDrafOrderEvent(BuildContext context) async {
    final res = orderCreateCubit.createOrderDraf();
    context.router.popUntil(
      (route) =>
          route.settings.name ==
          (orderCreateCubit.state.typeOrder == TypeOrder.cHTH
              ? 'OrderManagerRoute'
              : 'OrderImportRoute'),
    );
    context.router.push(
      OrderDetailRoute(
        order: res,
        typeOrder: orderCreateCubit.state.typeOrder,
      ),
    );
  }
}

class CustomerSelectItem extends StatelessWidget {
  const CustomerSelectItem({
    super.key,
    required this.isSelected,
    required this.model,
  });

  final bool isSelected;
  final CustomerEntity model;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: 16.pading,
      margin: 8.padingHor,
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.dropdown_backgroundActive
            : AppColors.bg_primary,
        borderRadius: 6.radius,
      ),
      child: Row(
        children: [
          // const AvatarCustom(url: ''),
          12.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                model.fullName ?? 'Không có thông tin',
                overflow: TextOverflow.ellipsis,
                style: AppStyle.headingMd,
              ),
              Text(
                model.phone ?? 'Không có thông tin',
                style: AppStyle.bodyBsSemiBold
                    .copyWith(color: AppColors.text_tertiary),
              ),
            ],
          ).expanded(),
          if (isSelected)
            const Icon(
              Icons.check_circle,
              color: AppColors.fg_positive,
            ),
        ],
      ),
    );
  }
}
