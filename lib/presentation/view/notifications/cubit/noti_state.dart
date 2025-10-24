import 'package:firebase_database/firebase_database.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../domain/entity/noti.dart';
part 'noti_state.freezed.dart';

@freezed
class NotiState with _$NotiState {
  const factory NotiState({
    @Default(null) DataSnapshot? lastItem,
    @Default(null) NotiEntity? listNoti,
    @Default([TypeNoti.all, TypeNoti.unread]) List<TypeNoti> listFilter,
    @Default(TypeNoti.all) TypeNoti filterSelect,
    @Default(0) int totalAllNoti,
  }) = _NotiState;
}

enum TypeNoti {
  all('Tất cả'),
  unread('Chưa đọc');

  const TypeNoti(this.title);

  final String title;
}
