import 'package:one_click/data/models/customer_model.dart';
import 'package:one_click/data/models/response/base_response.dart';

import '../../data/models/payload/customer/payload_customer.dart';

abstract class CustomerRepository {
  Future<BaseResponseModel<List<CustomerModel>>> getList({
    required int page,
    required int limit,
    required String searchKey,
  });

  Future<BaseResponseModel> delete({required int id});

  Future<BaseResponseModel<CustomerModel>> create({
    required PayloadCustomerModel payload,
  });

  Future<BaseResponseModel<CustomerModel>> edit({
    required PayloadCustomerModel payload,
    required int id,
  });
}
