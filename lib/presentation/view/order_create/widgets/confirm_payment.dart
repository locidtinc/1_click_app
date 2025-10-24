import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:one_click/presentation/routers/router.gr.dart';
import 'package:one_click/presentation/view/card_bank/cubit/card_bank_cubit.dart';
import 'package:one_click/presentation/view/card_bank/cubit/card_bank_state.dart';
import 'package:one_click/presentation/view/order_create/cubit/order_create_state.dart';
import 'package:one_click/shared/constants/local_storage/app_shared_preference.dart';
import 'package:one_click/shared/constants/pref_keys.dart';

import '../../../../shared/utils/event.dart';
import '../../../di/di.dart';

class ConfirmPaymentBts extends StatefulWidget {
  const ConfirmPaymentBts({
    super.key,
    required this.onConfirm,
    required this.totalPrice,
    this.typePayment = TypePayment.cash,
  });

  final Function(TypePayment typePayment) onConfirm;
  final int totalPrice;
  final TypePayment typePayment;

  @override
  State<ConfirmPaymentBts> createState() => _ConfirmPaymentBtsState();
}

class _ConfirmPaymentBtsState extends State<ConfirmPaymentBts> {
  final cardCubit = getIt.get<CardBankCubit>();

  late TypePayment _typePayment;

  @override
  void initState() {
    super.initState();

    _typePayment = widget.typePayment;
  }

  void _typePaymentChange(TypePayment type) {
    setState(() {
      _typePayment = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      enableDrag: false,
      builder: (context) {
        return BlocProvider<CardBankCubit>(
          create: (context) => cardCubit
            ..getCard()
            ..getCardRemote(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                color: bg_4,
                padding: const EdgeInsets.symmetric(
                  vertical: sp16,
                  horizontal: sp16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Text(
                        'Đóng',
                        style: p5.copyWith(color: blue_1),
                      ),
                    ),
                    const Text('Xác nhận thanh toán', style: p3),
                    const SizedBox(width: sp32),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(sp16),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: borderColor_2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: bg_4,
                      padding: const EdgeInsets.symmetric(vertical: sp16),
                      width: double.infinity,
                      child: Column(
                        children: [
                          Text(
                            'Số tiền',
                            style: p6.copyWith(color: greyColor),
                          ),
                          const SizedBox(height: sp12),
                          Text(
                            '${FormatCurrency(widget.totalPrice)}đ',
                            style: h3.copyWith(color: mainColor),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: sp16),
                    const Text('Phương thức thanh toán', style: p6),
                    const SizedBox(height: sp16),
                    BlocBuilder<CardBankCubit, CardBankState>(
                      builder: (context, stateCard) {
                        final res = AppSharedPreference.instance
                            .getValue(PrefKeys.card);
                        return stateCard.isLoading
                            ? const BaseLoading()
                            : Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () =>
                                          _typePaymentChange(TypePayment.cash),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: sp16,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              _typePayment == TypePayment.cash
                                                  ? accentColor_4
                                                  : bg_4,
                                          borderRadius:
                                              BorderRadius.circular(sp8),
                                          border: Border.all(
                                            color:
                                                _typePayment == TypePayment.cash
                                                    ? mainColor
                                                    : bg_4,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              '${AssetsPath.icon}/ic_cash.svg',
                                              width: sp16,
                                              color: _typePayment ==
                                                      TypePayment.cash
                                                  ? mainColor
                                                  : blackColor,
                                            ),
                                            const SizedBox(width: sp8),
                                            Text(
                                              'Tiền mặt',
                                              style: _typePayment ==
                                                      TypePayment.cash
                                                  ? p5.copyWith(
                                                      color: mainColor,
                                                    )
                                                  : p6.copyWith(
                                                      color: blackColor,
                                                    ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: stateCard.cardEntity?.id != null
                                        ? true
                                        : false,
                                    child: const SizedBox(width: sp16),
                                  ),
                                  Visibility(
                                    visible: stateCard.cardEntity?.id != null
                                        ? true
                                        : false,
                                    child: Expanded(
                                      child: GestureDetector(
                                        onTap: () => _typePaymentChange(
                                          TypePayment.qrCode,
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: sp16,
                                          ),
                                          decoration: BoxDecoration(
                                            color: _typePayment ==
                                                    TypePayment.qrCode
                                                ? accentColor_4
                                                : bg_4,
                                            borderRadius:
                                                BorderRadius.circular(sp8),
                                            border: Border.all(
                                              color: _typePayment ==
                                                      TypePayment.qrCode
                                                  ? mainColor
                                                  : bg_4,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                '${AssetsPath.icon}/ic_qrcode.svg',
                                                width: sp16,
                                                color: _typePayment ==
                                                        TypePayment.qrCode
                                                    ? mainColor
                                                    : blackColor,
                                              ),
                                              const SizedBox(width: sp8),
                                              Text(
                                                'QR thanh toán',
                                                style: _typePayment ==
                                                        TypePayment.qrCode
                                                    ? p5.copyWith(
                                                        color: mainColor,
                                                      )
                                                    : p6.copyWith(
                                                        color: blackColor,
                                                      ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                      },
                    ),
                    BlocBuilder<CardBankCubit, CardBankState>(
                      builder: (context, state) {
                        return Visibility(
                          visible: state.cardEntity?.id == null ? true : false,
                          child: Column(
                            children: [
                              const SizedBox(height: sp16),
                              Container(
                                padding: const EdgeInsets.all(sp16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(sp8),
                                  color: bg_4,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.info_rounded,
                                      size: sp16,
                                      color: blue_1,
                                    ),
                                    const SizedBox(width: sp16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              text:
                                                  'Vui lòng thêm tài khoản ngân hàng để thêm phương thức',
                                              style: p6.copyWith(
                                                color: blackColor,
                                              ),
                                              children: [
                                                TextSpan(
                                                  style: h6.copyWith(
                                                    color: blackColor,
                                                  ),
                                                  text: ' QR thanh toán',
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: sp12),
                                          GestureDetector(
                                            onTap: () {
                                              context.router
                                                  .push(AddBankRoute());
                                            },
                                            child: Text(
                                              'Thêm ngay',
                                              style: p5.copyWith(color: blue_1),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(sp16),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
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
                      flex: 1,
                      child: MainButton(
                        title: 'Xác nhận',
                        event: () => widget.onConfirm.call(_typePayment),
                        largeButton: true,
                        icon: null,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
