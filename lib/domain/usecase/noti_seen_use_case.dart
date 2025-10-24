import 'package:injectable/injectable.dart';
import 'package:one_click/data/models/noti_model.dart';
import 'package:one_click/domain/entity/noti.dart';
import 'package:one_click/domain/repository/noti_repository.dart';
import 'package:one_click/domain/usecase/base/future/base_future_use_case.dart';

import 'base/io/base_input.dart';
import 'base/io/base_output.dart';

@injectable
class NotiSeenUseCase extends BaseFutureUseCase<NotiSeenInput, NotiSeenOutput> {
  final NotiRepository notiRepository;

  NotiSeenUseCase({required this.notiRepository});
  @override
  Future<NotiSeenOutput> buildUseCase(NotiSeenInput input) async {
    final res = await notiRepository.updateNoti(input.noti.id ?? 0);
    if (res.code == 200) {
      return NotiSeenOutput(true);
    } else {
      return NotiSeenOutput(true);
    }
    // final ref = FirebaseDatabase.instance.ref();
    // final id = AppSharedPreference.instance.getValue(PrefKeys.user);
    // await ref
    //     .child('ACCOUNT/$id/${input.noti.index}')
    //     .update(
    //       NotiModel(
    //         id: input.noti.id,
    //         code: input.noti.code,
    //         content: input.noti.content,
    //         createAt: input.noti.createAt,
    //         isReaded: true,
    //         orderId: input.noti.orderId,
    //         index: input.noti.index,
    //         title: input.noti.title,
    //         typeOrder:
    //             input.noti.typeOrder == TypeOrder.ad ? 'ORDERSYSTEM' : 'ORDER',
    //       ).toJson(),
    //     )
    //     .then((value) {

    // }).catchError((onError) {
    //   print(onError);
    //   return NotiSeenOutput(false);
    // });
  }
}

class NotiSeenInput extends BaseInput {
  final NotiModel noti;
  NotiSeenInput({
    required this.noti,
  });
}

class NotiSeenOutput extends BaseOutput {
  final bool isSuccess;
  NotiSeenOutput(this.isSuccess);
}
