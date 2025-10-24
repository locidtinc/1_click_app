import 'package:injectable/injectable.dart';
import 'package:one_click/data/models/store_model/address/type_data.dart';
import 'package:one_click/domain/repository/location_repository.dart';
import 'package:one_click/domain/usecase/base/base_use_case.dart';

@injectable
class GetProvinceUseCase extends BaseUseCaseNoInput<List<TypeData>> {
  GetProvinceUseCase(this._repository);

  final LocationRepository _repository;

  @override
  Future<List<TypeData>> execute() async {
    final res = await _repository.getListProvince();
    return res;
  }
}
