import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:med_cashback/constants/cashback_colors.dart';
import 'package:med_cashback/constants/route_name.dart';
import 'package:med_cashback/generated/lib/generated/locale_keys.g.dart';
import 'package:med_cashback/models/json_models.dart';
import 'package:med_cashback/widgets/payout_form_screen.dart';

class PayoutTypeSelect extends StatelessWidget {
  const PayoutTypeSelect({Key? key, required this.balance}) : super(key: key);

  final Balance balance;

  void _payByPhone(BuildContext context) {
    Navigator.popAndPushNamed(
      context,
      RouteName.payoutForm,
      arguments: PayoutFormScreenArguments(
        accountType: PayoutAccountType.phone,
        balance: balance,
      ),
    );
  }

  void _payByYoomoney(BuildContext context) {
    Navigator.popAndPushNamed(
      context,
      RouteName.payoutForm,
      arguments: PayoutFormScreenArguments(
        accountType: PayoutAccountType.yoomoney,
        balance: balance,
      ),
    );
  }

  void _dismiss(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 182 + MediaQuery.of(context).padding.bottom,
      decoration: BoxDecoration(
        color: CashbackColors.backgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 44,
              child: TextButton(
                onPressed: () => _payByPhone(context),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(CashbackColors.accentColor),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/payout_icon_phone.png'),
                    SizedBox(width: 10),
                    Text(
                      LocaleKeys.payoutOptionPhone.tr(),
                      style: TextStyle(
                        color: CashbackColors.contrastTextColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 44,
              child: TextButton(
                onPressed: () => _payByYoomoney(context),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(CashbackColors.yoomoneyColor),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/payout_icon_yoomoney.png'),
                    SizedBox(width: 10),
                    Text(
                      LocaleKeys.payoutOptionYoomoney.tr(),
                      style: TextStyle(
                        color: CashbackColors.contrastTextColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 44,
              child: TextButton(
                onPressed: () => _dismiss(context),
                child: Text(
                  LocaleKeys.payoutOptionCancel.tr(),
                  style: TextStyle(
                    color: CashbackColors.accentColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
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
