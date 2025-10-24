import 'package:dio/dio.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/data/models/store_model/address/type_data.dart';
import 'package:one_click/domain/entity/store_entity.dart';
import 'package:one_click/domain/entity/store_information_payload.dart';
import 'package:share_plus/share_plus.dart';

abstract class StoreRepository {
  Future<StoreEntity> getStoreInfo(int storeId);

  Future<List<TypeData>> getListBusinessType({String? token});

  Future<BaseResponseModel> updateStore(
    int storeId,
    StoreInformationPayload payload, {
    String? token,
  });

  Future<bool?> updateAddressStore(int storeId, AddressPayload payload);

  Future<BaseResponseModel> putAvatar({FormData avatarImage, int storeId});
}
