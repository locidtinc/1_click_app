import 'package:injectable/injectable.dart';
import 'package:one_click/data/mapper/base/base_data_mapper.dart';
import 'package:one_click/data/models/unit_model.dart';
import 'package:one_click/domain/entity/unit_entity.dart';

@injectable
class UnitMapper extends BaseDataMapper<UnitModel, UnitEntity> {
  @override
  UnitEntity mapToEntity(UnitModel? data) {
    return UnitEntity(
        id: data?.id,
        level: data?.level,
        title: data?.title,
        storageUnit: data?.storageUnit,
        conversionValue: data?.conversionValue,
        sellUnit: data?.sellUnit);
  }
}
