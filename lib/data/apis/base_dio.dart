import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import '../../shared/constants/local_storage/app_shared_preference.dart';
import '../../shared/constants/pref_keys.dart';
import 'dio_logger.dart';
import 'end_point.dart';

@injectable
class BaseDio {
  // khởi tạo biến
  Dio? _instance;

  //method for getting dio instance
  Dio dio() {
    _instance = createDioInstance();
    return _instance!;
  }

  Dio createDioInstance() {
    late Dio dio;
    final token = AppSharedPreference.instance.getValue(PrefKeys.token);
    dio = Dio(
      BaseOptions(
        headers: {
          if (token != null) 'authorization': 'Token $token',
          'content-Type': 'application/json',
          'accept': 'application/json',
        },
      ),
    );
    // dio.options.connectTimeout = 5;
    // dio.options.receiveTimeout = 5;
    dio.interceptors.clear();
    dio.interceptors.addAll([
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // print(AppSharedPreference.instance.getValue(PrefKeys.TOKEN));
          // print(AppSharedPreference.instance.getValue(PrefKeys.TOKEN_REFRESH));
          return handler.next(options);
        },
        onResponse: (response, handler) {
          //on success it is getting called here
          return handler.next(response);
        },
        onError: (DioException error, handler) async {
          String message = 'Có lỗi hệ thống, vui lòng thử lại';
          // if (error.response?.data is Map) {
          //   message = error.response?.data['message'];
          // }
          if (error.response?.data is Map) {
            message = error.response?.data['message']?.toString() ?? 'Có lỗi hệ thống, vui lòng thử lại';
          }

          // error = message;
          // error.stackTrace = null;

          if (error.response?.statusCode == 401 || error.response?.statusCode == 403) {
            final accessToken = await _getNewToken();

            // Cập nhật token trong bộ nhớ đệm
            _saveTokenToStorage(accessToken);

            // Thử lại yêu cầu gốc
            final RequestOptions requestOptions = error.requestOptions;
            final opts = Options(method: requestOptions.method);
            dio.options.headers['Authorization'] = 'Token $accessToken';
            dio.options.headers['Accept'] = '*/*';
            final response = await dio.request(
              requestOptions.path,
              options: opts,
              cancelToken: requestOptions.cancelToken,
              onReceiveProgress: requestOptions.onReceiveProgress,
              data: requestOptions.data,
              queryParameters: requestOptions.queryParameters,
            );
            handler.resolve(response);
          } else {
            handler.next(error);
          }
        },
      ),
      PrettyDioLogger(requestBody: true),
      CurlLoggerDioInterceptor(printOnSuccess: true),
    ]);
    return dio;
  }

  Future<String> _getNewToken() async {
    try {
      final payload = {
        'refresh': '${AppSharedPreference.instance.getValue(PrefKeys.tokenRefresh)}',
      };
      final res = await Dio(
        BaseOptions(
          headers: {
            'Content-Type': 'application/json',
            'accept': 'application/json',
          },
        ),
      ).post(Api.refreshToken, data: payload);
      return res.data['access'];
    } catch (e) {
      throw Exception('err : $e');
    }
  }

  void _saveTokenToStorage(String token) {
    AppSharedPreference.instance.setValue(PrefKeys.token, token);
  }

// var dio = Dio(
//   BaseOptions(
//     headers: {
//       "authorization":
//           "Bearer ${AppSharedPreference.instance.getValue(PrefKeys.TOKEN)}",
//       "content-Type": "application/json",
//       "accept": "application/json",
//     },
//   ),
// );
}
