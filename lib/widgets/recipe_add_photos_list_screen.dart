import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image/image.dart' as imglib;
import 'package:med_cashback/constants/cashback_colors.dart';
import 'package:med_cashback/constants/route_name.dart';
import 'package:med_cashback/models/recipe_photo_data.dart';
import 'package:med_cashback/widgets/photo_shutter_screen.dart';

class RecipeAddPhotosListScreenArguments {
  final RecipePhotoData photo;

  RecipeAddPhotosListScreenArguments(this.photo);
}

class RecipeAddPhotosListScreen extends StatefulWidget {
  const RecipeAddPhotosListScreen({Key? key, required this.arguments})
      : super(key: key);

  final RecipeAddPhotosListScreenArguments arguments;

  @override
  _RecipeAddPhotosListState createState() => _RecipeAddPhotosListState();
}

class _RecipeAddPhotosListState extends State<RecipeAddPhotosListScreen> {
  List<RecipePhotoData> _photos = [];

  @override
  void initState() {
    _photos = [widget.arguments.photo];
    super.initState();
  }

  void _addPhoto() {
    Navigator.pushNamed(
      context,
      RouteName.addRecipe,
      arguments: PhotoShutterScreenArguments(completion: _didAddPhoto),
    );
  }

  void _didAddPhoto(RecipePhotoData photo) {
    setState(() {
      _photos.add(photo);
    });
  }

  void _didTapDeletePhoto(RecipePhotoData photo) {
    final yesButton = TextButton(
      onPressed: () {
        setState(() {
          _photos.remove(photo);
        });
        Navigator.pop(context);
      },
      child:
          Text(AppLocalizations.of(context)!.recipeAddPhotosListDeleteAlertYes),
    );
    final noButton = TextButton(
      onPressed: () => Navigator.pop(context),
      child:
          Text(AppLocalizations.of(context)!.recipeAddPhotosListDeleteAlertNo),
    );
    final alertDialog = AlertDialog(
      title: Text(
          AppLocalizations.of(context)!.recipeAddPhotosListDeleteAlertTitle),
      actions: [noButton, yesButton],
    );
    showDialog(
      context: context,
      builder: (context) => alertDialog,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        shadowColor: Color(0),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              AppLocalizations.of(context)!.recipeAddPhotosListTitle,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              padding: EdgeInsets.all(16),
              itemCount: _photos.length + 1,
              itemBuilder: (context, index) => index < _photos.length
                  ? Stack(
                      children: [
                        Container(
                          constraints: BoxConstraints.expand(),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            child: Image.memory(
                              imglib.encodeJpg(_photos[index].image)
                                  as Uint8List,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional.topEnd,
                          child: InkWell(
                              onTap: () => _didTapDeletePhoto(_photos[index]),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: CashbackColors.shadowColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    color: CashbackColors.contrastTextColor,
                                    size: 14,
                                  ),
                                ),
                              )),
                        ),
                      ],
                    )
                  : GestureDetector(
                      onTap: _addPhoto,
                      child: Container(
                        decoration: BoxDecoration(
                          color: CashbackColors.photoAddPlusBackgroundColor,
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        child: Icon(
                          Icons.add,
                          color: CashbackColors.disabledColor,
                          size: 32,
                        ),
                      ),
                    ),
            ),
          )
        ],
      ),
    );
  }
}
