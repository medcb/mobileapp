import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';
import 'package:med_cashback/constants/cashback_colors.dart';

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
  @JsonKey(name: 'fio')
  final AccountInfoFio fio;

  // year: <int> год рождения
  @JsonKey(name: 'year')
  final int? birthYear;

  // sex: <bool> true - м., false - ж.
  @JsonKey(name: 'sex')
  final bool? gender;

  AccountInfo(this.fio, this.birthYear, this.gender);

  factory AccountInfo.fromJson(Map<String, dynamic> json) =>
      _$AccountInfoFromJson(json);

  Map<String, dynamic> toJson() => _$AccountInfoToJson(this);

  bool isFilled() {
    return fio.firstName != null &&
        fio.lastName != null &&
        fio.initials.first != null &&
        gender != null;
  }
}

@JsonSerializable()
class AccountInfoFio {
  @JsonKey(name: 'first')
  final String? firstName;

  @JsonKey(name: 'last')
  final String? lastName;

  @JsonKey(name: 'patronymic')
  final String? middleName;

  @JsonKey(name: 'initials')
  final AccountInfoInitials initials;

  AccountInfoFio(this.firstName, this.lastName, this.middleName, this.initials);

  factory AccountInfoFio.fromJson(Map<String, dynamic> json) =>
      _$AccountInfoFioFromJson(json);

  Map<String, dynamic> toJson() => _$AccountInfoFioToJson(this);
}

@JsonSerializable()
class AccountInfoInitials {
  @JsonKey(name: 'first')
  final String? first;

  @JsonKey(name: 'patronymic')
  final String? patronymic;

  AccountInfoInitials(this.first, this.patronymic);

  factory AccountInfoInitials.fromJson(Map<String, dynamic> json) =>
      _$AccountInfoInitialsFromJson(json);

  Map<String, dynamic> toJson() => _$AccountInfoInitialsToJson(this);
}

@JsonSerializable()
class Prescription {
  // prescription_id: <int> ID рецепта
  @JsonKey(name: 'prescription_id')
  final int id;

  // sended: <iso8601> дата.время отправки на сервер
  @JsonKey(name: 'sended')
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
  bool flag;

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

@JsonSerializable()
class PrescriptionDetails {
  @JsonKey(name: 'sended')
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

  // clinic: <str> название клиники. необязательное
  @JsonKey(name: 'clinic')
  final String? clinic;

  // date: <iso 8601> дата рецепта. необязательное
  @JsonKey(name: 'date')
  final DateTime? date;

  // specialty: <str> специальность врача. необязательное
  @JsonKey(name: 'specialty')
  final String? specialty;

  // diagnosis: [{}] диагнозы
  @JsonKey(name: 'diagnosis')
  final List<PrescriptionDiagnosis>? diagnosis;

  // drugs: [{}] препараты
  @JsonKey(name: 'drugs')
  final List<PrescriptionDrug>? drugs;

  // photo: [<photo_id>] список ID фото
  @JsonKey(name: 'photo')
  final List<int>? photoIds;

  // cashback_amount: <int> в копейках. null - не начислено
  @JsonKey(name: 'cashback_amount')
  final int? cashbackAmount;

  // cashback_status: <bool> null - в процессе перевода, true-переведено, false-отказ
  @JsonKey(name: 'cashback_status')
  final bool? cashbackStatus;

  // cashback_reason: <str> - причина отказа
  @JsonKey(name: 'cashback_reason')
  final String? cashbackReason;

  PrescriptionDetails(
    this.creationDate,
    this.status,
    this.reason,
    this.needsCheck,
    this.flag,
    this.clinic,
    this.date,
    this.specialty,
    this.diagnosis,
    this.drugs,
    this.photoIds,
    this.cashbackAmount,
    this.cashbackStatus,
    this.cashbackReason,
  );

  Color statusColor() {
    if (reason != null || cashbackReason != null) {
      return CashbackColors.prescriptionStatusDeclinedColor;
    }
    switch (status.toLowerCase()) {
      case 'подтвержден':
        return CashbackColors.prescriptionStatusAcceptedColor;
      case 'подготовлен':
        return CashbackColors.prescriptionStatusSentColor;
      case 'отказ':
        return CashbackColors.prescriptionStatusDeclinedColor;
      case 'проверен пользователем':
        return CashbackColors.prescriptionStatusCheckedColor;
      default:
        return CashbackColors.prescriptionStatusNeedsCheckColor;
    }
  }

  factory PrescriptionDetails.fromJson(Map<String, dynamic> json) =>
      _$PrescriptionDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$PrescriptionDetailsToJson(this);
}

@JsonSerializable()
class PrescriptionDiagnosis {
  // diagnose_id <int>
  @JsonKey(name: 'drug_id')
  final int id;

  // diagnose_name <str>
  @JsonKey(name: 'drug_name')
  final String name;

  PrescriptionDiagnosis(this.id, this.name);

  factory PrescriptionDiagnosis.fromJson(Map<String, dynamic> json) =>
      _$PrescriptionDiagnosisFromJson(json);

  Map<String, dynamic> toJson() => _$PrescriptionDiagnosisToJson(this);
}

@JsonSerializable()
class PrescriptionDrug {
  // drug_id: <int>
  @JsonKey(name: 'drug_id')
  final int id;

  // drug_name: <str> название мед. препарата
  @JsonKey(name: 'drug_name')
  final String name;

  PrescriptionDrug(this.id, this.name);

  factory PrescriptionDrug.fromJson(Map<String, dynamic> json) =>
      _$PrescriptionDrugFromJson(json);

  Map<String, dynamic> toJson() => _$PrescriptionDrugToJson(this);
}
