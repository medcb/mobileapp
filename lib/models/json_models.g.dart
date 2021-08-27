// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginData _$LoginDataFromJson(Map<String, dynamic> json) {
  return LoginData(
    json['access_token'] as String,
    json['refresh_token'] as String,
    json['fio_salt'] as String,
    json['email'] as String,
  );
}

Map<String, dynamic> _$LoginDataToJson(LoginData instance) => <String, dynamic>{
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'fio_salt': instance.fioSalt,
      'email': instance.email,
    };

RefreshTokenData _$RefreshTokenDataFromJson(Map<String, dynamic> json) {
  return RefreshTokenData(
    json['access_token'] as String,
    json['refresh_token'] as String,
  );
}

Map<String, dynamic> _$RefreshTokenDataToJson(RefreshTokenData instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
    };

AccountInfo _$AccountInfoFromJson(Map<String, dynamic> json) {
  return AccountInfo(
    json['first_hash'] as String?,
    json['last_hash'] as String?,
    json['patronymic_hash'] as String?,
    json['year'] as int?,
    json['sex'] as bool?,
  );
}

Map<String, dynamic> _$AccountInfoToJson(AccountInfo instance) =>
    <String, dynamic>{
      'first_hash': instance.firstNameHash,
      'last_hash': instance.lastNameHash,
      'patronymic_hash': instance.middleNameHash,
      'year': instance.birthYear,
      'sex': instance.gender,
    };

Prescription _$PrescriptionFromJson(Map<String, dynamic> json) {
  return Prescription(
    json['prescription_id'] as int,
    DateTime.parse(json['sended'] as String),
    json['status'] as String,
    json['reason'] as String?,
    json['check'] as bool,
    json['flag'] as bool,
  );
}

Map<String, dynamic> _$PrescriptionToJson(Prescription instance) =>
    <String, dynamic>{
      'prescription_id': instance.id,
      'sended': instance.creationDate.toIso8601String(),
      'status': instance.status,
      'reason': instance.reason,
      'check': instance.needsCheck,
      'flag': instance.flag,
    };
