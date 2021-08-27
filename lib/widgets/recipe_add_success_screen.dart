import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:med_cashback/constants/cashback_colors.dart';
import 'package:med_cashback/generated/lib/generated/locale_keys.g.dart';
import 'package:med_cashback/widgets/components/filled_button.dart';
import 'package:med_cashback/widgets/components/full_screen_background_container.dart';

class RecipeAddSuccessScreen extends StatelessWidget {
  const RecipeAddSuccessScreen({Key? key}) : super(key: key);

  void _dismiss(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FullScreenBackgroundContainer(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: Container()),
                Text(
                  LocaleKeys.recipeAddSuccessTitle.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: CashbackColors.mainTextColor,
                  ),
                ),
                SizedBox(height: 40),
                Text(
                  LocaleKeys.recipeAddSuccessMessage.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: CashbackColors.mainTextColor,
                  ),
                ),
                Expanded(child: Container()),
                Expanded(child: Container()),
                FilledButton(
                  onPressed: () => _dismiss(context),
                  title: LocaleKeys.ok.tr(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
