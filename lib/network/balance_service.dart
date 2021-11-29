import 'package:med_cashback/models/json_models.dart';
import 'package:med_cashback/network/networking_client.dart';

class BalanceService {
  Future<Balance> loadBalance() async {
    return NetworkingClient.fetch<Balance>(
      'balance',
      method: HTTPMethod.get,
      fromJsonT: (json) => Balance.fromJson(json),
    );
  }

  Future<Balance> makePayment(
      {required int amount, String? phone, String? yoomoney}) {
    if (phone == null && yoomoney == null) {
      throw 'Phone or yoomoney must be set!';
    }
    return NetworkingClient.fetch<Balance>('balance',
        method: HTTPMethod.post,
        parameters: {
          'amount': amount,
          'phone': phone,
          'yoomoney': yoomoney,
        },
        fromJsonT: (json) => Balance.fromJson(json));
  }
}
