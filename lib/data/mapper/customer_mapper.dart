import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:one_click/data/mapper/base/base_data_mapper.dart';
import 'package:one_click/domain/entity/customer.dart';
import 'package:one_click/domain/entity/store_entity.dart';

import '../models/customer_model.dart';

@injectable
class CustomerEntityMapper
    extends BaseDataMapper<CustomerModel, CustomerEntity> {
  @override
  CustomerEntity mapToEntity(CustomerModel? data) {
    return CustomerEntity(
      id: data?.id,
      fullName: data?.fullName,
      code: data?.code,
      phone: data?.phone,
      email: data?.email,
      address: data?.address == null
          ? null
          : AddressEntity(
              id: data?.address?.id ?? 0,
              address: data?.address?.title,
              lat: data?.address?.lat ?? 0,
              long: data?.address?.long ?? 0,
            ),
      birthday: data?.birthday == null
          ? ''
          : DateFormat('dd/MM/y').format(data?.birthday ?? DateTime.now()),
      image: data?.image,
      gender: data?.gender ?? 1,
      shop: data?.shop ?? [],
    );
  }
}
