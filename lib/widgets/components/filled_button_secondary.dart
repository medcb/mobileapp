import 'package:flutter/material.dart';
import 'package:med_cashback/constants/cashback_colors.dart';

enum FilledButtonSecondaryState {
  disabled,
  enabled,
  selected,
}

class FilledButtonSecondary extends StatelessWidget {
  const FilledButtonSecondary({
    Key? key,
    required this.onPressed,
    required this.title,
    this.height = 40,
    this.state = FilledButtonSecondaryState.enabled,
  }) : super(key: key);

  final Function() onPressed;
  final String title;
  final double height;
  final FilledButtonSecondaryState state;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    switch (state) {
      case FilledButtonSecondaryState.disabled:
        backgroundColor = CashbackColors.buttonSecondaryDisabledBackgroundColor;
        textColor = CashbackColors.contrastTextColor;
        break;
      case FilledButtonSecondaryState.enabled:
        backgroundColor = CashbackColors.buttonSecondaryBackgroundColor;
        textColor = CashbackColors.mainTextColor;
        break;
      case FilledButtonSecondaryState.selected:
        backgroundColor = CashbackColors.buttonSecondarySelectedBackgroundColor;
        textColor = CashbackColors.contrastTextColor;
        break;
    }

    return SizedBox(
      height: height,
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
