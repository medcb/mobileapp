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

@JsonSerializable()
class RefreshTokenData {
  @JsonKey(name: 'access_token')
  final String accessToken;

  @JsonKey(name: 'refresh_token')
  final String refreshToken;

  RefreshTokenData(this.accessToken, this.refreshToken);

  factory RefreshTokenData.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenDataFromJson(json);
  Map<String, dynamic> toJson() => _$RefreshTokenDataToJson(this);
}

@JsonSerializable()
class AccountInfo {
  // first_hash: <hash_fio> имя
  @JsonKey(name: 'first_hash')
  final String? firstNameHash;
  // last_hash: <hash_fio> фамилия
  @JsonKey(name: 'last_hash')
  final String? lastNameHash;
  // patronymic_hash: <hash_fio> отчество
  @JsonKey(name: 'patronymic_hash')
  final String? middleNameHash;
  // year: <int> год рождения
  @JsonKey(name: 'year')
  final int? birthYear;
  // sex: <bool> true - м., false - ж.
  @JsonKey(name: 'sex')
  final bool? gender;

  AccountInfo(this.firstNameHash, this.lastNameHash, this.middleNameHash,
      this.birthYear, this.gender);

  factory AccountInfo.fromJson(Map<String, dynamic> json) =>
      _$AccountInfoFromJson(json);

  Map<String, dynamic> toJson() => _$AccountInfoToJson(this);
}
