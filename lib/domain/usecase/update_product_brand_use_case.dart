import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/domain/entity/brand_detail_entity.dart';
import 'package:one_click/domain/repository/product_brand_repository.dart';
import 'package:one_click/domain/usecase/base/base_use_case.dart';

@injectable
class UpdateProductBrandUseCase extends BaseUseCaseInput<UpdateBrandInput,
    BaseResponseModel<BrandDetailEntity>> {
  UpdateProductBrandUseCase(this._repository);

  final ProductBrandRepository _repository;

  @override
  Future<BaseResponseModel<BrandDetailEntity>> execute(
      UpdateBrandInput input) async {
    final res = await _repository.updateProductBrand(
      input.id,
      input.title,
      input.product,
      input.image,
    );

    return res;
  }
}

class UpdateBrandInput {
  UpdateBrandInput(this.id, this.title, this.product, this.image);

  int id;
  String title;
  List<int> product;
  File? image;
}
