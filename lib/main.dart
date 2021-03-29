import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:med_cashback/login_phone_enter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: AuthPhoneEnter(),
      title: "МедКешбек",
      theme: ThemeData(
          fontFamily: 'Rubik',
          accentColor: Color(0xff0080F6),
          primaryColor: Color(0xffFFFFFF),
          backgroundColor: Color(0xffFFFFFF),
          disabledColor: Color(0x800080F6),
          textTheme: TextTheme(
            bodyText1: TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
            headline1: TextStyle(fontWeight: FontWeight.normal, fontSize: 24),
          ).apply(bodyColor: Color(0xff333333))),
    );
  }
}

class AuthPhoneEnter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LoginPhoneEnterScreen();
  }
}
