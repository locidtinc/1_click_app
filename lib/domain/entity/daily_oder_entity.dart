import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_oder_entity.freezed.dart';

@freezed
class DailyOderEntity with _$DailyOderEntity {
  const DailyOderEntity._();

  const factory DailyOderEntity({
    @Default('') String date,
    @JsonKey(name: 'total_revenue') @Default(0.0) double totatRevenue,
    @JsonKey(name: 'total_number_of_orders') @Default(0) int totalNumberOfOrders,
  }) = _DailyOderEntity;
}
