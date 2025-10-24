import 'package:injectable/injectable.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/domain/repository/category_repository.dart';
import 'package:one_click/domain/usecase/base/future/base_future_use_case.dart';
import 'package:one_click/domain/usecase/base/io/base_input.dart';
import 'package:one_click/domain/usecase/base/io/base_output.dart';

@injectable
class GroupCreateUseCase
    extends BaseFutureUseCase<GroupCreateInput, GroupCreateOutput> {
  final CategoryRepository _categoryRepository;
  GroupCreateUseCase(this._categoryRepository);
  @override
  Future<GroupCreateOutput> buildUseCase(GroupCreateInput input) async {
    final res = await _categoryRepository.createGroup(
      title: input.title,
      product: input.product,
      productCategory: input.productCategory,
    );
    return GroupCreateOutput(res);
  }
}

class GroupCreateInput extends BaseInput {
  final String title;
  final List<int> product;
  final int? productCategory;
  GroupCreateInput({
    required this.product,
    required this.productCategory,
    required this.title,
  });
}

class GroupCreateOutput extends BaseOutput {
  final BaseResponseModel response;
  GroupCreateOutput(this.response);
}
