import 'package:flutter/material.dart';
import 'package:med_cashback/constants/cashback_colors.dart';

class FilledButton extends StatelessWidget {
  const FilledButton({
    Key? key,
    required this.onPressed,
    required this.title,
    this.height = 44,
    this.isEnabled = true,
  }) : super(key: key);

  final Function() onPressed;
  final String title;
  final double height;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(isEnabled
              ? CashbackColors.accentColor
              : CashbackColors.accentDisabledColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        onPressed: isEnabled ? onPressed : null,
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: CashbackColors.contrastTextColor,
          ),
        ),
      ),
    );
  }
}
