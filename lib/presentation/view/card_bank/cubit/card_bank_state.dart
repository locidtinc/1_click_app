import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:one_click/domain/entity/card.dart';

part 'card_bank_state.freezed.dart';

@freezed
class CardBankState with _$CardBankState {
  const factory CardBankState({
    @Default(null) CardEntity? cardEntity,
    @Default(false) bool isLoading,
  }) = _CardBankState;
}
