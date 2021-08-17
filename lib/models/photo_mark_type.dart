import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:med_cashback/constants/cashback_colors.dart';

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
        return AppLocalizations.of(context)!.recipeAddPhotosMarkTypePatientName;
      case PhotoMarkType.doctorSpeciality:
        return AppLocalizations.of(context)!
            .recipeAddPhotosMarkTypeDoctorSpeciality;
      case PhotoMarkType.clinic:
        return AppLocalizations.of(context)!.recipeAddPhotosMarkTypeClinic;
      case PhotoMarkType.date:
        return AppLocalizations.of(context)!.recipeAddPhotosMarkTypeDate;
      case PhotoMarkType.diagnose:
        return AppLocalizations.of(context)!.recipeAddPhotosMarkTypeDiagnose;
      case PhotoMarkType.drug:
        return AppLocalizations.of(context)!.recipeAddPhotosMarkTypeDrug;
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
}
