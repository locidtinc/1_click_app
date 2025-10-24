import 'package:injectable/injectable.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/domain/repository/customer_repository.dart';
import 'package:one_click/domain/usecase/base/future/base_future_use_case.dart';
import 'package:one_click/domain/usecase/base/io/base_input.dart';
import 'package:one_click/domain/usecase/base/io/base_output.dart';

@injectable
class CustomerDeleteUseCase
    extends BaseFutureUseCase<CustomerDeleteInput, CustomerDeleteOutput> {
  final CustomerRepository _customerRepository;
  CustomerDeleteUseCase(this._customerRepository);

  @override
  Future<CustomerDeleteOutput> buildUseCase(CustomerDeleteInput input) async {
    final res = await _customerRepository.delete(id: input.id);
    return CustomerDeleteOutput(
      BaseResponseModel(
        code: res.code,
        message: res.message,
        data: null,
      ),
    );
  }
}

class CustomerDeleteInput extends BaseInput {
  final int id;
  CustomerDeleteInput(this.id);
}

class CustomerDeleteOutput extends BaseOutput {
  final BaseResponseModel response;
  CustomerDeleteOutput(this.response);
}
