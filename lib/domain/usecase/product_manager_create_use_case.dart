import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/data/mapper/product_detail_mapper.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/domain/entity/product_detail_entity.dart';
import 'package:one_click/domain/repository/variant_repository.dart';
import 'package:one_click/domain/usecase/base/future/base_future_use_case.dart';
import 'package:one_click/domain/usecase/base/io/base_input.dart';
import 'package:one_click/domain/usecase/base/io/base_output.dart';

@injectable
class ProductManagerCreateUseCase extends BaseFutureUseCase<
    ProductManagerCreateInput, ProductManagerCreateOutput> {
  final VariantRepository _repository;
  final ProductDetailMapper _productDetailMapper;

  ProductManagerCreateUseCase(this._repository, this._productDetailMapper);

  @override
  Future<ProductManagerCreateOutput> buildUseCase(
      ProductManagerCreateInput input) async {
    final res =
        await _repository.updateVariant(input.id, input.productPayloadEntity);
    return ProductManagerCreateOutput(
      BaseResponseModel<ProductDetailEntity>(
        code: res.code,
        message: res.message,
        data: _productDetailMapper.mapToEntity(res.data),
      ),
    );
  }
}

class ProductManagerCreateInput extends BaseInput {
  final int id;
  final FormData productPayloadEntity;
  ProductManagerCreateInput(this.productPayloadEntity, this.id);
}

class ProductManagerCreateOutput extends BaseOutput {
  final BaseResponseModel<ProductDetailEntity> res;
  ProductManagerCreateOutput(this.res);
}
