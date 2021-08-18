import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image/image.dart' as imglib;
import 'package:med_cashback/constants/cashback_colors.dart';
import 'package:med_cashback/models/photo_mark_type.dart';
import 'package:med_cashback/models/recipe_photo_data.dart';

import 'image_rect_selector.dart';

class RecipeAddPhotoEditScreenArguments {
  final RecipePhotoData photoData;
  final Function completion;

  RecipeAddPhotoEditScreenArguments(this.photoData, this.completion);
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

  Rect? patientFioRect;
  Rect? dateRect;
  Rect? clinicRect;
  Rect? specialtyRect;
  Rect? diagnoseRect;
  Rect? drugRect;

  late Image _image;

  PhotoMarkType? _selectingMarkType;

  GlobalKey<ImageRectSelectorState> rectSelectorStateKey = GlobalKey();

  @override
  void initState() {
    patientFioRect = widget.arguments.photoData.patientFioRect;
    dateRect = widget.arguments.photoData.dateRect;
    clinicRect = widget.arguments.photoData.clinicRect;
    specialtyRect = widget.arguments.photoData.specialtyRect;
    diagnoseRect = widget.arguments.photoData.diagnoseRect;
    drugRect = widget.arguments.photoData.drugRect;

    _image = Image.memory(
        imglib.encodeJpg(widget.arguments.photoData.image) as Uint8List);
    super.initState();
  }

  void _selectMarkType(PhotoMarkType markType) {
    _setCurrentRectToMarkTypeRect();
    setState(() {
      _selectingMarkType = markType;
      switch (markType) {
        case PhotoMarkType.patientName:
          _currentRect = patientFioRect;
          break;
        case PhotoMarkType.doctorSpeciality:
          _currentRect = specialtyRect;
          break;
        case PhotoMarkType.clinic:
          _currentRect = clinicRect;
          break;
        case PhotoMarkType.date:
          _currentRect = dateRect;
          break;
        case PhotoMarkType.diagnose:
          _currentRect = diagnoseRect;
          break;
        case PhotoMarkType.drug:
          _currentRect = drugRect;
          break;
      }
      if (_currentRect != null) {
        rectSelectorStateKey.currentState?.cropRect = _currentRect!;
      }
    });
  }

  void _setCurrentRectToMarkTypeRect() {
    switch (_selectingMarkType) {
      case PhotoMarkType.patientName:
        patientFioRect = _currentRect;
        break;
      case PhotoMarkType.doctorSpeciality:
        specialtyRect = _currentRect;
        break;
      case PhotoMarkType.clinic:
        clinicRect = _currentRect;
        break;
      case PhotoMarkType.date:
        dateRect = _currentRect;
        break;
      case PhotoMarkType.diagnose:
        diagnoseRect = _currentRect;
        break;
      case PhotoMarkType.drug:
        drugRect = _currentRect;
        break;
      case null:
        break;
    }
  }

  List<PhotoMarkType> _definedMarksList() {
    List<PhotoMarkType> list = [];
    if (patientFioRect != null) {
      list.add(PhotoMarkType.patientName);
    }
    if (specialtyRect != null) {
      list.add(PhotoMarkType.doctorSpeciality);
    }
    if (clinicRect != null) {
      list.add(PhotoMarkType.clinic);
    }
    if (dateRect != null) {
      list.add(PhotoMarkType.date);
    }
    if (diagnoseRect != null) {
      list.add(PhotoMarkType.diagnose);
    }
    if (drugRect != null) {
      list.add(PhotoMarkType.drug);
    }
    return list;
  }

  List<ImageRectSelectorInactiveRectModel> _inactiveRects() {
    List<ImageRectSelectorInactiveRectModel> rects = [];

    if (patientFioRect != null &&
        _selectingMarkType != PhotoMarkType.patientName) {
      rects.add(ImageRectSelectorInactiveRectModel(
        patientFioRect!,
        PhotoMarkType.patientName.color(),
      ));
    }

    if (specialtyRect != null &&
        _selectingMarkType != PhotoMarkType.doctorSpeciality) {
      rects.add(ImageRectSelectorInactiveRectModel(
        specialtyRect!,
        PhotoMarkType.doctorSpeciality.color(),
      ));
    }

    if (clinicRect != null && _selectingMarkType != PhotoMarkType.clinic) {
      rects.add(ImageRectSelectorInactiveRectModel(
        clinicRect!,
        PhotoMarkType.clinic.color(),
      ));
    }

    if (dateRect != null && _selectingMarkType != PhotoMarkType.date) {
      rects.add(ImageRectSelectorInactiveRectModel(
        dateRect!,
        PhotoMarkType.date.color(),
      ));
    }

    if (diagnoseRect != null && _selectingMarkType != PhotoMarkType.diagnose) {
      rects.add(ImageRectSelectorInactiveRectModel(
        diagnoseRect!,
        PhotoMarkType.diagnose.color(),
      ));
    }

    if (drugRect != null && _selectingMarkType != PhotoMarkType.drug) {
      rects.add(ImageRectSelectorInactiveRectModel(
        drugRect!,
        PhotoMarkType.drug.color(),
      ));
    }

    return rects;
  }

