import 'dart:convert';
import 'dart:ui';

import 'package:image/image.dart' as imglib;
import 'package:med_cashback/models/json_models.dart';
import 'package:med_cashback/models/recipe_photo_data.dart';
import 'package:med_cashback/network/networking_client.dart';

class PrescriptionsService {
  Future<void> createPrescription({
    required AccountInfo accountInfo,
    required List<RecipePhotoData> photos,
  }) async {
    final prescriptions = photos
        .map((photo) => {
              "photo": base64Encode(imglib.encodePng(photo.image)).toString(),
              "patient_fio_rect": _encodeRect(photo.patientFioRect),
              "date_rect": _encodeRect(photo.dateRect),
              "clinic_rect": _encodeRect(photo.clinicRect),
              "specialty_rect": _encodeRect(photo.specialtyRect),
              "diagnose_rect": _encodeRect(photo.diagnoseRect),
              "drug_rect": _encodeRect(photo.drugRect),
            })
        .toList();

    Map<String, dynamic> parameters = {
      "first_hash": accountInfo.firstNameHash,
      "last_hash": accountInfo.lastNameHash,
      "patronymic_hash": accountInfo.middleNameHash,
      "handwritten": true,
      "prescriptions": prescriptions,
    };

    await NetworkingClient.fetch(
      'prescription',
      method: HTTPMethod.post,
      parameters: parameters,
      requireAuth: true,
      fromJsonT: (json) => null,
    );
  }

  List<int>? _encodeRect(Rect? rect) {
    if (rect == null) {
      return null;
    }
    return [
      rect.left.toInt(),
      rect.top.toInt(),
      rect.right.toInt(),
      rect.bottom.toInt(),
    ];
  }
}
