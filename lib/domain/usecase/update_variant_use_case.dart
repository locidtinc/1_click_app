import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/domain/repository/variant_repository.dart';
import 'package:one_click/domain/usecase/base/future/base_future_use_case.dart';
import 'package:one_click/domain/usecase/base/io/base_input.dart';
import 'package:one_click/domain/usecase/base/io/base_output.dart';

@injectable
class UpdateVariantUseCase
    extends BaseFutureUseCase<UpdateVariantInput, UpdateVariantOutput> {
  UpdateVariantUseCase(this._repository);

  final VariantRepository _repository;

  @override
  Future<UpdateVariantOutput> buildUseCase(UpdateVariantInput input) async {
    final res = await _repository.updateVariant(input.id, input.payload);
    return UpdateVariantOutput(res);
  }
}

class UpdateVariantInput extends BaseInput {
  UpdateVariantInput(this.id, this.payload);

  int id;
  FormData payload;
}

class UpdateVariantOutput extends BaseOutput {
  UpdateVariantOutput(this.res);

  BaseResponseModel res;
}
