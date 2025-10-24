import 'package:freezed_annotation/freezed_annotation.dart';
part 'order_count_model.g.dart';

@JsonSerializable()
class OrderCountModel {
  final int? id;
  final String? type;
  final int? count;

  OrderCountModel({
    this.id,
    this.type,
    this.count,
  });

  OrderCountModel copyWith({
    int? id,
    String? type,
    int? count,
  }) =>
      OrderCountModel(
        id: id ?? this.id,
        type: type ?? this.type,
        count: count ?? this.count,
      );

  factory OrderCountModel.fromJson(Map<String, dynamic> json) =>
      _$OrderCountModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderCountModelToJson(this);
}
