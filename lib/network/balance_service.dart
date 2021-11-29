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
}
