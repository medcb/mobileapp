import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

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
    // String? token;
    // try {
    //   token = await AuthService.instance.authToken();
    // } catch (_) {}
    // if (token != null) {
    //   headers[HttpHeaders.authorizationHeader] = "Bearer $token";
    // }
    request.headers.addAll(headers);
    try {
      final streamResponse = await request.send();
      response = await http.Response.fromStream(streamResponse);
    } on SocketException {
      // todo - translate errors
      throw 'Произошла ошибка. Возможно, нет интернета, попробуйте позже.';
    } catch (err) {
      print(err);
      throw 'Произошла ошибка. (1)';
    }
    // if (response.statusCode == 401) {
    // if (requireAuth) {
    //   try {
    //     await AuthService.instance.refreshToken();
    //   } on SocketException {
    //     throw 'Произошла ошибка. Возможно, нет подключения к интернету, попробуйте позже.';
    //   } catch (err) {
    //     print(err);
    //     throw 'Произошла ошибка.';
    //   }
    //   return onRepeat();
    // } else {
    //   throw UnauthorizedException();
    // }
    // }
    if (response.statusCode != 200) {
      print("statusCode: ${response.statusCode} body: ${response.body}");
      if (statusCodeMessages?.containsKey(response.statusCode) ?? false) {
        throw statusCodeMessages![response.statusCode]!;
      }
      throw 'Произошла ошибка. (2)';
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
      throw 'Произошла ошибка. (3)';
    }
    // try {
    //   final _reply = T.fromJson(jsonDecode(response.body), (json) {
    //     if (fromJsonT != null) {
    //       return fromJsonT(json);
    //     }
    //     return null;
    //   });
    //   reply = _reply;
    // } catch (err) {
    //   print(err);
    //   throw 'Произошла ошибка.';
    // }
  }
}
