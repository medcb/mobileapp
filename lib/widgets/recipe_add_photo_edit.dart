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

  PhotoMarkType? _selectingMarkType;

  @override
  void initState() {
    _image = Image.memory(
        imglib.encodeJpg(widget.arguments.photoData.image) as Uint8List);
    super.initState();
  }

  void _selectMarkType(PhotoMarkType markType) {
    setState(() {
      _selectingMarkType = markType;
    });
  }

  void _save() {}

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
                onRectChange: (rect) => _currentRect = rect,
                image: _image,
                style: ImageRectSelectorStyle.edit,
                rectColor: _selectingMarkType?.color(),
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
                        definedMarkTypes: [],
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
      child: Text(
        markType.localizedName(context),
        style: TextStyle(
          color: isSelected
              ? CashbackColors.contrastTextColor
              : CashbackColors.mainTextColor,
          fontSize: 12,
        ),
      ),
    );
  }
}
