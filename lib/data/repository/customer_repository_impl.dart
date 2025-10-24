import 'package:injectable/injectable.dart';
import 'package:one_click/data/apis/base_dio.dart';
import 'package:one_click/data/apis/end_point.dart';
import 'package:one_click/data/models/payload/customer/payload_customer.dart';
import 'package:one_click/data/models/response/base_response.dart';

import 'package:one_click/data/models/customer_model.dart';

import '../../domain/repository/customer_repository.dart';

@LazySingleton(as: CustomerRepository)
class CustomerRepositoryImpl extends CustomerRepository {
  final BaseDio _baseDio;
  CustomerRepositoryImpl(this._baseDio);
  @override
  Future<BaseResponseModel<List<CustomerModel>>> getList({
    required int page,
    required int limit,
    required String searchKey,
  }) async {
    final res = await _baseDio.dio().get(
          '${Api.customer}?page=$page&limit=$limit&search=$searchKey',
        );
    return BaseResponseModel<List<CustomerModel>>(
      code: res.data['code'],
      message: res.statusMessage,
      data: (res.data['data'] as List)
          .map((e) => CustomerModel.fromJson(e))
          .toList(),
    );
  }

  @override
  Future<BaseResponseModel> delete({required int id}) async {
    final res = await _baseDio.dio().delete('${Api.customer}$id/');
    print('ress ${{res.data}}');
    print('res.data${res.data['code']}');
    print('res.data ${res.data['message']}}');

    return BaseResponseModel(
      code: res.data['code'],
      message: res.data['message'],
      data: null,
    );
  }

  @override
  Future<BaseResponseModel<CustomerModel>> create({
    required PayloadCustomerModel payload,
  }) async {
    final data = await payload.toFormData();
    try {
      final res = await _baseDio.dio().post(Api.customer, data: data);
      return BaseResponseModel<CustomerModel>(
        code: res.data['code'],
        message: res.data['message'],
        data: res.data['code'] == 200
            ? CustomerModel.fromJson(res.data['data'])
            : null,
      );
    } catch (e) {
      return BaseResponseModel<CustomerModel>(
        code: 400,
        message: '$e',
        data: null,
      );
    }
  }

  @override
  Future<BaseResponseModel<CustomerModel>> edit({
    required PayloadCustomerModel payload,
    required int id,
  }) async {
    final data = await payload.toFormData();
    try {
      final res = await _baseDio.dio().put('${Api.customer}$id/', data: data);
      return BaseResponseModel<CustomerModel>(
        code: res.data['code'],
        message: res.statusMessage,
        data: res.data['code'] == 200
            ? CustomerModel.fromJson(res.data['data'])
            : null,
      );
    } catch (e) {
      return BaseResponseModel<CustomerModel>(
        code: 400,
        message: '$e',
        data: null,
      );
    }
  }
}
