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

@JsonSerializable()
class Prescription {
  // prescription_id: <int> ID рецепта
  @JsonKey(name: 'prescription_id')
  final int id;

  // sended: <iso8601> дата.время отправки на сервер
  @JsonKey(name: 'sended', fromJson: _decodeDate)
  final DateTime creationDate;

  // status: <str> текстовый статус ('Получен', 'Подготовлен', 'Распознан', 'Отказ', 'Проверен пользователем', Отменен пользователем, Подтвержден)
  @JsonKey(name: 'status')
  final String status;

  // reason: <str> причина отказа. необязательное
  @JsonKey(name: 'reason')
  final String? reason;

  // check: <bool> True - требуется проверка пациентом
  @JsonKey(name: 'check')
  final bool needsCheck;

  // flag: <bool> сбрасывается пациентом, поднимается сервером
  @JsonKey(name: 'flag')
  final bool flag;

  static DateTime _decodeDate(String from) {
    return DateTime.now();
  }

  Prescription(
    this.id,
    this.creationDate,
    this.status,
    this.reason,
    this.needsCheck,
    this.flag,
  );

  factory Prescription.fromJson(Map<String, dynamic> json) =>
      _$PrescriptionFromJson(json);

  Map<String, dynamic> toJson() => _$PrescriptionToJson(this);
}
