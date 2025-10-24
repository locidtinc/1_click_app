import 'package:injectable/injectable.dart';
import 'package:one_click/domain/usecase/base/future/base_future_use_case.dart';
import 'package:one_click/domain/usecase/base/io/base_input.dart';

import '../../data/mapper/order_preview_mapper.dart';
import '../../data/models/response/base_response.dart';
import '../entity/order_preview.dart';
import '../repository/order_repository.dart';
import 'base/io/base_output.dart';

@injectable
class OrderImportUseCase
    extends BaseFutureUseCase<OrderImportInput, OrderImportOutput> {
  final OrderRepository _orderRepository;
  final OrderPreviewMapper _orderPreviewMapper;

  OrderImportUseCase(this._orderRepository, this._orderPreviewMapper);

  @override
  Future<OrderImportOutput> buildUseCase(OrderImportInput input) async {
    final res = await _orderRepository.getListImport(
      page: input.page,
      limit: input.limit,
      searchKey: input.searchKey,
      status: input.status,
    );
    return OrderImportOutput(
      BaseResponseModel<List<OrderPreviewEntity>>(
        code: res.code,
        message: res.message,
        data: _orderPreviewMapper.mapToListEntity(res.data),
      ),
    );
  }
}

class OrderImportInput extends BaseInput {
  final int page;
  final int limit;
  final String searchKey;
  final int? status;
  OrderImportInput({
    required this.limit,
    required this.page,
    required this.searchKey,
    this.status,
  });
}

class OrderImportOutput extends BaseOutput {
  final BaseResponseModel<List<OrderPreviewEntity>> response;
  OrderImportOutput(this.response);
}
