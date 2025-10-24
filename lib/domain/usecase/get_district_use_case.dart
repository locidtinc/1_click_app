import 'package:injectable/injectable.dart';
import 'package:one_click/data/models/store_model/address/type_data.dart';
import 'package:one_click/domain/repository/location_repository.dart';
import 'package:one_click/domain/usecase/base/base_use_case.dart';

@injectable
class GetDistrictUseCase extends BaseUseCaseInput<int, List<TypeData>> {
  GetDistrictUseCase(this._repository);

  final LocationRepository _repository;

  @override
  Future<List<TypeData>> execute(int input) async {
    final res = await _repository.getListDistrict(input);
    return res;
  }
}
