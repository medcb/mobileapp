import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:med_cashback/constants/cashback_colors.dart';
import 'package:med_cashback/generated/lib/generated/locale_keys.g.dart';
import 'package:med_cashback/models/json_models.dart';

class PayoutSuccessScreenArguments {
  final BalanceHistoryItem historyItem;

  PayoutSuccessScreenArguments({required this.historyItem});
}

class PayoutSuccessScreen extends StatelessWidget {
  const PayoutSuccessScreen({Key? key, required this.arguments})
      : super(key: key);
  final PayoutSuccessScreenArguments arguments;

  String _destinationString() {
    switch (arguments.historyItem.type) {
      case BalanceHistoryItemType.self:
        return '';
      case BalanceHistoryItemType.phone:
        return LocaleKeys.balanceHistoryTypeFormatPhone
            .tr(args: [arguments.historyItem.destination ?? '']);
      case BalanceHistoryItemType.wallet:
        return LocaleKeys.balanceHistoryTypeFormatWallet
            .tr(args: [arguments.historyItem.destination ?? '']);
    }
  }

  @override
  Widget build(BuildContext context) {
    NumberFormat format = NumberFormat.currency(symbol: '₽');

    return Scaffold(
      body: Container(
        color: CashbackColors.backgroundColor,
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        LocaleKeys.payoutSuccessTitle.tr(),
                        style: TextStyle(
                          color: CashbackColors.mainTextColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 24,
                        ),
                      ),
                      SizedBox(height: 25),
                      Text(
                        _destinationString(),
                        style: TextStyle(
                          color: CashbackColors.secondaryTextColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 52),
                      Text(
                        format.format(
                            arguments.historyItem.amount.toDouble() / 100),
                        style: TextStyle(
                          color: CashbackColors.accentColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 30,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Image.asset('assets/images/payout_success_ok.png'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
