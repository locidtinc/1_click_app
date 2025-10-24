import 'package:firebase_database/firebase_database.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/data/mapper/noti_mapper.dart';
import 'package:one_click/data/models/notification_model.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/domain/entity/noti.dart';
import 'package:one_click/domain/repository/noti_repository.dart';
import 'package:one_click/domain/usecase/base/future/base_future_use_case.dart';
import 'package:one_click/domain/usecase/base/io/base_input.dart';
import 'package:one_click/domain/usecase/base/io/base_output.dart';

import '../../data/models/noti_model.dart';
import '../../shared/constants/local_storage/app_shared_preference.dart';
import '../../shared/constants/pref_keys.dart';

@injectable
class NotiUpdateUseCase
    extends BaseFutureUseCase<NotiUpdateInput, NotiUpdateOutput> {
  final NotiRepository _notiRepository;
  final NotiEntityMapper _notiEntityMapper;
  NotiUpdateUseCase(this._notiRepository, this._notiEntityMapper);

  @override
  Future<NotiUpdateOutput> buildUseCase(NotiUpdateInput input) async {
    return NotiUpdateOutput(response: BaseResponseModel());
    // final res = await _notiRepository.getList(input.page, input.lastItem);

    // final ref = FirebaseDatabase.instance.ref();
    // final listNotiLoad = <NotificationModel>[];
    // late DataSnapshot snapshot;
    // final id = AppSharedPreference.instance.getValue(PrefKeys.user);
    // if (input.page == 0) {
    //   snapshot = await ref.child('ACCOUNT/$id').orderByKey().limitToLast(10).get();
    //   for (final item in (snapshot.value as List<Object?>)) {
    //     listNotiLoad.add(NotificationModel.fromJson(item));
    //   }
    //   // lastItem = snapshot.children.first;
    // } else {
    //   snapshot = await ref.child('ACCOUNT/$id').orderByKey().startAfter('${int.parse(input.lastItem?.key ?? '0') - 11}').endBefore(input.lastItem?.key).get();
    //   if (snapshot.exists) {
    //     (snapshot.value as Map<Object?, Object?>).forEach((key, value) {
    //       listNotiLoad.add(NotificationModel.fromJson(value));
    //     });
    //   }
    // lastItem = snapshot.children.first;
  }
  // print('========${snapshot.exists}}');

  //   return NotiUpdateOutput(
  //     response: BaseResponseModel(
  //       data: _notiEntityMapper.mapToListEntity(listNotiLoad),
  //     ),
  //     lastItem: snapshot.exists ? snapshot.children.first : null,
  //   );
  // }
}

class NotiUpdateInput extends BaseInput {
  final int page;
  final DataSnapshot? lastItem;
  NotiUpdateInput({
    required this.lastItem,
    required this.page,
  });
}

class NotiUpdateOutput extends BaseOutput {
  final BaseResponseModel<List<NotiEntity>> response;
  final DataSnapshot? lastItem;
  NotiUpdateOutput({
    required this.response,
    this.lastItem,
  });
}
