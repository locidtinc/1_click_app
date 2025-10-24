import 'package:firebase_database/firebase_database.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/data/models/noti_model.dart';
import 'package:one_click/domain/entity/noti.dart';
import 'package:one_click/domain/usecase/base/future/base_future_use_case.dart';
import 'package:one_click/presentation/view/order_create/cubit/order_create_state.dart';

import '../../shared/constants/local_storage/app_shared_preference.dart';
import '../../shared/constants/pref_keys.dart';
import 'base/io/base_input.dart';
import 'base/io/base_output.dart';

@injectable
class NotiSeenAllUseCase
    extends BaseFutureUseCase<NotiSeenAllInput, NotiSeenAllOutput> {
  @override
  Future<NotiSeenAllOutput> buildUseCase(NotiSeenAllInput input) async {
    final ref = FirebaseDatabase.instance.ref();
    final id = AppSharedPreference.instance.getValue(PrefKeys.user);
    final listNotiModel = <NotiModel>[];
    final listNotiJson = await ref.child('ACCOUNT/$id').get();
    for (final item in (listNotiJson.value as List<Object?>)) {
      listNotiModel.add((NotiModel.fromJson(item)).copyWith(isReaded: true));
    }
    Map<String, dynamic> map = {};

    for (int i = 0; i < listNotiModel.length; i++) {
      map['$i'] = listNotiModel[i].toJson();
    }
    await ref.child('ACCOUNT/$id').update(map).then((value) {
      return NotiSeenAllOutput(true);
    }).catchError((onError) {
      print(onError);
      return NotiSeenAllOutput(false);
    });
    return NotiSeenAllOutput(true);
  }
}

class NotiSeenAllInput extends BaseInput {}

class NotiSeenAllOutput extends BaseOutput {
  final bool isSuccess;
  NotiSeenAllOutput(this.isSuccess);
}
