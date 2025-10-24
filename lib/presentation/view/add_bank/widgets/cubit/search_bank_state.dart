import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:one_click/data/models/store_model/bank_data.dart';

part 'search_bank_state.freezed.dart';

@freezed
class SearchBankState with _$SearchBankState {
  const factory SearchBankState({
    @Default(<BankData>[]) List<BankData> listBank,
    @Default(<BankData>[]) List<BankData> listBankSearch,
    @Default(false) bool isEmpty,
  }) = _SearchBankState;
}
