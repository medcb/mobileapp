import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:med_cashback/constants/cashback_colors.dart';
import 'package:med_cashback/constants/route_name.dart';
import 'package:med_cashback/generated/lib/generated/locale_keys.g.dart';
import 'package:med_cashback/models/json_models.dart';
import 'package:med_cashback/network/auth_service.dart';
import 'package:med_cashback/network/networking_client.dart';
import 'package:med_cashback/widgets/prescriptions_list_screen.dart';
import 'package:med_cashback/widgets/profile_screen.dart';
import 'package:med_cashback/widgets/stateful_screen.dart';

import 'components/full_screen_background_container.dart';

class MainTabBar extends StatefulWidget {
  @override
  _MainTabBarState createState() => _MainTabBarState();
}

class _MainTabBarState extends State<MainTabBar>
    with SingleTickerProviderStateMixin {
  StatefulScreenState _screenState = StatefulScreenState.loading;
  String? _errorText;

  TabController? _tabController;

  Image? _myRecipesActiveImage;
  Image? _myRecipesInactiveImage;
  Image? _profileActiveImage;
  Image? _profileInactiveImage;

  @override
  void initState() {
    super.initState();

    _myRecipesActiveImage =
        Image.asset('assets/images/tab_bar_my_recipes_active.png');
    _myRecipesInactiveImage =
        Image.asset('assets/images/tab_bar_my_recipes_inactive.png');
    _profileActiveImage =
        Image.asset('assets/images/tab_bar_profile_active.png');
    _profileInactiveImage =
        Image.asset('assets/images/tab_bar_profile_inactive.png');

    _tabController = TabController(length: 2, vsync: this);
    _tabController!.addListener(() {
      setState(() {});
    });

    loadProfile();
  }

  void loadProfile() async {
    AccountInfo? accountInfo = AuthService.instance.accountInfo;
    if (accountInfo == null) {
      setState(() {
        _screenState = StatefulScreenState.loading;
      });
      try {
        accountInfo = await AuthService.instance.getAccountInfo();
      } on UnauthorizedException {
        await AuthService.instance.clearAuthData();
        Navigator.pushReplacementNamed(context, RouteName.home);
      } catch (err) {
        setState(() {
          _errorText = err.toString();
          _screenState = StatefulScreenState.error;
        });
      }
    }
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      if (!accountInfo!.isFilled()) {
        Navigator.pushReplacementNamed(context, RouteName.profileFillInfo);
      } else {
        setState(() {
          _screenState = StatefulScreenState.content;
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(_myRecipesActiveImage!.image, context);
    precacheImage(_myRecipesInactiveImage!.image, context);
    precacheImage(_profileActiveImage!.image, context);
    precacheImage(_profileInactiveImage!.image, context);
  }

  @override
  Widget build(BuildContext context) {
    List<Tab> tabs = <Tab>[
      Tab(
        text: LocaleKeys.tabBarMyRecipes.tr(),
        icon: _tabController!.index == 0
            ? _myRecipesActiveImage
            : _myRecipesInactiveImage,
      ),
      Tab(
        text: LocaleKeys.tabBarProfile.tr(),
        icon: _tabController!.index == 1
            ? _profileActiveImage
            : _profileInactiveImage,
      ),
    ];

    var tabController = DefaultTabController(
      length: tabs.length,
      child: Builder(builder: (BuildContext context) {
        final window = MediaQuery.of(context);
        return Stack(
          children: [
            SafeArea(
              child: Scaffold(
                backgroundColor: Color(0),
                bottomNavigationBar: Container(
                  decoration:
                      BoxDecoration(color: Theme.of(context).backgroundColor),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).backgroundColor,
                      boxShadow: [
                        BoxShadow(
                            color: Theme.of(context).shadowColor,
                            blurRadius: 8,
                            offset: Offset(0, -4)),
                      ],
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(),
                      labelPadding: EdgeInsets.zero,
                      labelStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                      labelColor: CashbackColors.accentColor,
                      unselectedLabelColor: Theme.of(context).dividerColor,
                      tabs: tabs,
                    ),
                  ),
                ),
                body: TabBarView(
                  controller: _tabController,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    PrescriptionsListScreen(),
                    ProfileScreen(),
                  ],
                ),
              ),
            ),
            Positioned(
              height: window.viewInsets.bottom == 0
                  ? window.padding.bottom
                  : window.viewInsets.bottom,
              bottom: -window.viewInsets.bottom,
              left: 0,
              width: window.size.width,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                ),
              ),
            ),
          ],
        );
      }),
    );
    return FullScreenBackgroundContainer(
      child: StatefulScreen(
        screenState: _screenState,
        errorText: _errorText,
        child: tabController,
      ),
    );
  }
}
