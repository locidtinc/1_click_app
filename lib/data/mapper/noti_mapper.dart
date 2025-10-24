import 'package:injectable/injectable.dart';
import 'package:one_click/data/mapper/base/base_data_mapper.dart';
import 'package:one_click/data/models/notification_model.dart';
import '../../domain/entity/noti.dart';

@injectable
class NotiEntityMapper extends BaseDataMapper<NotificationModel, NotiEntity> {
  @override
  NotiEntity mapToEntity(NotificationModel? data) {
    return NotiEntity(
      unreadCount: data?.unreadCount,
      notifications: data?.notifications,
    );
  }
}
//  id: data?.notifications?.id,
//       title: data?.notifications?.title,
//       content: data?.notifications?.content,
//       code: data?.notifications?.code,
//       createAt: data?.notifications?.createAt,
//       isReaded: data?.notifications?.isReaded,
//       orderId: data?.notifications?.orderId,
//       index: data?.notifications?.index,
//       typeOrder: data?.notifications?.typeOrder == 'ORDERSYSTEM' ? TypeOrder.ad : TypeOrder.cHTH,