import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:image/image.dart' as imglib;
import 'package:med_cashback/models/json_models.dart';
import 'package:med_cashback/models/recipe_photo_data.dart';
import 'package:med_cashback/network/networking_client.dart';

enum PrescriptionsServiceLoadState {
  notLoaded,
  loading,
  loaded,
  error,
}

class PrescriptionsService with ChangeNotifier {
  static final instance = PrescriptionsService();

  PrescriptionsServiceLoadState state = PrescriptionsServiceLoadState.notLoaded;
  Object? error;
  List<Prescription>? prescriptions;

  Future<List<Prescription>> reloadPrescriptions() async {
    state = PrescriptionsServiceLoadState.loading;
    error = null;
    prescriptions = null;
    notifyListeners();

    try {
      prescriptions = await NetworkingClient.fetch('prescriptions',
          requireAuth: true,
          method: HTTPMethod.get,
          fromJsonT: (json) => (json as List<dynamic>)
              .map((e) => Prescription.fromJson(e))
              .toList());

      error = null;
      state = PrescriptionsServiceLoadState.loaded;
      notifyListeners();

      return prescriptions!;
    } catch (err) {
      error = err;
      prescriptions = null;
      state = PrescriptionsServiceLoadState.error;
      notifyListeners();

      throw err;
    }
  }

  Future<PrescriptionDetails> loadPrescriptionDetails(
      Prescription prescription) async {
    return await NetworkingClient.fetch(
      'prescription/${prescription.id}',
      requireAuth: true,
      method: HTTPMethod.get,
      fromJsonT: (json) => PrescriptionDetails.fromJson(json),
    );
  }

  Future<void> setFlag(Prescription prescription) async {
    await NetworkingClient.fetch(
      'prescription/${prescription.id}/flag',
      requireAuth: true,
      method: HTTPMethod.post,
      fromJsonT: (_) => null,
    );
    prescription.flag = false;
    notifyListeners();
  }

  Future<void> createPrescription({
    required AccountInfo accountInfo,
    required List<RecipePhotoData> photos,
    required bool isHandwritten,
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
      "fio": accountInfo.fio.toJson(),
      "handwritten": isHandwritten,
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

  String photoUrl({required int prescriptionId, required int photoId}) {
    return NetworkingClient.baseUrl +
        'prescription/$prescriptionId/photo/$photoId';
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
