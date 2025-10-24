import 'package:freezed_annotation/freezed_annotation.dart';

part 'participation_event_state.freezed.dart';

@freezed
class CustomerListState with _$CustomerListState {
  const factory CustomerListState({
    @Default('') String searchKey,
    @Default(10) int limit,
    @Default([]) List listParticipation,
  }) = _CustomerListState;
}
