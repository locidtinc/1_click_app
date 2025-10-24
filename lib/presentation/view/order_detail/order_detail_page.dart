import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:one_click/presentation/base/app_bar.dart';
import 'package:one_click/presentation/base/select.dart';
import 'package:one_click/presentation/di/di.dart';
import 'package:one_click/presentation/routers/router.gr.dart';
import 'package:one_click/presentation/shared_view/widget/cache_image.dart';
import 'package:one_click/presentation/shared_view/widget/row_item.dart';
import 'package:one_click/presentation/view/card_bank/cubit/card_bank_cubit.dart';
import 'package:one_click/presentation/view/order_create/cubit/order_create_cubit.dart';
import 'package:one_click/presentation/view/order_create/cubit/order_create_state.dart';
import 'package:one_click/shared/constants/enum/status_payment_order.dart';
import 'package:one_click/shared/constants/pref_keys.dart';
import 'package:one_click/shared/utils/event.dart';

import '../../../domain/entity/qr_code_payment.dart';
import '../order_create/widgets/confirm_payment.dart';
import 'cubit/order_detail_cubit.dart';
import 'cubit/order_detail_state.dart';
import 'widgets/info_customer.dart';
import 'widgets/status_order.dart';

@RoutePage()
class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({
    super.key,
    required this.order,
    required this.typeOrder,
    this.isDrafOrder = false,
    this.isNotiOder = false,
  });

  final dynamic order;
  final TypeOrder typeOrder;
  final bool isDrafOrder;
  final bool isNotiOder;

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  late OrderDetailCubit myBloc;
  late OrderCreateCubit orderCreateCubit;
  late CardBankCubit cardBankCubit;

  @override
  void initState() {
    super.initState();

    myBloc = getIt.get<OrderDetailCubit>();
    orderCreateCubit = getIt.get<OrderCreateCubit>();
    cardBankCubit = getIt.get<CardBankCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderDetailCubit>(
      create: (context) => myBloc
        ..initData(
          widget.order,
          widget.typeOrder,
          widget.isDrafOrder,
          isNotiOderdata: widget.isNotiOder,
        ),
      child: BlocBuilder<OrderDetailCubit, OrderDetailState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: bg_4,
            appBar: BaseAppBar(
              title: widget.typeOrder == TypeOrder.cHTH
                  ? 'Chi tiết đơn bán hàng'
                  : 'Chi tiết đơn đặt hàng',
              actions: [
                if (state.orderDetail?.orderStatus?.id ==
                    PrefKeys.idOrderDrafStatus)
                  GestureDetector(
                    onTap: () {},
                    child: SvgPicture.asset(
                      '${AssetsPath.icon}/ic_edit_order.svg',
                      width: sp16,
                    ),
                  ),
                const SizedBox(
                  width: sp16,
                ),
              ],
            ),
            body: Container(
              width: widthDevice(context),
              height: heightDevice(context),
              padding:
                  const EdgeInsets.symmetric(vertical: sp24, horizontal: sp16),
              child: BlocBuilder<OrderDetailCubit, OrderDetailState>(
                builder: (context, state) {
                  return state.isLoading
                      ? const Center(child: BaseLoading())
                      : SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BlocBuilder<OrderDetailCubit, OrderDetailState>(
                                builder: (context, state) {
                                  return BaseContainer(
                                    context,
                                    Padding(
                                      padding: const EdgeInsets.all(sp8),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                state.orderDetail?.code ?? '',
                                                style: p3.copyWith(
                                                  color: blackColor,
                                                ),
                                              ),
                                              StatusOrderCard(
                                                id: state.orderDetail
                                                        ?.orderStatus?.id ??
                                                    0,
                                                typeOrder: state.typeOrder,
                                                title: state.orderDetail
                                                        ?.orderStatus?.title ??
                                                    '',
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: sp16),
                                          const Divider(
                                            height: 1,
                                          ),
                                          const SizedBox(height: sp16),
                                          state.typeOrder == TypeOrder.cHTH
                                              ? RowItem(
                                                  title: 'Loại đơn hàng',
                                                  content: state
                                                          .orderDetail!.isOnline
                                                      ? 'Online'
                                                      : 'Bán trực tiếp',
                                                )
                                              : const RowItem(
                                                  title: 'Nhà cung cấp',
                                                  content: 'MyKios',
                                                ),
                                          const SizedBox(height: sp12),
                                          RowItem(
                                            title: 'Thời gian',
                                            content:
                                                state.orderDetail!.createAt ??
                                                    '',
                                          ),
                                          const SizedBox(height: sp12),
                                          RowItem(
                                            title: 'Ghi chú',
                                            content: state.orderDetail!.note,
                                          ),
                                          Visibility(
                                            visible: state.orderDetail
                                                    ?.noteCancel.isNotEmpty ??
                                                false,
                                            child: Column(
                                              children: [
                                                const SizedBox(height: sp12),
                                                RowItem(
                                                  title: 'Lý do từ chối',
                                                  content: state
                                                      .orderDetail!.noteCancel,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              BlocBuilder<OrderDetailCubit, OrderDetailState>(
                                builder: (context, state) {
                                  return state.typeOrder == TypeOrder.cHTH
                                      ? Container(
                                          margin:
                                              const EdgeInsets.only(top: sp16),
                                          child: InfoCustomerCard(
                                            orderDetail: state.orderDetail,
                                          ),
                                        )
                                      : const SizedBox();
                                },
                              ),
                              const SizedBox(height: sp16),
                              BlocBuilder<OrderDetailCubit, OrderDetailState>(
                                builder: (context, state) {
                                  return BaseContainer(
                                    context,
                                    Padding(
                                      padding: const EdgeInsets.all(sp8),
                                      child: Column(
                                        children: [
                                          RowItem(
                                            title: 'Thành tiền',
                                            content:
                                                '${FormatCurrency(state.orderDetail?.total ?? 0)}đ',
                                          ),
                                          const SizedBox(
                                            height: sp12,
                                          ),
                                          RowItem(
                                            title: 'Giảm giá',
                                            content:
                                                '${FormatCurrency(state.orderDetail?.discount ?? 0)}đ',
                                          ),
                                          const SizedBox(
                                            height: sp12,
                                          ),
                                          RowItem(
                                            title: 'Tổng cộng',
                                            content:
                                                '${FormatCurrency((state.orderDetail?.total ?? 0) - (state.orderDetail?.discount ?? 0))}đ',
                                            contetnColor: mainColor,
                                          ),
                                          Visibility(
                                            visible: (state.typeOrder ==
                                                    TypeOrder.cHTH &&
                                                state.orderDetail?.isOnline ==
                                                    false),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                const SizedBox(
                                                  height: sp12,
                                                  width: double.infinity,
                                                ),
                                                Text(
                                                  state
                                                          .orderDetail
                                                          ?.statusPayment
                                                          .title ??
                                                      '',
                                                  style: p7.copyWith(
                                                    color: state.orderDetail
                                                        ?.statusPayment.color,
                                                  ),
                                                  textAlign: TextAlign.right,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: sp24),
                              Text(
                                'Danh sách sản phẩm trong đơn',
                                style: p1.copyWith(color: blackColor),
                              ),
                              const SizedBox(height: sp16),
                              BlocBuilder<OrderDetailCubit, OrderDetailState>(
                                builder: (context, state) {
                                  return ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      final variant =
                                          state.orderDetail?.variants[index];
                                      return GestureDetector(
                                        onTap: () => context.router.push(
                                          VariantDetailRoute(
                                            id: variant?.id ?? 0,
                                            onConfirm: () {
                                              myBloc.initData(
                                                widget.order,
                                                widget.typeOrder,
                                                widget.isDrafOrder,
                                              );
                                            },
                                          ),
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.all(sp24),
                                          width: widthDevice(context) - sp32,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(sp8),
                                            color: whiteColor,
                                            border: Border.all(
                                              color: state.orderDetail
                                                              ?.isOnline ==
                                                          true &&
                                                      state
                                                              .orderDetail
                                                              ?.orderStatus
                                                              ?.id ==
                                                          1 &&
                                                      (variant?.quantityInStock ??
                                                              0) <
                                                          (variant?.amount ?? 0)
                                                  ? red_1
                                                  : whiteColor,
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ListTile(
                                                contentPadding:
                                                    const EdgeInsets.all(sp0),
                                                leading: Container(
                                                  width: 56,
                                                  height: 56,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      sp8,
                                                    ),
                                                    border: Border.all(
                                                      color: borderColor_2,
                                                    ),
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      sp8,
                                                    ),
                                                    child: BaseCacheImage(
                                                      url: variant?.image ?? '',
                                                    ),
                                                  ),
                                                ),
                                                title: Text(
                                                  variant?.name ?? '',
                                                  style: p3.copyWith(
                                                    color: blackColor,
                                                  ),
                                                ),
                                                subtitle: Container(
                                                  margin: const EdgeInsets.only(
                                                    top: sp12,
                                                  ),
                                                  child: state.orderDetail
                                                                  ?.isOnline ==
                                                              true &&
                                                          state
                                                                  .orderDetail
                                                                  ?.orderStatus
                                                                  ?.id ==
                                                              1
                                                      ? RichText(
                                                          text: TextSpan(
                                                            style: p5.copyWith(
                                                              color: greyColor,
                                                            ),
                                                            text:
                                                                'Đang có: ${variant?.quantityInStock ?? '0'} ',
                                                            children: [
                                                              TextSpan(
                                                                style:
                                                                    p5.copyWith(
                                                                  color: red_1,
                                                                ),
                                                                text: (variant?.quantityInStock ??
                                                                            0) <
                                                                        (variant?.amount ??
                                                                            0)
                                                                    ? '(Không đủ hàng)'
                                                                    : '',
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      : Text(
                                                          'Mẫu mã: ${variant?.models ?? ''}',
                                                        ),
                                                ),
                                              ),
                                              const SizedBox(height: sp16),
                                              const Divider(height: 1),
                                              const SizedBox(height: sp16),
                                              RowItem(
                                                title: 'Số lượng',
                                                content: (variant?.amount ?? 0)
                                                    .toString(),
                                              ),
                                              const SizedBox(height: sp12),
                                              RowItem(
                                                title: 'Đơn giá',
                                                content:
                                                    '${FormatCurrency(variant?.priceSell ?? '0')}đ',
                                              ),
                                              const SizedBox(height: sp12),
                                              RowItem(
                                                title: 'Tổng tiền',
                                                content:
                                                    '${FormatCurrency((variant?.priceSell ?? 0) * (variant?.amount ?? 0))}đ',
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(height: sp16),
                                    itemCount:
                                        state.orderDetail?.variants.length ?? 0,
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                },
              ),
            ),
            bottomNavigationBar:
                BlocBuilder<OrderDetailCubit, OrderDetailState>(
              builder: (context, state) {
                return Container(
                  color: whiteColor,
                  padding: const EdgeInsets.all(sp16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (state.orderDetail?.orderStatus?.id == 4 &&
                          state.typeOrder == TypeOrder.cHTH &&
                          state.orderDetail?.statusPayment !=
                              StatusPayment.unpaid)
                        SizedBox(
                          width: double.infinity,
                          child: MainButton(
                            title: 'Xem hoá đơn',
                            event: () => context.router.push(
                              BillDetailRoute(
                                orderDetailEntity: state.orderDetail!,
                                typeOrder: state.typeOrder!,
                              ),
                            ),
                            largeButton: true,
                            icon: null,
                          ),
                        )
                      else if (state.orderDetail?.orderStatus?.id == 4 &&
                          state.typeOrder == TypeOrder.cHTH &&
                          state.orderDetail?.statusPayment ==
                              StatusPayment.unpaid &&
                          state.orderDetail?.isOnline == false)
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Extrabutton(
                                title: 'Xem hoá đơn',
                                event: () => context.router.push(
                                  BillDetailRoute(
                                    orderDetailEntity: state.orderDetail!,
                                    typeOrder: state.typeOrder!,
                                  ),
                                ),
                                largeButton: true,
                                borderColor: borderColor_2,
                                icon: null,
                              ),
                            ),
                            const SizedBox(width: sp16),
                            Expanded(
                              child: MainButton(
                                title: 'Xác nhận thanh toán',
                                event: () => confirmPayment(),
                                largeButton: true,
                                icon: null,
                              ),
                            ),
                          ],
                        )
                      else if (state.orderDetail?.orderStatus?.id ==
                          PrefKeys.idOrderDrafStatus)
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Extrabutton(
                                title: 'Xóa đơn',
                                event: () => _deleteOrderDraf(),
                                largeButton: true,
                                borderColor: borderColor_2,
                                icon: null,
                              ),
                            ),
                            const SizedBox(width: sp16),
                            Expanded(
                              child: MainButton(
                                title: 'Thanh toán',
                                event: () => _payment(context),
                                largeButton: true,
                                icon: null,
                              ),
                            ),
                          ],
                        )
                      else if ((state.orderDetail?.orderStatus?.id == 4 &&
                              state.typeOrder == TypeOrder.ad) ||
                          (state.orderDetail?.orderStatus?.id == 1 &&
                              state.typeOrder == TypeOrder.cHTH))
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Extrabutton(
                                title: 'Từ chối',
                                event: () => showPopupDeny(myBloc),
                                largeButton: true,
                                borderColor: borderColor_2,
                                icon: null,
                              ),
                            ),
                            const SizedBox(width: sp16),
                            Expanded(
                              child: MainButton(
                                title: 'Nhận hàng',
                                event: () => myBloc.onConfirmHandle(
                                  context,
                                  status:
                                      state.typeOrder == TypeOrder.ad ? 5 : 2,
                                ),
                                largeButton: true,
                                icon: null,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> confirmPayment() async {
    final card = await cardBankCubit.getCard();
    context.router.push(
      QrCodePaymentRoute(
        qrcodeInfo: myBloc.state.orderDetail!.qrCodePayment,
        cardEntity: card,
        orderDetailEntity: myBloc.state.orderDetail!,
        onConfirm: () {
          myBloc.updateStatus(4);
          context.router.push(
            OrderDetailRoute(
              order: myBloc.state.orderDetail!.id!,
              typeOrder: TypeOrder.cHTH,
            ),
          );
        },
      ),
    );
  }

  /// Before create Order, user must chose type payment [TypePayment]
  // void payment(BuildContext _) {
  //   showModalBottomSheet(
  //     isScrollControlled: true,
  //     context: _,
  //     builder: (context) => ConfirmPaymentBts(
  //       orderCreateCubit: orderCreateCubit,
  //       cardBankCubit: getIt.get<CardBankCubit>(),
  //       onConfirm: () => null,
  //     ),
  //   );
  // }

  void showPopupDeny(OrderDetailCubit myBloc) {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: Card(
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(
              sp16,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(sp16),
              color: whiteColor,
            ),
            width: widthDevice(context) - sp32,
            padding: const EdgeInsets.all(sp24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Lý do từ chối nhận hàng',
                  style: p1,
                ),
                const SizedBox(height: sp24),
                CommonDropdown(
                  label: 'Chọn lý do từ chối',
                  items: myBloc.listReaseon,
                  hintText: 'Nhập hoặc chọn lý do có sẵn',
                  onChanged: (value) => myBloc.reasonChange(value),
                ),
                BlocBuilder<OrderDetailCubit, OrderDetailState>(
                  bloc: myBloc,
                  builder: (context, state) {
                    return Visibility(
                      visible: state.idReasonDeny == 3,
                      child: Column(
                        children: [
                          const SizedBox(height: sp16),
                          AppInput(
                            label: 'Nhập lý do từ chối khác',
                            hintText: 'Nhập lý do',
                            validate: (value) {},
                            textInputType: TextInputType.text,
                            onChanged: (value) =>
                                myBloc.titleReasonChange(value),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: sp24),
                Row(
                  children: [
                    Expanded(
                      child: Extrabutton(
                        title: 'Huỷ bỏ',
                        event: () => Navigator.of(context).pop(),
                        largeButton: true,
                        borderColor: borderColor_2,
                        icon: null,
                      ),
                    ),
                    const SizedBox(width: sp16),
                    Expanded(
                      child: MainButton(
                        title: 'Xác nhận',
                        event: () {
                          Navigator.of(context).pop();
                          myBloc.cancelOrder(context);
                        },
                        largeButton: true,
                        icon: null,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _deleteOrderDraf() {
    myBloc.deleteOrderDraf();
    context.router
        .popUntil((route) => route.settings.name == 'OrderManagerRoute');
  }

  /// Before create Order, user must chose type payment [TypePayment]
  void _payment(BuildContext _) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: _,
      builder: (context) => ConfirmPaymentBts(
        onConfirm: (typePayment) => createOrderEvent(
          context,
          typePayment,
        ),
        totalPrice: myBloc.state.orderDetail?.total ?? 0,
      ),
    );
  }

  Future<void> createOrderEvent(
    BuildContext context,
    TypePayment typePayment,
  ) async {
    orderCreateCubit.updateOrderInfo(myBloc.state.orderDetail);

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
    final res = await orderCreateCubit.createOrder(false);

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
      context.router.popUntil(
        (route) =>
            route.settings.name ==
            (orderCreateCubit.state.typeOrder == TypeOrder.cHTH
                ? 'OrderManagerRoute'
                : 'OrderImportRoute'),
      );
      myBloc.deleteOrderDraf();
      if (typePayment == TypePayment.qrCode) {
        final card = await getIt.get<CardBankCubit>().getCard();
        context.router.push(
          QrCodePaymentRoute(
            qrcodeInfo: resPayment,
            cardEntity: card,
            orderDetailEntity: res.response.data!,
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
    } else {
      DialogUtils.showErrorDialog(
        context,
        content: 'Tạo đơn hàng thất bại, vui lòng kiểm tra tồn kho',
      );
    }
  }
}
