import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/domain/repository/variant_repository.dart';
import 'package:one_click/domain/usecase/base/future/base_future_use_case.dart';
import 'package:one_click/domain/usecase/base/io/base_input.dart';
import 'package:one_click/domain/usecase/base/io/base_output.dart';

@injectable
class ProductShipmentsUseCase
    extends BaseFutureUseCase<ProductShipmentInput, ProductShipmentOutput> {
  ProductShipmentsUseCase(this._repository);

  final VariantRepository _repository;

  @override
  Future<ProductShipmentOutput> buildUseCase(ProductShipmentInput input) async {
    final res = await _repository.getProdShipments(id: input.id);
    return ProductShipmentOutput(res);
  }
}

class ProductShipmentInput extends BaseInput {
  ProductShipmentInput(this.id);

  int id;
}

class ProductShipmentOutput extends BaseOutput {
  ProductShipmentOutput(this.response);
  BaseResponseModel response;
}
