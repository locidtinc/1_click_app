import 'package:injectable/injectable.dart';
import 'package:one_click/data/apis/base_dio.dart';
import 'package:one_click/data/apis/end_point.dart';
import 'package:one_click/presentation/di/di.dart';
import '../../domain/repository/login_repository.dart';

@LazySingleton(as: LoginRepository)
class LoginRepositoryImpl extends LoginRepository {
  @override
  Future<Map> login(String email, String password) async {
    final res = await getIt<BaseDio>().dio().post(
      Api.login,
      data: {
        'phone': email,
        'password': password,
        'system_code': Api.key,
      },
    );

    return res.data;
  }
}
