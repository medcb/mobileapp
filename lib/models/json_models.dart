import 'package:json_annotation/json_annotation.dart';

part 'json_models.g.dart';

@JsonSerializable()
class LoginData {
  @JsonKey(name: 'access_token')
  final String accessToken;

  @JsonKey(name: 'refresh_token')
  final String refreshToken;

  @JsonKey(name: 'fio_salt')
  final String fioSalt;

  final String email;

  LoginData(this.accessToken, this.refreshToken, this.fioSalt, this.email);

  factory LoginData.fromJson(Map<String, dynamic> json) =>
      _$LoginDataFromJson(json);
  Map<String, dynamic> toJson() => _$LoginDataToJson(this);
}
