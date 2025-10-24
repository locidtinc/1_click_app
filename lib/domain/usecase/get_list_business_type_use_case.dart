import 'package:injectable/injectable.dart';
import 'package:one_click/data/models/store_model/address/type_data.dart';
import 'package:one_click/domain/repository/store_repository.dart';
import 'package:one_click/domain/usecase/base/base_use_case.dart';
import 'package:one_click/domain/usecase/base/io/base_output.dart';

@injectable
class GetListBusinessTypeUseCase
    extends BaseUseCaseNoInput<BusinessTypeOutput> {
  GetListBusinessTypeUseCase(this._repository);

  final StoreRepository _repository;

  @override
  Future<BusinessTypeOutput> execute() async {
    final res = await _repository.getListBusinessType();
    return BusinessTypeOutput(res);
  }
}

@injectable
class GetListBusinessTypeTokenUseCase
    extends BaseUseCaseInput<String, BusinessTypeOutput> {
  GetListBusinessTypeTokenUseCase(this._repository);

  final StoreRepository _repository;

  @override
  Future<BusinessTypeOutput> execute(String input) async {
    final res = await _repository.getListBusinessType(token: input);
    return BusinessTypeOutput(res);
  }
}

class BusinessTypeOutput extends BaseOutput {
  BusinessTypeOutput(this.listBusinessType);

  final List<TypeData> listBusinessType;
}
