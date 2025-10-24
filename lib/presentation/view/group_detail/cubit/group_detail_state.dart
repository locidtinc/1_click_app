import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:one_click/domain/entity/group_detail_entity.dart';

part 'group_detail_state.freezed.dart';

@freezed
class GroupDetailState with _$GroupDetailState {
  const factory GroupDetailState({
    GroupDetailEntity? groups,
  }) = _GroupDetailState;
}
