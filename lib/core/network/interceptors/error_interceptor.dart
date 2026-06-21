import 'package:dio/dio.dart';

class NetworkError implements Exception {
  final String message;
  NetworkError(this.message);
}

class ClientError implements Exception {
  final String message;
  ClientError(this.message);
}

class ServerError implements Exception {
  final String message;
  ServerError(this.message);
}

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.type == DioExceptionType.connectionError) {
      handler.reject(DioException(
        requestOptions: err.requestOptions,
        error: NetworkError('Network connection error'),
      ));
    } else if (err.response != null) {
      final status = err.response?.statusCode ?? 0;
      if (status >= 400 && status < 500) {
        handler.reject(DioException(
          requestOptions: err.requestOptions,
          error: ClientError('Client error: ${err.message}'),
        ));
      } else if (status >= 500) {
        handler.reject(DioException(
          requestOptions: err.requestOptions,
          error: ServerError('Server error: ${err.message}'),
        ));
      } else {
        handler.next(err);
      }
    } else {
      handler.next(err);
    }
  }
}
