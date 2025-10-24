import 'package:injectable/injectable.dart';
import 'package:one_click/data/mapper/customer_mapper.dart';
import 'package:one_click/data/models/payload/customer/payload_customer.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/domain/entity/customer.dart';
import 'package:one_click/domain/entity/customer_create.dart';
import 'package:one_click/domain/repository/customer_repository.dart';
import 'package:one_click/domain/usecase/base/future/base_future_use_case.dart';
import 'package:one_click/domain/usecase/base/io/base_input.dart';
import 'package:one_click/domain/usecase/base/io/base_output.dart';

@injectable
class CustomerEditUseCase
    extends BaseFutureUseCase<CustomerEditInput, CustomerEditOutput> {
  final CustomerRepository _customerRepository;
  final CustomerEntityMapper _customerEntityMapper;
  CustomerEditUseCase(
    this._customerRepository,
    this._customerEntityMapper,
  );
  @override
  Future<CustomerEditOutput> buildUseCase(CustomerEditInput input) async {
    final payload = PayloadCustomerModel(
      fullName: input.customerCreateEntity.fullName,
      phone: input.customerCreateEntity.phone,
      gender: input.customerCreateEntity.gender,
      address: input.customerCreateEntity.address,
      email: input.customerCreateEntity.email,
      birthday: input.customerCreateEntity.birthday,
    );
    final res =
        await _customerRepository.edit(payload: payload, id: input.id ?? 0);
    return CustomerEditOutput(
      BaseResponseModel<CustomerEntity>(
        code: res.code,
        message: res.message,
        data: res.data == null
            ? null
            : _customerEntityMapper.mapToEntity(res.data),
      ),
    );
  }
}

class CustomerEditInput extends BaseInput {
  final CustomerCreateEntity customerCreateEntity;
  final int? id;
  CustomerEditInput(this.customerCreateEntity, this.id);
}

class CustomerEditOutput extends BaseOutput {
  final BaseResponseModel<CustomerEntity> responseModel;
  CustomerEditOutput(this.responseModel);
}
