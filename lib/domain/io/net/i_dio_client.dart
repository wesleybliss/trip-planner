
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:trip_planner/utils/logger.dart';

abstract class IDioClient {
  
  @protected
  abstract final Logger log;
  
  @protected
  abstract final Dio dio;

  Future<Response> get(String path, {Options? options});
  Future<Response> post(String path, {dynamic data, Options? options});
  Future<Response> put(String path, {dynamic data, Options? options});
  Future<Response> delete(String path, {dynamic data, Options? options});
}
