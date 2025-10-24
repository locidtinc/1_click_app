import 'package:cross_file/src/types/interface.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/data/apis/base_dio.dart';
import 'package:one_click/data/apis/dio_logger.dart';
import 'package:one_click/data/apis/end_point.dart';
import 'package:one_click/data/mapper/store_information_mapper.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/data/models/store_model/address/type_data.dart';
import 'package:one_click/data/models/store_model/store_model.dart';
import 'package:one_click/domain/entity/store_entity.dart';
import 'package:one_click/domain/entity/store_information_payload.dart';
import 'package:one_click/domain/repository/store_repository.dart';
import 'package:one_click/presentation/di/di.dart';
import 'package:one_click/shared/constants/local_storage/app_shared_preference.dart';

import '../../shared/constants/pref_keys.dart';

@LazySingleton(as: StoreRepository)
class StoreRepositoryImpl extends StoreRepository {
  StoreRepositoryImpl(this._mapper);

  final StoreInformationMapper _mapper;

  @override
  Future<StoreEntity> getStoreInfo(int storeId) async {
    final res =
        await getIt.get<BaseDio>().dio().get('${Api.storeInfo}$storeId/');
    final data = StoreModel.fromJson(res.data['data']);
    if (data.warehouseData != null) {
      await AppSharedPreference.instance.setValue(
        PrefKeys.warehouseId,
        data.warehouseData?.id,
      );
    }
    return _mapper.mapToEntity(data);
  }

  @override
  Future<List<TypeData>> getListBusinessType({String? token}) async {
    if (token == null) {
      final res = await getIt.get<BaseDio>().dio().get(Api.businessType);
      final dataModel =
          (res.data['data'] as List).map((e) => TypeData.fromJson(e)).toList();
      return dataModel;
    }
    final dio = Dio(
      BaseOptions(
        headers: {
          'authorization': 'Token $token',
          'content-Type': 'application/json',
          'accept': 'application/json',
        },
      ),
    );
    dio.interceptors.add(PrettyDioLogger(requestBody: true));
    final res = await dio.get(Api.businessType);
    final dataModel =
        (res.data['data'] as List).map((e) => TypeData.fromJson(e)).toList();
    return dataModel;
  }

  @override
  Future<BaseResponseModel> updateStore(
    int storeId,
    StoreInformationPayload payload, {
    String? token,
  }) async {
    try {
      if (token == null) {
        final res = await getIt
            .get<BaseDio>()
            .dio()
            .post('${Api.storeInfo}$storeId/', data: payload.toJson());
        return BaseResponseModel(
          code: res.data['code'],
          message: res.data['message'],
          data: res.data['data'],
        );
      }
      final dio = Dio(
        BaseOptions(
          headers: {
            'authorization': 'Token $token',
            'content-Type': 'application/json',
            'accept': 'application/json',
          },
        ),
      );
      dio.interceptors.add(PrettyDioLogger(requestBody: true));
      final res =
          await dio.post('${Api.storeInfo}$storeId/', data: payload.toJson());
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: res.data['data'],
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: 'oopp lỗi rồi còn đâu',
        data: null,
      );
    }
  }

  @override
  Future<bool?> updateAddressStore(int storeId, AddressPayload payload) async {
    try {
      final res = await getIt
          .get<BaseDio>()
          .dio()
          .put('${Api.address}$storeId/', data: payload.toJson());
      return res.statusCode == 200;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<BaseResponseModel> putAvatar(
      {FormData? avatarImage, int? storeId}) async {
    try {
      final res = await getIt
          .get<BaseDio>()
          .dio()
          .put('${Api.avatar}/$storeId/', data: avatarImage);
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: res.data['data'],
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: 'oopp lỗi rồi còn đâu',
        data: null,
      );
    }
  }
}
