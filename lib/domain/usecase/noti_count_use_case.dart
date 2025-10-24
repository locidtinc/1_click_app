import 'package:firebase_database/firebase_database.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/domain/usecase/base/future/base_future_use_case.dart';

import '../../shared/constants/local_storage/app_shared_preference.dart';
import '../../shared/constants/pref_keys.dart';
import 'base/io/base_input.dart';
import 'base/io/base_output.dart';

@injectable
class NotiCountUseCase
    extends BaseFutureUseCase<NotiCountInput, NotiCountOutput> {
  @override
  Future<NotiCountOutput> buildUseCase(NotiCountInput input) async {
    final ref = FirebaseDatabase.instance.ref();
    final id = AppSharedPreference.instance.getValue(PrefKeys.user);
    final snapshot = await ref.child('ACCOUNT/$id').get();
    print('📦 Firebase snapshot value: ${snapshot.value}');

    return NotiCountOutput((snapshot.value as List<Object?>).length);
  }
}

class NotiCountInput extends BaseInput {
  NotiCountInput();
}

class NotiCountOutput extends BaseOutput {
  final int countTotal;
  NotiCountOutput(this.countTotal);
}
