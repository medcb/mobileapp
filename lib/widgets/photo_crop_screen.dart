import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:med_cashback/constants/cashback_colors.dart';
import 'package:med_cashback/widgets/image_rect_selector.dart';

class PhotoCropScreenArguments {
  final String imagePath;

  PhotoCropScreenArguments(this.imagePath);
}

class PhotoCropScreen extends StatefulWidget {
  const PhotoCropScreen({Key? key, required this.arguments}) : super(key: key);

  final PhotoCropScreenArguments arguments;

  @override
  _PhotoCropScreenState createState() => _PhotoCropScreenState();
}

class _PhotoCropScreenState extends State<PhotoCropScreen> {
  void _close() {
    Navigator.pop(context);
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
                imagePath: widget.arguments.imagePath,
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
                      onPressed: () {
                        print("save");
                      },
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
