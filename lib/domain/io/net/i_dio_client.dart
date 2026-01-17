
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:trip_planner/utils/logger.dart';

abstract class IDioClient {
  
  @protected
  abstract final Logger log;
  
  @protected
  abstract final Dio dio;

  Future<Response> get(String path);
  Future<Response> post(String path, {dynamic data});
  Future<Response> put(String path, {dynamic data});
  Future<Response> delete(String path, {dynamic data});
}
