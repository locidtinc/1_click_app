import 'package:one_click/data/models/store_model/address/type_data.dart';

abstract class LocationRepository {
  Future<List<TypeData>> getListProvince();
  Future<List<TypeData>> getListDistrict(int id);
  Future<List<TypeData>> getListWard(int id);
  Future<List<TypeData>> getListArea();
}
