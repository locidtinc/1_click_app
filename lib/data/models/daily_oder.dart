// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_oder.g.dart';

@JsonSerializable()
class DailyOder {
  DailyOder({
     this.date,
     this.totalRevenue,
     this.totalNumberOfOrders,
  });
  final String? date;
  @JsonKey(name: 'total_revenue')
  final double? totalRevenue;
  @JsonKey(name: 'total_number_of_orders')
  final int? totalNumberOfOrders;

  factory DailyOder.fromJson(Map<String, dynamic> json) => _$DailyOderFromJson(json);

  Map<String, dynamic> toJson() => _$DailyOderToJson(this);
}
