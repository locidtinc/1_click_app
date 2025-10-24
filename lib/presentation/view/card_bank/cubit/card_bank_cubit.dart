import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/domain/entity/card.dart';
import 'package:one_click/domain/usecase/get_card_local_use_case.dart';
import 'package:one_click/domain/usecase/get_card_remote_use_case.dart';
import 'package:one_click/shared/constants/local_storage/app_shared_preference.dart';
import 'package:one_click/shared/constants/pref_keys.dart';

import 'card_bank_state.dart';

@injectable
class CardBankCubit extends Cubit<CardBankState> {
  CardBankCubit(this._getCardLocalUseCase, this._getCardRemoteUseCase)
      : super(const CardBankState());

  final GetCardLocalUseCase _getCardLocalUseCase;
  final GetCardRemoteUseCase _getCardRemoteUseCase;

  Future<void> getCardRemote() async {
    final res = await _getCardRemoteUseCase.execute(GetCardRemoteInput());
    if (res.response.data != null) {
      AppSharedPreference.instance
          .setValue(PrefKeys.card, jsonEncode(res.response.data?.toJson()));
      emit(state.copyWith(cardEntity: res.response.data));
    }
  }

  void getCardLocal() {
    final res = _getCardLocalUseCase.buildUseCase(GetCardLocalInput());
    if (res.card is CardEntity) {
      emit(state.copyWith(cardEntity: res.card));
    } else {
      emit(state.copyWith(cardEntity: null));
    }
  }

  Future<CardEntity?> getCard() async {
    emit(state.copyWith(isLoading: true));
    getCardLocal();
    if (state.cardEntity == null) {
      await getCardRemote();
    }
    emit(state.copyWith(isLoading: false));
    return state.cardEntity;
  }
}
