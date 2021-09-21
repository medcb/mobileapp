import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:med_cashback/generated/lib/generated/locale_keys.g.dart';
import 'package:med_cashback/models/json_models.dart';
import 'package:med_cashback/widgets/profile_fill_info_screen.dart';

import 'networking_client.dart';

class AuthService with ChangeNotifier {
  static final instance = AuthService();

  AccountInfo? accountInfo;

  final _storage = new FlutterSecureStorage();

  bool? _isAuthorized;

  final _kTokenKey = "medcashback.keychain.token";
  final _kRefreshTokenKey = "medcashback.keychain.refreshToken";
  final _kSaltKey = "medcashback.keychain.salt";

  Future<bool> isAuthorized() async {
    if (_isAuthorized != null) {
      return _isAuthorized!;
    }
    try {
      _isAuthorized = await authToken() != null;
      return _isAuthorized!;
    } catch (_) {
      return false;
    }
  }

  Future<String?> authToken() async {
    return await _storage.read(key: _kTokenKey);
  }

  Future<void> register(String phone) async {
    await NetworkingClient.fetch<Null>(
      'register',
      parameters: {
        'phone': _stripPhoneSymbols(phone),
      },
      statusCodeMessages: {
        406: LocaleKeys.authErrorRegister406.tr(),
      },
      requireAuth: false,
      fromJsonT: (_) => null,
    );
  }

  Future<void> login({
    required String phone,
    required String sms,
  }) async {
    final loginData = await NetworkingClient.fetch<LoginData>(
      'login',
      parameters: {
        'phone': _stripPhoneSymbols(phone),
        'sms': sms,
      },
      requireAuth: false,
      statusCodeMessages: {
        400: LocaleKeys.authErrorLogin400.tr(),
        401: LocaleKeys.authErrorLogin401.tr(),
        404: LocaleKeys.authErrorLogin404.tr(),
      },
      fromJsonT: (json) => LoginData.fromJson(json!),
    );
    await _storage.write(key: _kTokenKey, value: loginData.accessToken);
    await _storage.write(key: _kRefreshTokenKey, value: loginData.refreshToken);
    await _storage.write(key: _kSaltKey, value: loginData.fioSalt);

    _isAuthorized = true;
    notifyListeners();
  }

  Future<void> refreshToken() async {
    final token = await _storage.read(key: _kRefreshTokenKey);
    final tokenData = await NetworkingClient.fetch(
      'refresh',
      requireAuth: false,
      parameters: {'refresh_token': token},
      fromJsonT: (json) => RefreshTokenData.fromJson(json!),
    );
    await _storage.write(key: _kTokenKey, value: tokenData.accessToken);
    await _storage.write(key: _kRefreshTokenKey, value: tokenData.refreshToken);
  }

  Future<AccountInfo> getAccountInfo() async {
    accountInfo = await NetworkingClient.fetch<AccountInfo>(
      'account',
      method: HTTPMethod.get,
      requireAuth: true,
      fromJsonT: (json) => AccountInfo.fromJson(json!),
    );
    return accountInfo!;
  }

  Future<void> setAccountInfo({
    required String secondName,
    required String firstName,
    String? middleName,
    required Gender gender,
    required int birthYear,
  }) async {
    bool sex;
    switch (gender) {
      case Gender.male:
        sex = true;
        break;
      case Gender.female:
        sex = false;
        break;
    }
    await NetworkingClient.fetch<Null>(
      'account',
      method: HTTPMethod.post,
      requireAuth: true,
      parameters: {
        'first_hash': await _createHash(firstName),
        'last_hash': await _createHash(secondName),
        'patronymic_hash':
            middleName != null ? await _createHash(middleName) : null,
        'year': birthYear,
        'sex': sex,
        'children': [],
      },
      fromJsonT: (_) => null,
    );
    await getAccountInfo();
  }

  Future<void> clearAuthData() async {
    accountInfo = null;
    for (String key in [_kTokenKey, _kRefreshTokenKey, _kSaltKey]) {
      await _storage.delete(key: key);
    }
    _isAuthorized = false;
    notifyListeners();
  }

  String _stripPhoneSymbols(String phone) {
    return phone.replaceAll(RegExp(r'[^\d\+]+'), '');
  }

  Future<String> _createHash(String string) async {
    String salt;
    try {
      salt = (await _storage.read(key: _kSaltKey))!;
    } catch (ex) {
      print(ex);
      throw UnauthorizedException();
    }
    var encodedString = string
            .trim()
            .toLowerCase()
            .replaceAll('ё', 'е')
            .replaceAll('й', 'и')
            .toString() +
        salt;
    var bytes = utf8.encode(encodedString);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }
}
