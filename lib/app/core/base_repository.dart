import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../shared/utils/my_getstorage.dart';
import '../services/my_config.dart';

class BaseRepository {
  static String baseUrl = "";
  final Dio _dio = Dio();

  BaseRepository() {
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);

    _dio.interceptors.add(ChuckerDioInterceptor());
  }

  static Future<Map<String, String>> get apiAuth async {
    var locale =
        await MyGetStorage.getString(key: MyConfig.keyLocale) ?? "en_US";

    var accessToken = await MyGetStorage.getString(
      key: MyConfig.keyAccessToken,
    );

    Map<String, String> authHeaders = {
      "Accept-Language": locale.split("_")[0],
      "Cart-Authorization": "Bearer $accessToken",
    };

    print("Header: $authHeaders");

    return authHeaders;
  }

  static String get url {
    if (MyConfig.prod) {
      baseUrl = dotenv.env["API_URL"]!;
    } else {
      baseUrl = dotenv.env["API_URL_STAGING"]!;
    }
    return baseUrl;
  }

  static String get urlECommerce {
    if (MyConfig.prod) {
      baseUrl = dotenv.env["API_URL_ECOMMERCE"]!;
    } else {
      baseUrl = dotenv.env["API_URL_ECOMMERCE_STAGING"]!;
    }
    return baseUrl;
  }

  Future<ResponseHandler<dynamic>> fetch({
    bool isMap = false,
    bool isEcommerce = false,
    bool useHeader = true,
    dynamic verEndpoint = "v1",
    required String endPoint,
    Map<String, dynamic>? custHeaders,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    var headers = await apiAuth;

    final response = _dio.get(
      "${(isMap)
          ? dotenv.env["API_URL_MAP"]
          : (isEcommerce)
          ? urlECommerce
          : url}/$verEndpoint$endPoint",
      queryParameters: queryParameters,
      options: (custHeaders != null)
          ? Options(headers: {...headers, ...custHeaders})
          : (isMap)
          ? Options(headers: {'User-Agent': 'FlutterMap Search Demo App'})
          : (useHeader)
          ? Options(headers: headers)
          : null,
      cancelToken: cancelToken,
    );

    return ResponseHandler(response);
  }

  Future<ResponseHandler<dynamic>> postJson({
    bool isEcommerce = false,
    bool useHeader = true,
    dynamic verEndpoint = "v1",
    required String endPoint,
    Map<String, dynamic>? custHeaders,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    var headers = await apiAuth;
    if (data != null) headers["Content-Type"] = "application/json";

    final response = _dio.post(
      "${(isEcommerce) ? urlECommerce : url}/$verEndpoint$endPoint",
      data: data,
      queryParameters: queryParameters,
      options: (custHeaders != null)
          ? Options(headers: {...headers, ...custHeaders})
          : (useHeader)
          ? Options(headers: headers)
          : null,
      cancelToken: cancelToken,
    );

    return ResponseHandler(response);
  }

  Future<ResponseHandler<dynamic>> postForm({
    bool isEcommerce = false,
    bool useHeader = true,
    dynamic verEndpoint = "v1",
    required String endPoint,
    Map<String, dynamic>? custHeaders,
    required FormData data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    var headers = await apiAuth;

    final response = _dio.post(
      "${(isEcommerce) ? urlECommerce : url}/$verEndpoint$endPoint",
      data: data,
      queryParameters: queryParameters,
      options: (custHeaders != null)
          ? Options(headers: {...headers, ...custHeaders})
          : (useHeader)
          ? Options(headers: headers)
          : null,
      cancelToken: cancelToken,
    );

    return ResponseHandler(response);
  }

  Future<ResponseHandler<dynamic>> putJson({
    bool isEcommerce = false,
    bool useHeader = true,
    dynamic verEndpoint = "v1",
    bool withHeaders = true,
    required String endPoint,
    Map<String, dynamic>? custHeaders,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    if (withHeaders) {
      headers = await apiAuth;
    } else {
      var auth = headers!["token"];
      var locale =
          await MyGetStorage.getString(key: MyConfig.keyLocale) ?? "en_US";

      headers = {
        "Authorization": "Bearer $auth",
        "Accept-Language": locale.split("_")[0],
        "origin": "mobile",
      };
    }
    if (data != null) headers["Content-Type"] = "application/json";

    final response = _dio.put(
      "${(isEcommerce) ? urlECommerce : url}/$verEndpoint$endPoint",
      data: data,
      queryParameters: queryParameters,
      options: (custHeaders != null)
          ? Options(headers: {...headers, ...custHeaders})
          : (useHeader)
          ? Options(headers: headers)
          : null,
      cancelToken: cancelToken,
    );

    return ResponseHandler(response);
  }

  Future<ResponseHandler<dynamic>> putForm({
    bool isEcommerce = false,
    bool useHeader = true,
    dynamic verEndpoint = "v1",
    required String endPoint,
    Map<String, dynamic>? custHeaders,
    required FormData data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    var headers = await apiAuth;

    final response = _dio.put(
      "${(isEcommerce) ? urlECommerce : url}/$verEndpoint$endPoint",
      data: data,
      queryParameters: queryParameters,
      options: (custHeaders != null)
          ? Options(headers: {...headers, ...custHeaders})
          : (useHeader)
          ? Options(headers: headers)
          : null,
      cancelToken: cancelToken,
    );

    return ResponseHandler(response);
  }

  Future<ResponseHandler<dynamic>> delete({
    bool isEcommerce = false,
    bool useHeader = true,
    dynamic verEndpoint = "v1",
    required String endPoint,
    Map<String, dynamic>? custHeaders,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    var headers = await apiAuth;
    if (data != null) headers["Content-Type"] = "application/json";

    final response = _dio.delete(
      "${(isEcommerce) ? urlECommerce : url}/$verEndpoint$endPoint",
      data: data,
      queryParameters: queryParameters,
      options: (custHeaders != null)
          ? Options(headers: {...headers, ...custHeaders})
          : (useHeader)
          ? Options(headers: headers)
          : null,
      cancelToken: cancelToken,
    );

    return ResponseHandler(response);
  }
}

class ResponseHandler<T> {
  final Future<Response> _response;
  ResponseHandler(this._response);

  Future responseHandler({
    required Function(T res) res,
    required Function(dynamic err) err,
  }) async {
    try {
      // loading();
      final response = await _response;
      // done();
      // print(response.data);

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        res(response.data);
      } else {
        err(response.data["message"] ?? "Unknown error occurred");
      }
    } on DioException catch (e) {
      // done();

      print(e.response);
      print(e.response!.statusCode);
      print(e.response!.data);
      if (e.response != null) {
        if (e.response!.statusCode == 502) {
          err("502 Bad Gateway");
        } else {
          err(
            e.response!.data["message"] ?? e.response!.data["error"]["message"],
          );
        }
      } else {
        err("Unexpected error occurred");
      }
    }
  }
}
