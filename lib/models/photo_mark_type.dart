import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum PhotoMarkType {
  patientName,
  doctorSpeciality,
  clinic,
  date,
  diagnose,
  drug,
}

extension Localization on PhotoMarkType {
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
}
