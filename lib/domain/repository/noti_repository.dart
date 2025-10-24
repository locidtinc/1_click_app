import 'package:firebase_database/firebase_database.dart';
import 'package:one_click/data/models/notification_model.dart';
import 'package:one_click/data/models/response/base_response.dart';

abstract class NotiRepository {
  Future<BaseResponseModel<List<NotificationModel>>> getList(
    int page,
    DataSnapshot? lastItem,
  );

  Future<BaseResponseModel> updateNoti(int id);
}
