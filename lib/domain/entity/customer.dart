import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:one_click/domain/entity/store_entity.dart';
part 'customer.freezed.dart';
part 'customer.g.dart';

@freezed
class CustomerEntity with _$CustomerEntity {
  const CustomerEntity._();

  const factory CustomerEntity({
    @Required() int? id,
    @JsonKey(name: 'full_name') @Required() String? fullName,
    @Required() String? phone,
    @Default(null) String? code,
    @Default(null) String? email,
    @Default(null) AddressEntity? address,
    @Default(null) String? birthday,
    @Default(null) String? image,
    @Default(1) int gender,
    @Default(<int>[]) List<int> shop,
  }) = _CustomerEntity;

  factory CustomerEntity.fromJson(Map<String, dynamic> json) =>
      _$CustomerEntityFromJson(json);
}
