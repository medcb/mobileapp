import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:med_cashback/constants/cashback_colors.dart';
import 'package:med_cashback/constants/route_name.dart';
import 'package:med_cashback/generated/lib/generated/locale_keys.g.dart';
import 'package:med_cashback/widgets/components/filled_button.dart';
import 'package:med_cashback/widgets/photo_shutter_screen.dart';
import 'package:med_cashback/widgets/stateful_screen.dart';

class PrescriptionsListScreen extends StatefulWidget {
  const PrescriptionsListScreen({Key? key}) : super(key: key);

  @override
  _PrescriptionsListScreenState createState() =>
      _PrescriptionsListScreenState();
}

class _PrescriptionsListScreenState extends State<PrescriptionsListScreen> {
  StatefulScreenState _screenState = StatefulScreenState.content;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    // TODO: load data
  }

  void _addPrescription() {
    Navigator.pushNamed(
      context,
      RouteName.addRecipe,
      arguments: PhotoShutterScreenArguments(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StatefulScreen(
      onRepeat: _loadData,
      screenState: _screenState,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              LocaleKeys.prescriptionsListTitle.tr(),
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20,
                color: CashbackColors.mainTextColor,
              ),
            ),
          ),
          Expanded(
            child: Container(),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton(
              onPressed: _addPrescription,
              title: LocaleKeys.prescriptionsListAdd.tr(),
            ),
          ),
        ],
      ),
    );
  }
}
