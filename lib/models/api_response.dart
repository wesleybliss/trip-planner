class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? error;
  final String? message;
  final int? count;

  ApiResponse({
    required this.success,
    this.data,
    this.error,
    this.message,
    this.count,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] as bool,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      error: json['error'] as String?,
      message: json['message'] as String?,
      count: json['count'] as int?,
    );
  }
}
