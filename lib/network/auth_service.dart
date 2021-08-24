import 'package:easy_localization/easy_localization.dart';
import 'package:med_cashback/generated/lib/generated/locale_keys.g.dart';
import 'package:med_cashback/models/json_models.dart';

import 'networking_client.dart';

class AuthService {
  static Future<void> register(String phone) async {
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

  static Future<void> login(
      {required String phone, required String sms}) async {
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
    print(loginData.accessToken);
  }

  static String _stripPhoneSymbols(String phone) {
    return phone.replaceAll(RegExp(r'[^\d\+]+'), '');
  }
}
