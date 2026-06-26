import 'package:dio/dio.dart';
import '../../app/config/env.dart';
import 'interceptors.dart';

//dio client class -- using this class we will calling the api
class DioClient {
  final Dio _dio;

  DioClient(this._dio) {
    _dio
      ..options.baseUrl = Env.baseUrl
      ..options.connectTimeout = const Duration(
        milliseconds: Env.connectionTimeout,
      )
      ..options.receiveTimeout = const Duration(
        milliseconds: Env.receiveTimeout,
      )
      ..options.headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'x-api-key': Env.apiKey,
      }
      ..interceptors.addAll([
        AppInterceptors(),
        if (Env.debugLogging)
          LogInterceptor(requestBody: true, responseBody: true),
      ]);
  }

  Dio get dio => _dio;

  Future<Response> get(
    String uri, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.get(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioException {
      rethrow;
    }
  }

  Future<Response> post(
    String uri, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioException {
      rethrow;
    }
  }
}
