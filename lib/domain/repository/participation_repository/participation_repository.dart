import 'package:one_click/data/apis/base_dio.dart';
import 'package:one_click/data/models/participation_even_model.dart';
import 'package:one_click/data/models/response/base_response.dart';
import 'package:one_click/presentation/di/di.dart';

class ParticipationRepository {
  final _dio = getIt<BaseDio>();

  Future<BaseResponseModel<List<ParticipationEvenModel>>> getListParticipation({
    int? page,
    int? limit,
    String? searchKey,
  }) async {
    try {
      final res = await _dio.dio().get(
            'http://api.1click.vn/account/api/list-participation-even/',
          );
      return BaseResponseModel<List<ParticipationEvenModel>>(
        code: res.data?['code'] ?? 0,
        message: res.data?['message'] ?? res.statusMessage ?? '',
        data: (res.data?['data'] as List? ?? [])
            .map((e) => ParticipationEvenModel.fromJson(e))
            .toList(),
      );
    } catch (e, st) {
      return BaseResponseModel<List<ParticipationEvenModel>>(
        code: -1,
        message: e.toString(),
        data: [],
      );
    }
  }
}
