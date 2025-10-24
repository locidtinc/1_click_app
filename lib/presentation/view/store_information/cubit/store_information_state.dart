import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:one_click/domain/entity/store_entity.dart';

part 'store_information_state.freezed.dart';

@freezed
class StoreInformationState with _$StoreInformationState {
  const factory StoreInformationState({
    @Default(StoreEntity()) StoreEntity storeEntity,
  }) = _StoreInformationState;
}
