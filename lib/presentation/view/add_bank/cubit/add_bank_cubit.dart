import 'package:auto_route/auto_route.dart';
import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/data/models/bank_payload.dart';
import 'package:one_click/domain/entity/store_entity.dart';
import 'package:one_click/domain/usecase/add_card_use_case.dart';
import 'package:one_click/domain/usecase/check_card_use_case.dart';
import 'package:one_click/domain/usecase/get_list_bank_use_case.dart';
import 'package:one_click/domain/usecase/update_card_use_case.dart';
import 'package:one_click/presentation/base/dialog_custom.dart';
import 'package:one_click/presentation/view/add_bank/cubit/add_bank_state.dart';
import 'package:one_click/presentation/view/add_bank/widgets/select_bank_widget.dart';

@injectable
class AddBankCubit extends Cubit<AddBankState> {
  AddBankCubit(
    this._getListBankUseCase,
    this._checkCardUseCase,
    this._addCardUseCase,
    this._updateCardUseCase,
  ) : super(const AddBankState());

  final GetListBankUseCase _getListBankUseCase;
  final CheckCardUseCase _checkCardUseCase;
  final AddCardUseCase _addCardUseCase;
  final UpdateCardUseCase _updateCardUseCase;

  void getLisBank(CardDataEntity? card, {String? token}) async {
    final res = await _getListBankUseCase.execute(BankInput(token));
    emit(state.copyWith(listBank: res, bankName: card?.shortName));
  }

  void onSelectBank(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(sp12),
        ),
      ),
      isDismissible: false,
      builder: (_) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SelectBankWidget(
            title: 'Chọn ngân hàng',
            listBank: state.listBank,
            isBank: true,
            onTapItem: (bank) {
              Navigator.of(context).pop();
              emit(
                state.copyWith(
                  bankId: bank.id,
                  bankName: bank.shortName,
                  code: bank.bin ?? '',
                  isMBBank: bank.code == 'MB' ? true : false,
                ),
              );
            },
          ),
        );
      },
    );
  }

  void onChangeAccountNumber(
    BuildContext context,
    String value, {
    String? bin,
  }) async {
    emit(state.copyWith(accountNumber: value));
    if (value.isEmpty) return;
    // DialogUtils.showLoadingDialog(
    //   context,
    //   content: 'Đang kiểm tra thông tin, vui lòng đợi!',
    // );
    // final res = await _checkCardUseCase.execute(
    //   CardInput(
    //     bin ?? state.code,
    //     value,
    //     state.isMBBank ? 'INHOUSE' : 'NAPAS',
    //   ),
    // );
    // if (res.accountName != null && context.mounted) {
    //   Navigator.of(context).pop();
    //   emit(state.copyWith(accountName: res.accountName));
    // } else {
    //   Navigator.of(context).pop();
    //   DialogUtils.showErrorDialog(
    //     context,
    //     content: 'Không tìm thấy thông tin',
    //   );
    // }
  }

  void onTapCancel(BuildContext context) {
    DialogCustoms.showNotifyDialog(
      context,
      content: const Padding(
        padding: EdgeInsets.only(bottom: 24),
        child: Text('Bạn có muốn thoát không?'),
      ),
      click: () {
        int count = 2;
        context.router.popUntil((route) => count-- <= 0);
      },
    );
  }

  void setAcountName(String? value) {
    emit(state.copyWith(accountName: value ?? ''));
  }

  void onTapSave(
    BuildContext context,
    bool isEdit, {
    int? cardId,
    CardDataEntity? card,
    String? token,
  }) async {
    DialogUtils.showLoadingDialog(
      context,
      content: 'Đang thêm dữ liệu, vui lòng đợi!',
    );
    if (isEdit && cardId != null) {
      final res = await _updateCardUseCase.execute(
        UpdateCardInput(
          cardId,
          BankPayload(
            state.accountNumber ?? card?.cardNumber ?? '',
            state.accountName ?? card?.nameCard ?? '',
            state.bankId ?? 1,
          ),
        ),
      );
      _onSuccess(context, res);
      return;
    } else {
      final res = await _addCardUseCase.execute(
        AddBankInput(
          token,
          BankPayload(
            state.accountNumber ?? '',
            state.accountName ?? '',
            state.bankId ?? 1,
          ),
        ),
      );
      _onSuccess(context, res);
    }
  }

  void _onSuccess(BuildContext context, dynamic res) {
    Navigator.of(context).pop();
    if (res.code == 200) {
      DialogCustoms.showSuccessDialog(
        context,
        content: const Text(
          'Thêm tài khoản ngân hàng thành công!',
          style: p6,
        ),
        click: () {
          final cardDataEntity = CardDataEntity(
            cardId: res.data?.id,
            bin: res.data?.bankData?.bin,
            bankId: res.data?.bankData?.id,
            bankName: res.data?.bankData?.title ?? '',
            cardNumber: res.data?.cardNumber ?? '',
            nameCard: res.data?.fullName ?? '',
            shortName: res.data?.bankData?.shortName ?? '',
          );
          Navigator.of(context).pop();
          context.router.pop(cardDataEntity);
        },
      );
    } else {
      DialogUtils.showErrorDialog(
        context,
        content: res.message ?? 'Thêm ngân hàng thất bại',
      );
    }
  }
}
