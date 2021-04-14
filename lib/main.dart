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
            shadowColor: Color(0x1a000000),
            textTheme: TextTheme(
              bodyText1: TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
              headline1: TextStyle(fontWeight: FontWeight.normal, fontSize: 24),
            ).apply(bodyColor: Color(0xff333333))),
        routes: <String, WidgetBuilder>{
          '/main': (BuildContext context) => MainTabBar(),
          '/login': (BuildContext context) => LoginPhoneEnterScreen(),
        },
        home: LoginPhoneEnterScreen(),
      ),
    );
  }
}
