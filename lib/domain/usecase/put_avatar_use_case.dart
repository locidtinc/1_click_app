import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/domain/repository/store_repository.dart';
import 'package:one_click/domain/usecase/base/future/base_future_use_case.dart';
import 'package:one_click/domain/usecase/base/io/base_input.dart';
import 'package:one_click/domain/usecase/base/io/base_output.dart';

@injectable
class PutAvatarUseCase
    extends BaseFutureUseCase<PutAvatarInput, PutAvatarOutput> {
  final StoreRepository _repository;
  PutAvatarUseCase(this._repository);

  @override
  Future<PutAvatarOutput> buildUseCase(PutAvatarInput input) async {
    final res = await _repository.putAvatar(
        avatarImage: input.avatarImage, storeId: input.storeId);
    return PutAvatarOutput(
      BaseResponseModel(
        code: res.code,
        message: res.message,
        data: null,
      ),
    );
  }
}

class PutAvatarInput extends BaseInput {
  final FormData avatarImage;
  final int storeId;
  PutAvatarInput(this.avatarImage, this.storeId);
}

class PutAvatarOutput extends BaseOutput {
  final BaseResponseModel response;
  PutAvatarOutput(this.response);
}
