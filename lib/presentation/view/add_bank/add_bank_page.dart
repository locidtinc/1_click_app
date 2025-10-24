import 'package:auto_route/annotations.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_click/domain/entity/store_entity.dart';
import 'package:one_click/presentation/base/app_bar.dart';
import 'package:one_click/presentation/base/card_base.dart';
import 'package:one_click/presentation/base/select_box_widget.dart';
import 'package:one_click/presentation/di/di.dart';
import 'package:one_click/presentation/view/add_bank/cubit/add_bank_cubit.dart';
import 'package:one_click/presentation/view/add_bank/cubit/add_bank_state.dart';

@RoutePage()
class AddBankPage extends StatelessWidget {
  const AddBankPage({
    super.key,
    this.isEdit = false,
    this.card,
    this.token,
  });

  final bool isEdit;
  final CardDataEntity? card;
  final String? token;

  @override
  Widget build(BuildContext context) {
    print('cardcardcard $card');
    return BlocProvider<AddBankCubit>(
      create: (context) => getIt.get<AddBankCubit>()
        ..getLisBank(
          card,
          token: token,
        ),
      child: BlocBuilder<AddBankCubit, AddBankState>(
        builder: (context, state) {
          final bloc = context.read<AddBankCubit>();
          return Scaffold(
            appBar: BaseAppBar(
              title: isEdit
                  ? 'Chỉnh sửa tài khoản ngân hàng'
                  : 'Thêm tài khoản ngân hàng',
            ),
            backgroundColor: borderColor_1,
            body: state.listBank.isEmpty
                ? const BaseLoading()
                : Column(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            CardBase(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 16) +
                                      const EdgeInsets.only(top: 24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SelectBoxWidget(
                                    title: 'Chọn ngân hàng',
                                    hintText: 'Chọn ngân hàng',
                                    value: state.bankName,
                                    titleStyle: p5,
                                    onTap: () => bloc.onSelectBank(context),
                                  ),
                                  const SizedBox(height: sp16),
                                  AppInput(
                                    label: 'Số tài khoản',
                                    hintText: 'Nhập số tài khoản',
                                    validate: (String? value) {},
                                    initialValue:
                                        card != null ? card!.cardNumber : '',
                                    // onConfirm: (String value) => bloc.onChangeAccountNumber(
                                    //   context,
                                    //   value,
                                    //   bin: card?.bin,
                                    // ),
                                    onChanged: (String value) =>
                                        bloc.onChangeAccountNumber(
                                      context,
                                      value,
                                      bin: card?.bin,
                                    ),
                                  ),
                                  const SizedBox(height: sp16),
                                  // Column(
                                  //   crossAxisAlignment: CrossAxisAlignment.start,
                                  //   children: [
                                  //     const Text(
                                  //       'Tên chủ tài khoản',
                                  //       style: p5,
                                  //     ),
                                  //     const SizedBox(height: 4),
                                  //     Container(
                                  //       width: double.infinity,
                                  //       padding: const EdgeInsets.all(16),
                                  //       decoration: BoxDecoration(
                                  //         color: borderColor_1,
                                  //         borderRadius: BorderRadius.circular(sp8),
                                  //       ),
                                  //       child: Text(
                                  //         card != null ? card!.nameCard : state.accountName ?? 'Vui lòng nhập số tài khoản',
                                  //         style: state.accountName != null
                                  //             ? p6
                                  //             : p6.copyWith(
                                  //                 color: borderColor_4,
                                  //               ),
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  AppInput(
                                    label: 'Tên tài khoản',
                                    hintText: 'Nhập tên chủ tài khoản',
                                    validate: (String? value) {},
                                    initialValue:
                                        card != null ? card?.nameCard : '',
                                    onChanged: (value) => bloc.setAcountName(
                                      value,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      TwoButtonBox(
                        extraTitle: 'Huỷ bỏ',
                        mainTitle: 'Lưu lại',
                        extraOnTap: () => bloc.onTapCancel(context),
                        mainOnTap: () => bloc.onTapSave(
                          context,
                          isEdit,
                          cardId: card?.cardId,
                          card: card,
                          token: token,
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
