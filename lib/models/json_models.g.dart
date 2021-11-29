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
    AccountInfoFio.fromJson(json['fio'] as Map<String, dynamic>),
    json['year'] as int?,
    json['sex'] as bool?,
  );
}

Map<String, dynamic> _$AccountInfoToJson(AccountInfo instance) =>
    <String, dynamic>{
      'fio': instance.fio,
      'year': instance.birthYear,
      'sex': instance.gender,
    };

AccountInfoFio _$AccountInfoFioFromJson(Map<String, dynamic> json) {
  return AccountInfoFio(
    json['first'] as String?,
    json['last'] as String?,
    json['patronymic'] as String?,
    AccountInfoInitials.fromJson(json['initials'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$AccountInfoFioToJson(AccountInfoFio instance) =>
    <String, dynamic>{
      'first': instance.firstName,
      'last': instance.lastName,
      'patronymic': instance.middleName,
      'initials': instance.initials,
    };

AccountInfoInitials _$AccountInfoInitialsFromJson(Map<String, dynamic> json) {
  return AccountInfoInitials(
    json['first'] as String?,
    json['patronymic'] as String?,
  );
}

Map<String, dynamic> _$AccountInfoInitialsToJson(
        AccountInfoInitials instance) =>
    <String, dynamic>{
      'first': instance.first,
      'patronymic': instance.patronymic,
    };

Prescription _$PrescriptionFromJson(Map<String, dynamic> json) {
  return Prescription(
    json['prescription_id'] as int,
    DateTime.parse(json['sended'] as String),
    _$enumDecode(_$PrescriptionStatusEnumMap, json['status']),
    json['reason'] as String?,
    json['check'] as bool,
    json['flag'] as bool,
  );
}

Map<String, dynamic> _$PrescriptionToJson(Prescription instance) =>
    <String, dynamic>{
      'prescription_id': instance.id,
      'sended': instance.creationDate.toIso8601String(),
      'status': _$PrescriptionStatusEnumMap[instance.status],
      'reason': instance.reason,
      'check': instance.needsCheck,
      'flag': instance.flag,
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$PrescriptionStatusEnumMap = {
  PrescriptionStatus.obtained: 'PRESCRIPTION_GET',
  PrescriptionStatus.prepared: 'PRESCRIPTION_PREPARED',
  PrescriptionStatus.recognized: 'PRESCRIPTION_RECOGNIZED',
  PrescriptionStatus.failure: 'PRESCRIPTION_FAILURE',
  PrescriptionStatus.closed: 'PRESCRIPTION_CLOSED',
};

PrescriptionDetails _$PrescriptionDetailsFromJson(Map<String, dynamic> json) {
  return PrescriptionDetails(
    DateTime.parse(json['sended'] as String),
    _$enumDecode(_$PrescriptionStatusEnumMap, json['status']),
    json['reason'] as String?,
    json['check'] as bool,
    json['flag'] as bool,
    json['clinic'] as String?,
    json['date'] == null ? null : DateTime.parse(json['date'] as String),
    json['specialty'] as String?,
    (json['diagnosis'] as List<dynamic>?)
        ?.map((e) => PrescriptionDiagnosis.fromJson(e as Map<String, dynamic>))
        .toList(),
    (json['drugs'] as List<dynamic>?)
        ?.map((e) => PrescriptionDrug.fromJson(e as Map<String, dynamic>))
        .toList(),
    (json['photo'] as List<dynamic>?)?.map((e) => e as int).toList(),
    json['cashback_amount'] as int?,
    json['cashback_status'] as bool?,
    json['cashback_reason'] as String?,
  );
}

Map<String, dynamic> _$PrescriptionDetailsToJson(
        PrescriptionDetails instance) =>
    <String, dynamic>{
      'sended': instance.creationDate.toIso8601String(),
      'status': _$PrescriptionStatusEnumMap[instance.status],
      'reason': instance.reason,
      'check': instance.needsCheck,
      'flag': instance.flag,
      'clinic': instance.clinic,
      'date': instance.date?.toIso8601String(),
      'specialty': instance.specialty,
      'diagnosis': instance.diagnosis,
      'drugs': instance.drugs,
      'photo': instance.photoIds,
      'cashback_amount': instance.cashbackAmount,
      'cashback_status': instance.cashbackStatus,
      'cashback_reason': instance.cashbackReason,
    };

PrescriptionDiagnosis _$PrescriptionDiagnosisFromJson(
    Map<String, dynamic> json) {
  return PrescriptionDiagnosis(
    json['diagnose_id'] as int,
    json['diagnose_name'] as String,
  );
}

Map<String, dynamic> _$PrescriptionDiagnosisToJson(
        PrescriptionDiagnosis instance) =>
    <String, dynamic>{
      'diagnose_id': instance.id,
      'diagnose_name': instance.name,
    };

PrescriptionDrug _$PrescriptionDrugFromJson(Map<String, dynamic> json) {
  return PrescriptionDrug(
    json['drug_id'] as int,
    json['drug_name'] as String,
  );
}

Map<String, dynamic> _$PrescriptionDrugToJson(PrescriptionDrug instance) =>
    <String, dynamic>{
      'drug_id': instance.id,
      'drug_name': instance.name,
    };

Balance _$BalanceFromJson(Map<String, dynamic> json) {
  return Balance(
    json['balance'] as int,
    json['min'] as int,
    json['max'] as int,
    (json['history'] as List<dynamic>)
        .map((e) => BalanceHistoryItem.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$BalanceToJson(Balance instance) => <String, dynamic>{
      'balance': instance.balance,
      'min': instance.min,
      'max': instance.max,
      'history': instance.history,
    };

BalanceHistoryItem _$BalanceHistoryItemFromJson(Map<String, dynamic> json) {
  return BalanceHistoryItem(
    json['amount'] as int,
    json['status'] as bool?,
    DateTime.parse(json['date'] as String),
  );
}

Map<String, dynamic> _$BalanceHistoryItemToJson(BalanceHistoryItem instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'status': instance.status,
      'date': instance.date.toIso8601String(),
    };
