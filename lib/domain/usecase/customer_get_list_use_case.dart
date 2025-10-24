import 'package:injectable/injectable.dart';
import 'package:one_click/data/mapper/customer_mapper.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/domain/entity/customer.dart';
import 'package:one_click/domain/usecase/base/future/base_future_use_case.dart';
import 'package:one_click/domain/usecase/base/io/base_input.dart';
import 'package:one_click/domain/usecase/base/io/base_output.dart';

import '../repository/customer_repository.dart';

@injectable
class CustomerGetListUseCase
    extends BaseFutureUseCase<CustomerGetListInput, CustomerGetListOutput> {
  final CustomerRepository _customerRepository;
  final CustomerEntityMapper _customerEntityMapper;
  CustomerGetListUseCase(
    this._customerRepository,
    this._customerEntityMapper,
  );
  @override
  Future<CustomerGetListOutput> buildUseCase(CustomerGetListInput input) async {
    final res = await _customerRepository.getList(
      page: input.page,
      limit: input.limit,
      searchKey: input.searchKey,
    );
    return CustomerGetListOutput(
      BaseResponseModel<List<CustomerEntity>>(
        code: res.code,
        message: res.message,
        data: _customerEntityMapper.mapToListEntity(res.data),
      ),
    );
  }
}

class CustomerGetListInput extends BaseInput {
  final int page;
  final int limit;
  final String searchKey;
  CustomerGetListInput(this.searchKey, this.limit, this.page);
}

class CustomerGetListOutput extends BaseOutput {
  final BaseResponseModel<List<CustomerEntity>> response;
  CustomerGetListOutput(this.response);
}
