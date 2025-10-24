import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:one_click/data/models/noti_model.dart';
import 'package:one_click/presentation/view/order_create/cubit/order_create_state.dart';
part 'noti.freezed.dart';

@freezed
class NotiEntity with _$NotiEntity {
  const NotiEntity._();

  const factory NotiEntity({
    List<NotiModel>? notifications,
    int? unreadCount,
  }) = _NotiEntity;
}
