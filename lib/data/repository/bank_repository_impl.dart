import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:one_click/data/apis/base_dio.dart';
import 'package:one_click/data/apis/dio_logger.dart';
import 'package:one_click/data/apis/end_point.dart';
import 'package:one_click/data/models/bank_payload.dart';
import 'package:one_click/data/models/card_model.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/data/models/store_model/bank_data.dart' as bank;
import 'package:one_click/domain/repository/bank_repository.dart';

@LazySingleton(as: BankRepository)
class BankRepositoryImpl extends BankRepository {
  BankRepositoryImpl(this._baseDio);

  final BaseDio _baseDio;

  @override
  Future<List<bank.BankData>> getListBank({
    String? token,
  }) async {
    if (token == null) {
      final res = await _baseDio.dio().get('${Api.bankList}?limit=60');
      final dataModel = (res.data['data'] as List)
          .map((e) => bank.BankData.fromJson(e))
          .toList();
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
    final res = await dio.get('${Api.bankList}?limit=60');
    final dataModel = (res.data['data'] as List)
        .map((e) => bank.BankData.fromJson(e))
        .toList();
    return dataModel;
  }

  @override
  Future<String?> checkCard(
    String bin,
    String accountNumber,
    String transferType,
  ) async {
    final body = {
      'bin': bin,
      'accountNumber': accountNumber,
      'transferType': transferType,
    };
    final res = await _baseDio.dio().post(Api.checkCard, data: body);
    if (res.statusCode == 200) {
      return res.data['data'];
    }
    return null;
  }

  @override
  Future<BaseResponseModel<CardModel>> addCard(
    BankPayload payload, {
    String? token,
  }) async {
    try {
      if (token == null) {
        final res = await _baseDio.dio().post(Api.card, data: payload.toJson());
        return BaseResponseModel(
          code: res.data['code'],
          message: res.data['message'],
          data: CardModel.fromJson(res.data['data']),
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
      final res = await dio.post(Api.card, data: payload.toJson());
      if (res.statusCode == 200) {
        return BaseResponseModel(
          code: res.statusCode,
          message: res.data['message'],
          data: CardModel.fromJson(res.data['data']),
        );
      }
      return BaseResponseModel(
        code: res.statusCode,
        message: res.data['message'],
      );
    } on DioError catch (e) {
      return BaseResponseModel(
        code: e.response?.statusCode,
        message: e.response?.data['card_number'][0],
      );
    }
  }

  @override
  Future<BaseResponseModel<CardModel>> updateCard(
    int cardId,
    BankPayload payload,
  ) async {
    try {
      final res = await _baseDio
          .dio()
          .put('${Api.card}$cardId/', data: payload.toJson());
      return BaseResponseModel(
        code: res.data['code'],
        message: res.data['message'],
        data: CardModel.fromJson(res.data['data']),
      );
    } catch (e) {
      return BaseResponseModel(code: 500, message: 'Server error');
    }
  }
}
