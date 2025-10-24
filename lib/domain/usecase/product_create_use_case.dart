import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/data/mapper/product_detail_mapper.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/domain/entity/product_detail_entity.dart';
import 'package:one_click/domain/repository/product_repository.dart';
import 'package:one_click/domain/usecase/base/future/base_future_use_case.dart';
import 'package:one_click/domain/usecase/base/io/base_input.dart';
import 'package:one_click/domain/usecase/base/io/base_output.dart';

@injectable
class ProductCreateUseCase
    extends BaseFutureUseCase<ProductCreateInput, ProductCreateOutput> {
  final ProductRepository _productRepository;
  final ProductDetailMapper _productDetailMapper;

  ProductCreateUseCase(this._productRepository, this._productDetailMapper);

  @override
  Future<ProductCreateOutput> buildUseCase(ProductCreateInput input) async {
    final res =
        await _productRepository.createProduct(input.productPayloadEntity);
    return ProductCreateOutput(
      BaseResponseModel<ProductDetailEntity>(
        code: res.code,
        message: res.message,
        data: _productDetailMapper.mapToEntity(res.data),
      ),
    );
  }
}

class ProductCreateInput extends BaseInput {
  final FormData productPayloadEntity;
  ProductCreateInput(this.productPayloadEntity);
}

class ProductCreateOutput extends BaseOutput {
  final BaseResponseModel<ProductDetailEntity> res;
  ProductCreateOutput(this.res);
}
