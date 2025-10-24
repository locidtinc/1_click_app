import 'package:injectable/injectable.dart';
import 'package:one_click/data/apis/base_dio.dart';
import 'package:one_click/data/apis/end_point.dart';
import 'package:one_click/domain/repository/gms_repository.dart';
import 'package:one_click/shared/constants/pref_keys.dart';

import '../models/gms_model/geocode_model.dart';
import '../models/gms_model/place_auto_complete_model.dart';
import '../models/response/base_response.dart';

@LazySingleton(as: GMSRepository)
class GMSRepositoryImpl extends GMSRepository {
  final BaseDio _dio;

  GMSRepositoryImpl(this._dio);

  @override
  Future<BaseResponseModel<List<PlaceAutoCompleteModel>>> placesAutocomplete({
    required String address,
  }) async {
    final res = await _dio.dio().get(
          '${Api.urlGMS}/place/autocomplete/json?input=$address&language=vn&key=${PrefKeys.GMSToken}',
        );
    try {
      return BaseResponseModel(
        code: res.statusCode,
        data: (res.data['predictions'] as List)
            .map((e) => PlaceAutoCompleteModel.fromJson(e))
            .toList(),
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }

  @override
  Future<void> placesDetail() async {
    throw UnimplementedError();
  }

  @override
  Future<BaseResponseModel<GeocodeModel>> geocoding({
    String? address,
    String? placeId,
  }) async {
    final res = await _dio.dio().get(
        '${Api.urlGMS}/geocode/json?key=${PrefKeys.GMSToken}${address != null ? '&address=$address' : ''}${placeId != null ? '&place_id=$placeId' : ''}');
    try {
      return BaseResponseModel(
        code: res.statusCode,
        data: GeocodeModel.fromJson(res.data['results'][0]),
      );
    } catch (e) {
      return BaseResponseModel(
        code: 400,
        message: e.toString(),
      );
    }
  }
}
