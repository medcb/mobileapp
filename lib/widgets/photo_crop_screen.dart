import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image/image.dart' as imageLib;
import 'package:med_cashback/constants/cashback_colors.dart';
import 'package:med_cashback/constants/route_name.dart';
import 'package:med_cashback/models/recipe_photo_data.dart';
import 'package:med_cashback/widgets/image_rect_selector.dart';
import 'package:med_cashback/widgets/recipe_add_photos_list_screen.dart';

class PhotoCropScreenArguments {
  final String imagePath;
  final Function(RecipePhotoData)? completion;

  PhotoCropScreenArguments(this.imagePath, {this.completion});
}

class PhotoCropScreen extends StatefulWidget {
  const PhotoCropScreen({Key? key, required this.arguments}) : super(key: key);

  final PhotoCropScreenArguments arguments;

  @override
  _PhotoCropScreenState createState() => _PhotoCropScreenState();
}

class _PhotoCropScreenState extends State<PhotoCropScreen> {
  Rect _cropRect = Rect.zero;

  late Image _image;

  @override
  void initState() {
    _image = Image.file(File(widget.arguments.imagePath));
    super.initState();
  }

  void _close() {
    Navigator.pop(context);
  }

  void _saveImage() {
    var image =
        imageLib.decodeJpg(File(widget.arguments.imagePath).readAsBytesSync());

    final cropped = imageLib.copyCrop(
      imageLib.bakeOrientation(image),
      _cropRect.left.toInt(),
      _cropRect.top.toInt(),
      _cropRect.width.toInt(),
      _cropRect.height.toInt(),
    );

    print(_cropRect.left.toInt());
    print(_cropRect.top.toInt());
    print(_cropRect.width.toInt());
    print(_cropRect.height.toInt());

    if (widget.arguments.completion != null) {
      widget.arguments.completion!(RecipePhotoData(image: cropped));
      Navigator.pop(context);
    } else {
      Navigator.pushReplacementNamed(
        context,
        RouteName.addRecipePhotosList,
        arguments:
            RecipeAddPhotosListScreenArguments(RecipePhotoData(image: cropped)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CashbackColors.photoBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 91, bottom: 76),
              child: ImageRectSelector(
                onRectChange: (rect) => _cropRect = rect,
                image: _image,
                style: ImageRectSelectorStyle.crop,
                rectColor: CashbackColors.photoCropBorderColor,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    AppLocalizations.of(context)!.photoCropTitle,
                    style: TextStyle(
                      color: CashbackColors.contrastTextColor,
                    ),
                  ),
                ),
                Expanded(child: Container()),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    height: 44,
                    child: ElevatedButton(
                      onPressed: _saveImage,
                      child: Text(
                        AppLocalizations.of(context)!.photoCropSave,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Align(
              alignment: AlignmentDirectional.topEnd,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: InkWell(
                  onTap: _close,
                  child: Image.asset(
                    'assets/images/close_circle_icon.png',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
