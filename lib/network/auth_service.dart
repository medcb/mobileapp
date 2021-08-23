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
        406: 'Достигнут лимит СМС для указанного номера. Попробуйте позже.',
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
        400: "Некорректные данные",
        401: "Неверный код",
        404: "Телефон не найден",
      },
      fromJsonT: (json) => LoginData.fromJson(json!),
    );
    print(loginData.accessToken);
  }

  static String _stripPhoneSymbols(String phone) {
    return phone.replaceAll(RegExp(r'[^\d\+]+'), '');
  }
}
