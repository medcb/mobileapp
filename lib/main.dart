import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:med_cashback/constants/cashback_colors.dart';
import 'package:med_cashback/constants/route_name.dart';
import 'package:med_cashback/widgets/login_phone_enter.dart';
import 'package:med_cashback/widgets/main_tab_bar.dart';
import 'package:med_cashback/widgets/photo_crop_screen.dart';
import 'package:med_cashback/widgets/photo_shutter_screen.dart';
import 'package:med_cashback/widgets/proxy_setup_screen.dart';
import 'package:med_cashback/widgets/recipe_add_photo_edit.dart';
import 'package:med_cashback/widgets/recipe_add_photos_list_screen.dart';

import 'generated/codegen_loader.g.dart';

void main() async {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
  };
  runApp(MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final app = MyApp();
  runApp(EasyLocalization(
    supportedLocales: [Locale('ru', 'RU')],
    path: 'assets/translations',
    child: app,
    assetLoader: CodegenLoader(),
  ));
}

class MyApp extends StatelessWidget {
  final _isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
      child: MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        title: "МедКешбек",
        theme: ThemeData(
          fontFamily: 'Rubik',
          accentColor: CashbackColors.accentColor,
          primaryColor: CashbackColors.backgroundColor,
          backgroundColor: CashbackColors.backgroundColor,
          disabledColor: CashbackColors.accentDisabledColor,
          dividerColor: CashbackColors.disabledColor,
          shadowColor: CashbackColors.shadowColor,
          textTheme: TextTheme(
            bodyText1: TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
            headline1: TextStyle(fontWeight: FontWeight.normal, fontSize: 24),
          ).apply(bodyColor: CashbackColors.mainTextColor),
        ),
        onGenerateRoute: (RouteSettings settings) {
          var routes = <String, WidgetBuilder>{
            RouteName.home: (ctx) =>
                _isLoggedIn ? MainTabBar() : LoginPhoneEnterScreen(),
            RouteName.addRecipe: (ctx) => PhotoShutterScreen(
                  arguments: settings.arguments as PhotoShutterScreenArguments,
                ),
            RouteName.photoCrop: (ctx) => PhotoCropScreen(
                  arguments: settings.arguments as PhotoCropScreenArguments,
                ),
            RouteName.addRecipePhotosList: (ctx) => RecipeAddPhotosListScreen(
                  arguments:
                      settings.arguments as RecipeAddPhotosListScreenArguments,
                ),
            RouteName.addRecipePhotoEdit: (ctx) => RecipeAddPhotoEditScreen(
                arguments:
                    settings.arguments as RecipeAddPhotoEditScreenArguments),
            RouteName.proxySetup: (ctx) => ProxySetupScreen(),
          };
          WidgetBuilder? builder = routes[settings.name];
          if (builder != null) {
            return MaterialPageRoute(
                builder: (ctx) => builder(ctx), settings: settings);
          } else {
            return null;
          }
        },
        initialRoute: kReleaseMode ? RouteName.home : RouteName.proxySetup,
      ),
    );
  }
}
