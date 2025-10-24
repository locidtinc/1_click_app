import 'package:injectable/injectable.dart';
import 'package:one_click/data/mapper/base/base_data_mapper.dart';
import 'package:one_click/data/models/daily_oder.dart';
import 'package:one_click/domain/entity/daily_oder_entity.dart';

@injectable
class DailyOrderMapper extends BaseDataMapper<DailyOder, DailyOderEntity> {
  @override
  DailyOderEntity mapToEntity(DailyOder? data) {
    return DailyOderEntity(
      date: data?.date ?? '',
      totalNumberOfOrders: data?.totalNumberOfOrders ?? 0,
      totatRevenue: data?.totalRevenue ?? 0,
    );
  }
}
