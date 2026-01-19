import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:trip_planner/models/api_response.dart';
import 'package:trip_planner/utils/logger.dart';

abstract class IDioClient {
  @protected
  abstract final Logger log;

  @protected
  abstract final Dio dio;

  Future<ApiResponse> get(String path, {Options? options});
  Future<ApiResponse> post(String path, {dynamic data, Options? options});
  Future<ApiResponse> put(String path, {dynamic data, Options? options});
  Future<ApiResponse> delete(String path, {dynamic data, Options? options});
}
