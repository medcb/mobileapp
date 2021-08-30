import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:med_cashback/constants/cashback_colors.dart';
import 'package:med_cashback/generated/lib/generated/locale_keys.g.dart';

import 'components/filled_button_secondary.dart';

class RecipeAddHandwrittenTypeSelectionDialog extends StatelessWidget {
  const RecipeAddHandwrittenTypeSelectionDialog(
      {Key? key, required this.completion})
      : super(key: key);

  final Function(bool) completion;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0),
      body: Column(
        children: [
          Expanded(child: Container()),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: CashbackColors.backgroundColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    LocaleKeys.recipeAddHandwrittenTypeTitle.tr(),
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: CashbackColors.mainTextColor,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButtonSecondary(
                          onPressed: () {
                            completion(true);
                            Navigator.pop(context);
                          },
                          title: LocaleKeys.recipeAddHandwrittenTypeTrue.tr(),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: FilledButtonSecondary(
                          onPressed: () {
                            completion(false);
                            Navigator.pop(context);
                          },
                          title: LocaleKeys.recipeAddHandwrittenTypeFalse.tr(),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
