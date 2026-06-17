import 'package:dio/dio.dart';

import 'config.dart';
import 'session_manager.dart';

class ApiClient {
  ApiClient._() {
    dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: const Duration(seconds: 25),
        receiveTimeout: const Duration(seconds: 60),
        sendTimeout: const Duration(seconds: 120),
      ),
    );
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = SessionManager.instance.accessToken;
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          final request = error.requestOptions;
          final refreshToken = SessionManager.instance.refreshToken;
          final shouldRefresh = error.response?.statusCode == 401 &&
              refreshToken != null &&
              request.extra['retried'] != true &&
              !request.path.contains('/auth/login') &&
              !request.path.contains('/auth/refresh-token');

          if (!shouldRefresh) {
            handler.next(error);
            return;
          }

          try {
            final refreshDio = Dio(BaseOptions(baseUrl: AppConfig.apiBaseUrl));
            final response = await refreshDio.post<Map<String, dynamic>>(
              '/auth/refresh-token',
              data: {'refreshToken': refreshToken},
            );
            final newToken = response.data?['accessToken'] as String?;
            if (newToken == null || newToken.isEmpty) {
              throw DioException(
                requestOptions: request,
                message: 'Access token não retornado',
              );
            }

            await SessionManager.instance.updateAccessToken(newToken);
            request.headers['Authorization'] = 'Bearer $newToken';
            request.extra['retried'] = true;

            final cloned = await dio.fetch(request);
            handler.resolve(cloned);
            return;
          } catch (_) {
            await SessionManager.instance.clear();
            handler.next(error);
            return;
          }
        },
      ),
    );
  }

  static final ApiClient instance = ApiClient._();

  late final Dio dio;
}
