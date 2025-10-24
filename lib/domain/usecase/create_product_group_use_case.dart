import 'package:injectable/injectable.dart';
import 'package:one_click/data/mapper/product_group_mapper.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/domain/entity/group_detail_entity.dart';
import 'package:one_click/domain/entity/group_entity.dart';
import 'package:one_click/domain/repository/category_repository.dart';
import 'package:one_click/domain/usecase/base/base_use_case.dart';

@injectable
class CreateProductGroupUseCase extends BaseUseCaseInput<
    CreateProductGroupInput, BaseResponseModel<GroupDetailEntity>> {
  CreateProductGroupUseCase(
    this._repository,
    this._productGroupMapper,
  );

  final CategoryRepository _repository;
  final ProductGroupMapper _productGroupMapper;

  @override
  Future<BaseResponseModel<GroupDetailEntity>> execute(
      CreateProductGroupInput input) async {
    final res = await _repository.createGroup(
      title: input.title,
      product: input.product,
      productCategory: input.productCategory,
    );
    return BaseResponseModel<GroupDetailEntity>(
      code: res.code,
      message: res.message,
      data: _productGroupMapper.mapToEntity(res.data),
    );
  }
}

class CreateProductGroupInput {
  final String? title;
  final List<int>? product;
  final int? productCategory;

  CreateProductGroupInput({
    this.product,
    this.productCategory,
    this.title,
  });
}
