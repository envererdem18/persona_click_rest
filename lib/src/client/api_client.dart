import 'dart:io';

import 'package:dio/dio.dart';

/// A Dio interceptor that safely handles malformed Set-Cookie headers.
///
/// Dart's built-in HTTP stack throws an [HttpException] when it encounters
/// a `SameSite` attribute value other than `Lax`, `Strict`, or `None`.
/// This interceptor reads raw cookie headers and silently skips any cookie
/// that would fail to parse, preventing the crash.
class _SafeCookieInterceptor extends Interceptor {
  // In-memory cookie store: domain → name → Cookie
  final Map<String, Map<String, Cookie>> _store = {};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final host = options.uri.host;
    final cookies = _store[host];
    if (cookies != null && cookies.isNotEmpty) {
      final cookieHeader = cookies.values.map((c) => '${c.name}=${c.value}').join('; ');
      options.headers[HttpHeaders.cookieHeader] = cookieHeader;
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _saveResponseCookies(response);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response != null) {
      _saveResponseCookies(err.response!);
    }
    handler.next(err);
  }

  void _saveResponseCookies(Response response) {
    final host = response.requestOptions.uri.host;
    final rawHeaders = response.headers.map[HttpHeaders.setCookieHeader];
    if (rawHeaders == null) return;

    _store.putIfAbsent(host, () => {});

    for (final raw in rawHeaders) {
      try {
        final cookie = Cookie.fromSetCookieValue(raw);
        _store[host]![cookie.name] = cookie;
      } catch (_) {
        // The server returned a malformed Set-Cookie header (e.g. an
        // unrecognised SameSite value). We skip it gracefully instead of
        // crashing the app.
        try {
          // Still try to salvage name=value from the raw string.
          final nameValue = raw.split(';').first.trim();
          final eqIndex = nameValue.indexOf('=');
          if (eqIndex > 0) {
            final name = nameValue.substring(0, eqIndex).trim();
            final value = nameValue.substring(eqIndex + 1).trim();
            if (name.isNotEmpty) {
              _store[host]![name] = Cookie(name, value);
            }
          }
        } catch (_) {
          // Completely unparseable – ignore.
        }
      }
    }
  }
}

class ApiClient {
  final Dio _dio;
  final String baseUrl = 'https://api.personaclick.com';

  ApiClient({Dio? dio}) : _dio = dio ?? Dio() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.headers['content-type'] = 'application/json';
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);

    _dio.interceptors.add(_SafeCookieInterceptor());
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) {
    return _dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(String path, {dynamic data}) {
    return _dio.post(path, data: data);
  }
}
