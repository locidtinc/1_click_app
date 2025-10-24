import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:one_click/data/models/noti_model.dart';

part 'notification_model.g.dart';

@JsonSerializable()
class NotificationModel {
  @JsonKey(name: 'unread_count')
  final int? unreadCount;

  final List<NotiModel>? notifications;

  NotificationModel({
    this.unreadCount,
    this.notifications,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);
}