  void _save() {
    _setCurrentRectToMarkTypeRect();
    widget.arguments.photoData.patientFioRect = patientFioRect;
    widget.arguments.photoData.dateRect = dateRect;
    widget.arguments.photoData.clinicRect = clinicRect;
    widget.arguments.photoData.specialtyRect = specialtyRect;
    widget.arguments.photoData.diagnoseRect = diagnoseRect;
    widget.arguments.photoData.drugRect = drugRect;
    widget.arguments.completion();
    _goBack();
  }

  void _goBack() {
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
              padding: const EdgeInsets.only(top: 91, bottom: 140),
              child: ImageRectSelector(
                key: rectSelectorStateKey,
                onRectChange: (rect) => _currentRect = rect,
                image: _image,
                style: ImageRectSelectorStyle.edit,
                rectColor: _selectingMarkType?.color(),
                inactiveRects: _inactiveRects(),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    AppLocalizations.of(context)!.recipeAddPhotoEditTitle,
                    style: TextStyle(
                      color: CashbackColors.contrastTextColor,
                    ),
                  ),
                ),
                Expanded(child: Container()),
                Container(
                  decoration: BoxDecoration(
                      color: CashbackColors.backgroundColor,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(8))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 6),
                      _RecipeAddPhotoEditMarkTypesList(
                        onSelect: (markType) => _selectMarkType(markType),
                        selectedMarkType: _selectingMarkType,
                        definedMarkTypes: _definedMarksList(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          height: 44,
                          child: TextButton(
                            onPressed: _save,
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  CashbackColors.accentColor),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!
                                  .recipeAddPhotosListSave,
                              style: TextStyle(
                                color: CashbackColors.contrastTextColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Align(
              alignment: AlignmentDirectional.topStart,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: InkWell(
                  onTap: _goBack,
                  child: Image.asset(
                    'assets/images/back_circle_icon.png',
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

class _RecipeAddPhotoEditMarkTypesList extends StatelessWidget {
  const _RecipeAddPhotoEditMarkTypesList({
    Key? key,
    required this.selectedMarkType,
    required this.definedMarkTypes,
    required this.onSelect,
  }) : super(key: key);

  final PhotoMarkType? selectedMarkType;
  final List<PhotoMarkType> definedMarkTypes;
  final Function(PhotoMarkType) onSelect;

  static const List<PhotoMarkType> _markTypes = [
    PhotoMarkType.patientName,
    PhotoMarkType.doctorSpeciality,
    PhotoMarkType.date,
    PhotoMarkType.clinic,
    PhotoMarkType.diagnose,
    PhotoMarkType.drug,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      child: ListView.separated(
        itemCount: _markTypes.length,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final markType = _markTypes[index];
          return GestureDetector(
            onTap: () => onSelect(markType),
            child: _RecipeAddPhotoEditMarkTypesListCell(
              markType: markType,
              isSelected: markType == selectedMarkType,
              isDefined: definedMarkTypes.contains(markType),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return SizedBox(width: 4);
        },
      ),
    );
  }
}

class _RecipeAddPhotoEditMarkTypesListCell extends StatelessWidget {
  const _RecipeAddPhotoEditMarkTypesListCell(
      {Key? key,
      required this.markType,
      required this.isSelected,
      required this.isDefined})
      : super(key: key);

  final PhotoMarkType markType;
  final bool isSelected;
  final bool isDefined;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      height: 22,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(11),
        color: isSelected
            ? markType.color()
            : CashbackColors.unselectedPhotoMarkTypeColor,
      ),
      child: Row(
        children: [
          Text(
            markType.localizedName(context),
            style: TextStyle(
              color: isSelected
                  ? CashbackColors.contrastTextColor
                  : CashbackColors.mainTextColor,
              fontSize: 12,
            ),
          ),
          isDefined
              ? Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Icon(
                    Icons.check,
                    color: isSelected
                        ? CashbackColors.contrastTextColor
                        : markType.color(),
                    size: 14,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
