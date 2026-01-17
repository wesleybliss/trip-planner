import 'package:dio/dio.dart';
import 'package:trip_planner/domain/constants/constants.dart';
import 'package:trip_planner/domain/io/net/i_dio_client.dart';
import 'package:trip_planner/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));
  }
  
  @override
  Future<Response> get(String path) async {
    log.d('GET $path');
    
    final prefs = await SharedPreferences.getInstance();
    final disableCache = prefs.getBool(Constants.keys.settings.disableCache) ?? false;
    
    Options? options;
    String finalPath = path;
    
    if (disableCache) {
      log.d('HTTP caching disabled - adding cache-busting headers and timestamp');
      options = Options(
        headers: {
          'Cache-Control': 'no-cache, no-store, must-revalidate',
          'Pragma': 'no-cache',
          'Expires': '0',
        },
      );
      
      final separator = path.contains('?') ? '&' : '?';
      finalPath = '$path${separator}_ts=${DateTime.now().millisecondsSinceEpoch}';
    }
    
    final res = await dio.get(finalPath, options: options);
    return res;
  }

  @override
  Future<Response> post(String path, {dynamic data}) async {
    log.d('POST $path');
    return await dio.post(path, data: data);
  }

  @override
  Future<Response> put(String path, {dynamic data}) async {
    log.d('PUT $path');
    return await dio.put(path, data: data);
  }

  @override
  Future<Response> delete(String path, {dynamic data}) async {
    log.d('DELETE $path');
    return await dio.delete(path, data: data);
  }
}
