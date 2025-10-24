import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:one_click/data/models/store_model/bank_data.dart';

part 'add_bank_state.freezed.dart';

@freezed
class AddBankState with _$AddBankState {
  const factory AddBankState({
    @Default(<BankData>[]) List<BankData> listBank,
    @Default(<BankData>[]) List<BankData> listBankSearch,
    int? bankId,
    String? bankName,
    String? accountNumber,
    String? accountName,
    @Default('') String code,
    @Default(false) isMBBank,
  }) = _AddBankState;
}
