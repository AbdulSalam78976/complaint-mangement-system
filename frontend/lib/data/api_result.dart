class ApiResult<T> {
  final T? data;
  final String? errorMessage;
  final int? statusCode; // ✅ added for better error handling

  ApiResult.success(this.data) : errorMessage = null, statusCode = null;

  ApiResult.failure(this.errorMessage, {this.statusCode}) : data = null;

  bool get isSuccess => errorMessage == null;
}
