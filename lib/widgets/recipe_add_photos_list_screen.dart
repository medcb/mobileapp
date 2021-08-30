import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:image/image.dart' as imglib;
import 'package:med_cashback/constants/cashback_colors.dart';
import 'package:med_cashback/constants/route_name.dart';
import 'package:med_cashback/generated/lib/generated/locale_keys.g.dart';
import 'package:med_cashback/models/photo_mark_type.dart';
import 'package:med_cashback/models/recipe_photo_data.dart';
import 'package:med_cashback/network/auth_service.dart';
import 'package:med_cashback/network/prescriptions_service.dart';
import 'package:med_cashback/widgets/photo_shutter_screen.dart';
import 'package:med_cashback/widgets/recipe_add_handwritten_type_selection_dialog.dart';
import 'package:med_cashback/widgets/recipe_add_photo_edit.dart';
import 'package:med_cashback/widgets/stateful_screen.dart';

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
  StatefulScreenState _screenState = StatefulScreenState.content;

  List<RecipePhotoData> _photos = [];

  PrescriptionsService _prescriptionsService = PrescriptionsService.instance;

  bool? _isHandwritten;
  bool _isDisplayingHandwrittenDialog = false;

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

  void _save() async {
    if (_errorText() != null) {
      return;
    }

    if (_isHandwritten == null) {
      _selectHandwrittenTypeIfNeeded();
      return;
    }

    setState(() {
      _screenState = StatefulScreenState.loading;
    });
    try {
      final accountInfo = await AuthService.instance.getAccountInfo();

      await _prescriptionsService.createPrescription(
        accountInfo: accountInfo,
        photos: _photos,
        isHandwritten: _isHandwritten!,
      );

      Navigator.pushReplacementNamed(context, RouteName.addRecipeSuccess);
    } catch (err) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(err.toString())));
    }
    setState(() {
      _screenState = StatefulScreenState.content;
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
      child: Text(LocaleKeys.recipeAddPhotosListDeleteAlertYes.tr()),
    );
    final noButton = TextButton(
      onPressed: () => Navigator.pop(context),
      child: Text(LocaleKeys.recipeAddPhotosListDeleteAlertNo.tr()),
    );
    final alertDialog = AlertDialog(
      title: Text(LocaleKeys.recipeAddPhotosListDeleteAlertTitle.tr()),
      actions: [noButton, yesButton],
    );
    showDialog(
      context: context,
      builder: (context) => alertDialog,
    );
  }

  void _didTapPhoto(RecipePhotoData photo) {
    Navigator.pushNamed(context, RouteName.addRecipePhotoEdit,
        arguments: RecipeAddPhotoEditScreenArguments(
          photo,
          () {
            setState(() {});
          },
        ));
  }

  String? absentPhotosErrorText() {
    List<PhotoMarkType> absentTypes = [
      PhotoMarkType.patientName,
      PhotoMarkType.date,
      PhotoMarkType.diagnose,
      PhotoMarkType.drug,
    ];
    _photos.forEach((element) {
      if (element.patientFioRect != null) {
        absentTypes.remove(PhotoMarkType.patientName);
      }
      if (element.dateRect != null) {
        absentTypes.remove(PhotoMarkType.date);
      }
      if (element.diagnoseRect != null) {
        absentTypes.remove(PhotoMarkType.diagnose);
      }
      if (element.drugRect != null) {
        absentTypes.remove(PhotoMarkType.drug);
      }
    });

    if (absentTypes.length > 0) {
      return LocaleKeys.recipeAddPhotosAbsentTitle.tr() +
          absentTypes.map((e) => e.localizedName(context)).join(", ");
    } else {
      return null;
    }
  }

  String? _errorText() {
    if (_photos.length == 0) {
      return LocaleKeys.recipeAddPhotosListErrorNoPhotos.tr();
    }

    if (_photos.length == 1) {
      final photo = _photos.first;
      if (photo.patientFioRect == null &&
          photo.dateRect == null &&
          photo.clinicRect == null &&
          photo.specialtyRect == null &&
          photo.diagnoseRect == null &&
          photo.drugRect == null) {
        return LocaleKeys.recipeAddPhotosListErrorNoMarks.tr();
      }
    }
    return absentPhotosErrorText();
  }

  void _selectHandwrittenTypeIfNeeded() async {
    if (_isHandwritten != null || _isDisplayingHandwrittenDialog) return;
    _isDisplayingHandwrittenDialog = true;
    await showDialog(
      context: context,
      barrierDismissible: false,
      useSafeArea: false,
      builder: (context) => RecipeAddHandwrittenTypeSelectionDialog(
        completion: (val) => _isHandwritten = val,
      ),
    );
    _isDisplayingHandwrittenDialog = false;
  }

  @override
  Widget build(BuildContext context) {
    String? errorText = _errorText();

    return FocusDetector(
      onFocusGained: _selectHandwrittenTypeIfNeeded,
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          shadowColor: Color(0),
        ),
        body: SafeArea(
          child: StatefulScreen(
            screenState: _screenState,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    LocaleKeys.recipeAddPhotosListTitle.tr(),
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    padding: EdgeInsets.all(16),
                    itemCount: _photos.length + 1,
                    itemBuilder: (context, index) => index < _photos.length
                        ? Stack(
                            children: [
                              GestureDetector(
                                onTap: () => _didTapPhoto(_photos[index]),
                                child: Container(
                                  constraints: BoxConstraints.expand(),
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    child: Image.memory(
                                      imglib.encodeJpg(_photos[index].image)
                                          as Uint8List,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional.topEnd,
                                child: InkWell(
                                    onTap: () =>
                                        _didTapDeletePhoto(_photos[index]),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: CashbackColors.shadowColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Icon(
                                          Icons.close,
                                          color:
                                              CashbackColors.contrastTextColor,
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
                                color:
                                    CashbackColors.photoAddPlusBackgroundColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                              ),
                              child: Icon(
                                Icons.add,
                                color: CashbackColors.disabledColor,
                                size: 32,
                              ),
                            ),
                          ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  child: errorText != null
                      ? Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: CashbackColors.toastBackgroundColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            errorText,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: CashbackColors.contrastTextColor,
                                fontSize: 14),
                          ))
                      : SizedBox(
                          height: 44,
                          child: TextButton(
                            onPressed: _save,
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  CashbackColors.accentColor),
                            ),
                            child: Text(
                              LocaleKeys.recipeAddPhotosListSave.tr(),
                              style: TextStyle(
                                color: CashbackColors.contrastTextColor,
                              ),
                            ),
                          ),
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
