import 'package:injectable/injectable.dart';
import 'package:one_click/data/models/warehouse_data_model.dart';
import 'package:one_click/domain/repository/warehouse_repository.dart';
import 'package:one_click/domain/usecase/base/io/base_input.dart';

@injectable
class GetListWareHouseUseCase {
  final WarehouseRepository _repository;
  GetListWareHouseUseCase(
    this._repository,
  );

  Future<List<WarehouseModel>> getListV2(ListWarehouseInput input) async {
    final res = await _repository.getListWareHouse(input);
    return res.data == null ? List.empty() : res.data!;
  }
}

class ListWarehouseInput extends BaseInput {
  final int? workspace;
  final int? expired;

  ListWarehouseInput({
    this.workspace,
    this.expired,
  });
}
