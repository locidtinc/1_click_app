import 'dart:convert';

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
class CustomerCreateUseCase
    extends BaseFutureUseCase<CustomerCreateInput, CustomerCreateOutput> {
  final CustomerRepository _customerRepository;
  final CustomerEntityMapper _customerEntityMapper;
  CustomerCreateUseCase(
    this._customerRepository,
    this._customerEntityMapper,
  );
  @override
  Future<CustomerCreateOutput> buildUseCase(CustomerCreateInput input) async {
    final payload = PayloadCustomerModel(
        image: input.customerCreateEntity.image,
        fullName: input.customerCreateEntity.fullName,
        phone: input.customerCreateEntity.phone,
        gender: input.customerCreateEntity.gender,
        address: input.customerCreateEntity.address,
        email: input.customerCreateEntity.email,
        birthday: input.customerCreateEntity.birthday,
        latLng: input.customerCreateEntity.latLng,
        province: input.customerCreateEntity.province,
        district: input.customerCreateEntity.district,
        ward: input.customerCreateEntity.ward,
        area: input.customerCreateEntity.area);

    final res = await _customerRepository.create(payload: payload);
    return CustomerCreateOutput(
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

class CustomerCreateInput extends BaseInput {
  final CustomerCreateEntity customerCreateEntity;
  CustomerCreateInput(this.customerCreateEntity);
}

class CustomerCreateOutput extends BaseOutput {
  final BaseResponseModel<CustomerEntity> responseModel;
  CustomerCreateOutput(this.responseModel);
}
