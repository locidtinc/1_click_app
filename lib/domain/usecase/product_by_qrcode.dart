import 'package:injectable/injectable.dart';
import 'package:one_click/data/mapper/product_detail_mapper.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/domain/entity/product_detail_entity.dart';
import 'package:one_click/domain/repository/product_repository.dart';
import 'package:one_click/domain/usecase/base/future/base_future_use_case.dart';
import 'package:one_click/domain/usecase/base/io/base_input.dart';
import 'package:one_click/domain/usecase/base/io/base_output.dart';

@injectable
class ProductByQrcodeUseCase
    extends BaseFutureUseCase<ProductByQrcodeInput, ProductByQrcodeOutput> {
  final ProductRepository _productRepository;
  final ProductDetailMapper _productDetailMapper;
  ProductByQrcodeUseCase(this._productRepository, this._productDetailMapper);
  @override
  Future<ProductByQrcodeOutput> buildUseCase(ProductByQrcodeInput input) async {
    final res = await _productRepository.getByQrcode(input.qrcode ?? '');
    return ProductByQrcodeOutput(
      BaseResponseModel<List<ProductDetailEntity>>(
        code: res.code,
        message: res.message,
        data: _productDetailMapper.mapToListEntity(res.data),
      ),
    );
  }
}

class ProductByQrcodeInput extends BaseInput {
  final String? qrcode;
  ProductByQrcodeInput(this.qrcode);
}

class ProductByQrcodeOutput extends BaseOutput {
  final BaseResponseModel<List<ProductDetailEntity>> response;
  ProductByQrcodeOutput(this.response);
}
