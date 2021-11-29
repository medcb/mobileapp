import 'dart:math';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:med_cashback/constants/cashback_colors.dart';
import 'package:med_cashback/generated/lib/generated/locale_keys.g.dart';
import 'package:med_cashback/models/json_models.dart';
import 'package:med_cashback/widgets/login_phone_enter.dart';
import 'package:med_cashback/widgets/stateful_screen.dart';

enum PayoutAccountType {
  phone,
  yoomoney,
}

class PayoutFormScreenArguments {
  final PayoutAccountType accountType;
  final Balance balance;

  PayoutFormScreenArguments({required this.accountType, required this.balance});
}

class PayoutFormScreen extends StatefulWidget {
  const PayoutFormScreen({Key? key, required this.arguments}) : super(key: key);

  final PayoutFormScreenArguments arguments;

  @override
  _PayoutFormScreenState createState() => _PayoutFormScreenState();
}

class _PayoutFormScreenState extends State<PayoutFormScreen> {
  StatefulScreenState _screenState = StatefulScreenState.content;
  final CurrencyTextInputFormatter _currencyFormatter =
      CurrencyTextInputFormatter(symbol: '₽');
  late String sum;

  @override
  void initState() {
    super.initState();
    sum = min(widget.arguments.balance.balance, widget.arguments.balance.max)
        .toString();
  }

  TextInputFormatter _accountFieldInputFormatter() {
    switch (widget.arguments.accountType) {
      case PayoutAccountType.phone:
        return PhoneTextFieldFormatter();
      case PayoutAccountType.yoomoney:
        return CurrencyTextInputFormatter(decimalDigits: 0, symbol: '');
    }
  }

  Iterable<String>? _accountFieldAutofillHints() {
    switch (widget.arguments.accountType) {
      case PayoutAccountType.phone:
        return [AutofillHints.telephoneNumber];
      case PayoutAccountType.yoomoney:
        return [];
    }
  }

  String _accountFieldTitle() {
    switch (widget.arguments.accountType) {
      case PayoutAccountType.phone:
        return LocaleKeys.payoutOptionPhone.tr();
      case PayoutAccountType.yoomoney:
        return LocaleKeys.payoutOptionYoomoney.tr();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Color(0),
        actionsIconTheme: IconThemeData(
          color: CashbackColors.accentColor,
          opacity: 1,
          size: 100,
        ),
      ),
      body: StatefulScreen(
        screenState: _screenState,
        child: Container(
          color: CashbackColors.backgroundColor,
          child: ListView(
            padding: EdgeInsets.all(16),
            children: [
              Text(
                LocaleKeys.payoutTitle.tr(),
                style: TextStyle(
                  color: CashbackColors.mainTextColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 24),
              Text(
                LocaleKeys.payoutFieldSumTitle.tr(),
                style: TextStyle(
                  color: CashbackColors.mainTextColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: CashbackColors.shadowColor,
                    ),
                    BoxShadow(
                      color: CashbackColors.textFieldBackgroundColor,
                      offset: Offset(0, 2),
                      blurRadius: 8.0,
                    ),
                  ],
                ),
                child: TextFormField(
                  keyboardType: TextInputType.numberWithOptions(
                    decimal: true,
                    signed: false,
                  ),
                  style: Theme.of(context).textTheme.subtitle1,
                  autofocus: false,
                  inputFormatters: [_currencyFormatter],
                  initialValue: _currencyFormatter.format(sum),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    border: InputBorder.none,
                  ),
                  onChanged: (string) {},
                ),
              ),
              SizedBox(height: 24),
              Text(
                _accountFieldTitle(),
                style: TextStyle(
                  color: CashbackColors.mainTextColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: CashbackColors.shadowColor,
                    ),
                    BoxShadow(
                      color: CashbackColors.textFieldBackgroundColor,
                      offset: Offset(0, 2),
                      blurRadius: 8.0,
                    ),
                  ],
                ),
                child: TextField(
                  autofillHints: _accountFieldAutofillHints(),
                  keyboardType: TextInputType.number,
                  style: Theme.of(context).textTheme.subtitle1,
                  autofocus: true,
                  inputFormatters: [_accountFieldInputFormatter()],
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    border: InputBorder.none,
                  ),
                  onChanged: (string) {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
