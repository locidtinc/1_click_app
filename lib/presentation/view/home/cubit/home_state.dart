import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:one_click/domain/entity/daily_oder_entity.dart';
import 'package:one_click/shared/constants/param_date.dart';

import '../../../../domain/entity/store_entity.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  factory HomeState({
    @Default(StoreEntity()) StoreEntity storeEntity,
    @Default(DailyOderEntity()) DailyOderEntity dailyOderEntity,
    @Default([]) List<DateTime?> dates,
    ParamDate? paramDate,
    @Default(true) bool isLoading,
  }) = _HomeState;
}
