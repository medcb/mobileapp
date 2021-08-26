import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'package:med_cashback/generated/lib/generated/locale_keys.g.dart';

import 'auth_service.dart';

class UnauthorizedException implements Exception {
  @override
  String toString() {
    return LocaleKeys.networkErrorUnauthorized.tr();
  }
}

class NoInternetException implements Exception {
  @override
  String toString() {
    return LocaleKeys.networkErrorNoInternet.tr();
  }
}

enum HTTPMethod {
  get,
  post,
}

extension StringValue on HTTPMethod {
  String get stringValue {
    switch (this) {
      case HTTPMethod.get:
        return "GET";
      case HTTPMethod.post:
        return "POST";
    }
  }
}

class NetworkingClient {
  static final String _baseUrl = "https://medcashback.inno.co/mp/";

  /// Supports only String and List<String> as parameter values
  static Future<T> fetch<T>(
    String path, {
    HTTPMethod method = HTTPMethod.post,
    bool requireAuth = true,
    Map<String, dynamic>? parameters,
    Map<int, String>? statusCodeMessages,
    required T Function(Map<String, dynamic>? json) fromJsonT,
  }) async {
    String queryString = "";
    if (method == HTTPMethod.get) {
      queryString = Uri(queryParameters: parameters).query;
      if (queryString.isNotEmpty) {
        queryString = "?" + queryString;
      }
    }
    var request = http.Request(
        method.stringValue, Uri.parse(_baseUrl + path + queryString))
      ..encoding = utf8;
    if (method == HTTPMethod.post) {
      request.body = jsonEncode(parameters);
      request.headers.addAll({'Content-Type': 'application/json'});
    }

    return await _performRequest(request,
        requireAuth: requireAuth,
        fromJsonT: fromJsonT,
        statusCodeMessages: statusCodeMessages,
        onRepeat: () => fetch(
              path,
              requireAuth: false,
              parameters: parameters,
              fromJsonT: fromJsonT,
            ));
  }

  static Future<T> _performRequest<T>(
    http.BaseRequest request, {
    required bool requireAuth,
    required T Function(Map<String, dynamic>? json) fromJsonT,
    required Future<T> Function() onRepeat,
    required Map<int, String>? statusCodeMessages,
  }) async {
    var response;
    Map<String, String> headers = {};
    try {
      final token = await AuthService.instance.authToken();
      if (token != null) {
        headers[HttpHeaders.authorizationHeader] = "Bearer $token";
      }
    } catch (_) {}
    request.headers.addAll(headers);
    try {
      final streamResponse = await request.send();
      response = await http.Response.fromStream(streamResponse);
    } on SocketException {
      throw NoInternetException();
    } catch (err) {
      print(err);
      throw LocaleKeys.networkError1.tr();
    }

    if (statusCodeMessages?.containsKey(response.statusCode) ?? false) {
      throw statusCodeMessages![response.statusCode]!;
    }

    if (response.statusCode == 401) {
      if (requireAuth) {
        try {
          await AuthService.instance.refreshToken();
        } on NoInternetException {
          throw NoInternetException();
        } catch (_) {
          throw UnauthorizedException();
        }
        return onRepeat();
      } else {
        throw UnauthorizedException();
      }
    }

    if (response.statusCode != 200) {
      print("statusCode: ${response.statusCode} body: ${response.body}");
      throw LocaleKeys.networkError2.tr();
    }

    Map<String, dynamic>? json;
    try {
      json = jsonDecode(response.body);
    } catch (err) {
      print('error deciding json: $err');
    }

    try {
      return fromJsonT(json);
    } catch (err) {
      print(err);
      throw LocaleKeys.networkError3.tr();
    }
  }
}
