import 'package:firebase_database/firebase_database.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/data/apis/base_dio.dart';
import 'package:one_click/data/apis/end_point.dart';
import 'package:one_click/data/models/notification_model.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/data/models/noti_model.dart';

import '../../domain/repository/noti_repository.dart';

@LazySingleton(as: NotiRepository)
class NotiRepositoryImpl extends NotiRepository {
  final BaseDio dio;

  NotiRepositoryImpl({required this.dio});

  @override
  Future<BaseResponseModel<List<NotificationModel>>> getList(
    int page,
    DataSnapshot? lastItem,
  ) async {
    try {
      final res = await dio.dio().get(Api.notification);

      if (res.data['code'] == 200) {
        final data = NotificationModel.fromJson(res.data['data']);
        return BaseResponseModel(data: [data], code: 200);
      } else {
        return BaseResponseModel(message: res.data['message'], code: 400);
      }
    } catch (e) {
      return BaseResponseModel(code: 400, message: e.toString());
    }

    // final ref = FirebaseDatabase.instance.ref();
    // final listNotiLoad = <NotiModel>[];
    // late DataSnapshot snapshot;
    // final id = AppSharedPreference.instance.getValue(PrefKeys.user);
    // if (page == 0) {
    //   snapshot =
    //       await ref.child('ACCOUNT/$id').orderByKey().limitToLast(10).get();
    //   for (final item in (snapshot.value as List<Object?>)) {
    //     listNotiLoad.add(NotiModel.fromJson(item));
    //   }
    //   // lastItem = snapshot.children.first;
    // } else {
    //   snapshot = await ref
    //       .child('ACCOUNT/$id')
    //       .orderByKey()
    //       .startAfter('${int.parse(lastItem?.key ?? '0') - 11}')
    //       .endBefore(lastItem?.key)
    //       .get();
    //   (snapshot.value as Map<Object?, Object?>).forEach((key, value) {
    //     listNotiLoad.add(NotiModel.fromJson(value));
    //   });
    //   // lastItem = snapshot.children.first;
    // }
  }

  @override
  Future<BaseResponseModel> updateNoti(int id) async {
    try {
      final data = {'is_read': true};
      final res = await dio.dio().put('${Api.notification}/$id/', data: data);
      if (res.data['code'] == 200) {
        return BaseResponseModel(data: data, code: 200);
      } else {
        return BaseResponseModel(message: res.data['message'], code: 400);
      }
    } catch (e) {
      return BaseResponseModel(code: 400, message: e.toString());
    }
  }

  // @override
  // Future<BaseResponseModel> updateNoti(int idNoti, NotiModel payload) async {
  //   final ref = FirebaseDatabase.instance.ref();
  //   // Xây dựng đường dẫn đến nút thông báo cần cập nhật
  //   String path = 'ACCOUNT/$accountId/$idNoti';

  //   // Cập nhật thông báo với nội dung mới
  //   ref.child(path).update(payload.toJson());
  //   throw UnimplementedError();
  // }
}
