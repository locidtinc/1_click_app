import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:one_click/data/mapper/brand_mapper.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/domain/entity/brand.dart';
import 'package:one_click/domain/repository/category_repository.dart';
import 'package:one_click/domain/usecase/base/future/base_future_use_case.dart';
import 'package:one_click/domain/usecase/base/io/base_input.dart';

import 'base/io/base_output.dart';

@injectable
class BrandCreateUseCase
    extends BaseFutureUseCase<BrandCreateInput, BrandCreateOutput> {
  final CategoryRepository _categoryRepository;
  final BrandEntityMapper _brandEntityMapper;
  BrandCreateUseCase(this._categoryRepository, this._brandEntityMapper);
  @override
  Future<BrandCreateOutput> buildUseCase(BrandCreateInput input) async {
    final res = await _categoryRepository.createBrand(
      title: input.title,
      product: input.product,
      group: input.group,
      image: input.image,
      productBrand: input.productBrand,
    );
    return BrandCreateOutput(
      BaseResponseModel<BrandEntity>(
        code: res.code,
        message: res.message,
        data: _brandEntityMapper.mapToEntity(res.data),
      ),
    );
  }
}

class BrandCreateInput extends BaseInput {
  final String title;
  final List<int> product;
  final List<ProductBrand> productBrand;
  final List<int> group;
  final File? image;
  BrandCreateInput({
    required this.group,
    required this.product,
    required this.title,
    this.image,
    required this.productBrand,
  });
}

class BrandCreateOutput extends BaseOutput {
  final BaseResponseModel<BrandEntity> response;
  BrandCreateOutput(this.response);
}

class ProductBrand {
  final int product;
  final int brand;

  const ProductBrand({
    required this.product,
    required this.brand,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['brand'] = brand;
    data['product'] = product;
    return data;
  }
}
