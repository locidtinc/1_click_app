import 'package:injectable/injectable.dart';
import 'package:one_click/data/models/inventory_model_v2.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/domain/entity/batch_entity.dart';
import 'package:one_click/domain/entity/warehouse_entity.dart';
import 'package:one_click/domain/repository/warehouse_repository.dart';
import 'package:one_click/domain/usecase/base/io/base_input.dart';
import 'package:one_click/domain/usecase/base/io/base_output.dart';

@injectable
class WarehouseUseCase {
  // final TicketRepository _repository;
  final WarehouseRepository _warehouseRepository;
  // final WarehouseEntityMapper _mapper;
  WarehouseUseCase(
    // this._repository,
    // this._mapper,
    this._warehouseRepository,
  );
  // Future<WarehouseCreateOutput> create(WarehouseCreateInput input) async {
  //   final res = await _repository.create(input);
  //   // final dataEntity = _mapper.mapToEntity(res.data);
  //   final output = WarehouseCreateOutput(
  //     response: BaseResponseModel(
  //       code: res.code,
  //       message: res.message,
  //       // data: dataEntity,
  //     ),
  //   );
  //   return output;
  // }

  // Future<List<WarehouseEntity>> getList(WarehouseInput input) async {
  //   final res = await _repository.getList(input);
  //   return res.data == null
  //       ? List.empty()
  //       : res.data!
  //           .map<WarehouseEntity>((data) => _mapper.mapToEntity(data))
  //           .toList();
  // }

  // Future<TicketEntity?> getTicket(int id) async {
  //   final ticket = await _repository.getTicket(id);
  //   return ticket == null ? null : _mapper.mapTicketEntity(ticket);
  // }

  // Future<BaseResponseModel> updateTicketStatus(int id, String status) async {
  //   return await _repository.updateTicketStatus(id, status);
  // }

  Future<BaseResponseModel<List<InventoryModelV2>>> getListInventory(
    InventoryInputV2 input,
  ) async {
    final res = await _warehouseRepository.getListInventory(input);
    return res;
  }
}

class VariantListInput extends BaseInput {
  final String search;
  final int limit;
  final int page;
  final int company;

  VariantListInput({
    required this.search,
    required this.limit,
    required this.page,
    required this.company,
  });
}

class WarehouseCreateInput extends BaseInput {
  final String code;
  final String type;
  final String status;
  final String note;
  final int totalPrice;
  final int exportTo;
  final int importFrom;
  final int warehouse;
  final List<BatchEntity> batchs;

  WarehouseCreateInput(
      {required this.code,
      required this.type,
      required this.status,
      required this.note,
      required this.totalPrice,
      required this.exportTo,
      required this.importFrom,
      required this.warehouse,
      required this.batchs});
}

class WarehouseCreateOutput extends BaseOutput {
  final BaseResponseModel<WarehouseEntity> response;
  WarehouseCreateOutput({required this.response});
}

class WarehouseInput extends BaseInput {
  final String search;
  final int limit;
  final int page;
  final int? company;
  final int? expired;

  WarehouseInput({
    required this.search,
    required this.limit,
    required this.page,
    required this.company,
    this.expired,
  });
}

class InventoryInputV2 extends BaseInput {
  final String search;
  final int? id;
  final int limit;
  final int page;
  final int? expired;
  final int? workspace;

  InventoryInputV2({
    required this.limit,
    required this.page,
    required this.search,
    required this.id,
    this.expired,
    this.workspace,
  });
}
