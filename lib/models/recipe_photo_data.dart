import 'dart:ui';

import 'package:image/image.dart' as im;

class RecipePhotoData {
  RecipePhotoData({required this.image});

  final im.Image image;

  Rect? patientFioRect;
  Rect? dateRect;
  Rect? clinicRect;
  Rect? specialtyRect;
  Rect? diagnoseRect;
  Rect? drugRect;
}
