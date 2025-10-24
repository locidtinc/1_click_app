import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/domain/usecase/promotion_type_remote_use_case.dart';

import '../../../../domain/entity/promotion_type.dart';
import 'promotion_state.dart';

@lazySingleton
class PromotionCubit extends Cubit<PromotionState> {
  PromotionCubit(this._promotionTypeRemoteUseCase)
      : super(const PromotionState());

  final PromotionTypeRemoteUseCase _promotionTypeRemoteUseCase;

  Future<void> getTypeRemote() async {
    final res =
        await _promotionTypeRemoteUseCase.execute(PromotionTypeRemoteInput());
    if (res.response.code == 200) {
      emit(state.copyWith(listType: res.response.data ?? []));
    }
  }

  Future<List<PromotionTypeEntity>> get getTypePromotion async {
    await getTypeRemote();
    return state.listType;
  }
}
