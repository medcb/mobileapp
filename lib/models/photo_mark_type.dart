import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:med_cashback/constants/cashback_colors.dart';
import 'package:med_cashback/generated/lib/generated/locale_keys.g.dart';

enum PhotoMarkType {
  patientName,
  doctorSpeciality,
  clinic,
  date,
  diagnose,
  drug,
}

extension UIValues on PhotoMarkType {
  String localizedName(BuildContext context) {
    switch (this) {
      case PhotoMarkType.patientName:
        return LocaleKeys.recipeAddPhotosMarkTypePatientName.tr();
      case PhotoMarkType.doctorSpeciality:
        return LocaleKeys.recipeAddPhotosMarkTypeDoctorSpeciality.tr();
      case PhotoMarkType.clinic:
        return LocaleKeys.recipeAddPhotosMarkTypeClinic.tr();
      case PhotoMarkType.date:
        return LocaleKeys.recipeAddPhotosMarkTypeDate.tr();
      case PhotoMarkType.diagnose:
        return LocaleKeys.recipeAddPhotosMarkTypeDiagnose.tr();
      case PhotoMarkType.drug:
        return LocaleKeys.recipeAddPhotosMarkTypeDrug.tr();
    }
  }

  Color color() {
    switch (this) {
      case PhotoMarkType.patientName:
        return CashbackColors.photoMarkTypePatientNameColor;
      case PhotoMarkType.doctorSpeciality:
        return CashbackColors.photoMarkTypeDoctorSpecialityColor;
      case PhotoMarkType.clinic:
        return CashbackColors.photoMarkTypeClinicColor;
      case PhotoMarkType.date:
        return CashbackColors.photoMarkTypeDateColor;
      case PhotoMarkType.diagnose:
        return CashbackColors.photoMarkTypeDiagnoseColor;
      case PhotoMarkType.drug:
        return CashbackColors.photoMarkTypeDrugColor;
    }
  }

  Color? fillColor() {
    switch (this) {
      case PhotoMarkType.patientName:
        return CashbackColors.photoBackgroundColor;
      default:
        return null;
    }
  }
}
