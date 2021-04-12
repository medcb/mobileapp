import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:med_cashback/widgets/login_phone_enter.dart';
import 'package:med_cashback/widgets/main_tab_bar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus.unfocus();
        }
        // if (!currentFocus.hasPrimaryFocus) {
        //   print(currentFocus);
        //   currentFocus.unfocus();
        // }
      },
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        title: "МедКешбек",
        theme: ThemeData(
            fontFamily: 'Rubik',
            accentColor: Color(0xff0080F6),
            primaryColor: Color(0xffFFFFFF),
            backgroundColor: Color(0xffFFFFFF),
            disabledColor: Color(0x800080F6),
            dividerColor: Color(0xff8D95A7),
            textTheme: TextTheme(
              bodyText1: TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
              headline1: TextStyle(fontWeight: FontWeight.normal, fontSize: 24),
            ).apply(bodyColor: Color(0xff333333))),
        home: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: Image.asset('assets/images/background_circles.png').image,
              fit: BoxFit.cover,
            ),
          ),
          child: MainTabBar(),
          // child: LoginPhoneEnterScreen(),
        ),
      ),
    );
  }
}

class AuthPhoneEnter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LoginPhoneEnterScreen();
  }
}
