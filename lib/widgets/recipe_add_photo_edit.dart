import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image/image.dart' as imglib;
import 'package:med_cashback/constants/cashback_colors.dart';
import 'package:med_cashback/models/recipe_photo_data.dart';

import 'image_rect_selector.dart';

class RecipeAddPhotoEditScreenArguments {
  final RecipePhotoData photoData;

  RecipeAddPhotoEditScreenArguments(this.photoData);
}

class RecipeAddPhotoEditScreen extends StatefulWidget {
  const RecipeAddPhotoEditScreen({Key? key, required this.arguments})
      : super(key: key);

  final RecipeAddPhotoEditScreenArguments arguments;

  @override
  _RecipeAddPhotoEditScreenState createState() =>
      _RecipeAddPhotoEditScreenState();
}

class _RecipeAddPhotoEditScreenState extends State<RecipeAddPhotoEditScreen> {
  Rect? _currentRect;

  late Image _image;

  @override
  void initState() {
    _image = Image.memory(
        imglib.encodeJpg(widget.arguments.photoData.image) as Uint8List);
    super.initState();
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
                onRectChange: (rect) => _currentRect = rect,
                image: _image,
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
                      onPressed: null,
                      child: Text(
                        'Добавить рецепт',
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
                  onTap: null,
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
