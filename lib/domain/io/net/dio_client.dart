import 'package:dio/dio.dart';
import 'package:trip_planner/domain/constants/constants.dart';
import 'package:trip_planner/domain/io/net/i_dio_client.dart';
import 'package:trip_planner/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spot_di/spot_di.dart';
import 'package:trip_planner/services/auth_service.dart';

class DioClient implements IDioClient {
  
  @override
  final log = Logger('DioClient');
  
  @override
  final Dio dio;

  DioClient() : dio = Dio(BaseOptions(
    baseUrl: Constants.strings.baseUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
  )) {
    dio.interceptors.add(LogInterceptor(responseBody: true));
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        try {
          // Get AuthService from DI container
          final authService = spot<AuthService>();
          
          // Get ID token from AuthService
          final token = await authService.getIdToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
        } catch (e) {
          log.e('Failed to get ID token', e);
        }
        return handler.next(options);
      },
    ));
  }
  
  @override
  Future<Response> get(String path, {Options? options}) async {
    log.d('GET $path');
    
    final prefs = await SharedPreferences.getInstance();
    final disableCache = prefs.getBool(Constants.keys.settings.disableCache) ?? false;
    
    Options? requestOptions = options;
    String finalPath = path;
    
    if (disableCache) {
      log.d('HTTP caching disabled - adding cache-busting headers and timestamp');
      requestOptions = (options ?? Options()).copyWith(
        headers: {
          ...?options?.headers,
          'Cache-Control': 'no-cache, no-store, must-revalidate',
          'Pragma': 'no-cache',
          'Expires': '0',
        },
      );
      
      final separator = path.contains('?') ? '&' : '?';
      finalPath = '$path${separator}_ts=${DateTime.now().millisecondsSinceEpoch}';
    }
    
    final res = await dio.get(finalPath, options: requestOptions);
    return res;
  }

  @override
  Future<Response> post(String path, {dynamic data, Options? options}) async {
    log.d('POST $path');
    return await dio.post(path, data: data, options: options);
  }

  @override
  Future<Response> put(String path, {dynamic data, Options? options}) async {
    log.d('PUT $path');
    return await dio.put(path, data: data, options: options);
  }

  @override
  Future<Response> delete(String path, {dynamic data, Options? options}) async {
    log.d('DELETE $path');
    return await dio.delete(path, data: data, options: options);
  }
}
