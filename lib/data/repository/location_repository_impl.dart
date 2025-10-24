import 'package:injectable/injectable.dart';
import 'package:one_click/data/apis/base_dio.dart';
import 'package:one_click/data/apis/end_point.dart';
import 'package:one_click/data/models/store_model/address/type_data.dart';
import 'package:one_click/domain/repository/location_repository.dart';
import 'package:one_click/presentation/di/di.dart';

@LazySingleton(as: LocationRepository)
class LocationRepositoryImpl extends LocationRepository {
  @override
  Future<List<TypeData>> getListProvince() async {
    final res = await getIt.get<BaseDio>().dio().get(Api.province);
    final dataModel =
        (res.data['data'] as List).map((e) => TypeData.fromJson(e)).toList();
    return dataModel;
  }

  @override
  Future<List<TypeData>> getListDistrict(int id) async {
    final res = await getIt.get<BaseDio>().dio().get('${Api.district}$id/');
    final dataModel =
        (res.data['data'] as List).map((e) => TypeData.fromJson(e)).toList();
    return dataModel;
  }

  @override
  Future<List<TypeData>> getListWard(int id) async {
    final res = await getIt.get<BaseDio>().dio().get('${Api.ward}$id');
    final dataModel =
        (res.data['data'] as List).map((e) => TypeData.fromJson(e)).toList();
    return dataModel;
  }

  @override
  Future<List<TypeData>> getListArea() async {
    final res = await getIt.get<BaseDio>().dio().get(Api.area);
    final dataModel =
        (res.data['data'] as List).map((e) => TypeData.fromJson(e)).toList();
    return dataModel;
  }
}
