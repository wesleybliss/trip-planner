import 'package:dio/dio.dart';

class ApiResponse<T> extends Response<T> {
  final bool success;
  final String? error;
  final String? message;
  final int? count;

  // Private constructor — no <T> here; class is already generic
  ApiResponse._({
    super.data,
    required super.requestOptions,
    super.statusCode,
    super.statusMessage,
    super.isRedirect,
    super.redirects,
    super.extra,
    super.headers,
    required this.success,
    this.error,
    this.message,
    this.count,
  });

  factory ApiResponse.fromResponse(Response<dynamic> response) {
    final rawData = response.data;

    if (rawData is! Map<String, dynamic>) {
      throw ArgumentError.value(
        rawData,
        'response.data',
        'Expected a JSON object with {success, data, ...}',
      );
    }

    final success = rawData['success'] as bool?;
    final message = rawData['message'] as String?;
    final error = rawData['error'] as String?;
    final count = rawData['count'] as int?;

    // Cast nested data to T?
    // This is safe if the caller specifies the correct T
    final nestedData = rawData['data'] as T?;

    return ApiResponse._(
      data: nestedData,
      requestOptions: response.requestOptions,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      isRedirect: response.isRedirect,
      redirects: response.redirects,
      extra: response.extra,
      headers: response.headers,
      success: success ?? false,
      error: error,
      message: message,
      count: count,
    );
  }

  @override
  String toString() {
    return 'ApiResponse(success: $success, statusCode: $statusCode, data: $data)';
  }
}
