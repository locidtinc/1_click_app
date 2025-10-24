import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_entity.freezed.dart';

@freezed
class GroupEntity with _$GroupEntity {
  const factory GroupEntity({
    @Default(0) int id,
    @Default('') String title,
    @Default('') String code,
    @Default(0) int account,
    @Default(<int>[]) List<int> product,
    @Default(0) int productQuantity,
  }) = _GroupEntity;
}
