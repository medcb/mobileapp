import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:med_cashback/widgets/main_screen.dart';
import 'package:med_cashback/widgets/profile_screen.dart';

import 'full_screen_background_container.dart';

class MainTabBar extends StatefulWidget {
  @override
  _MainTabBarState createState() => _MainTabBarState();
}

class _MainTabBarState extends State<MainTabBar>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Tab> tabs = <Tab>[
      Tab(
        text: AppLocalizations.of(context).tabBarMain,
        icon: _tabController.index == 0
            ? Image.asset('assets/images/tab_bar_main_active.png')
            : Image.asset('assets/images/tab_bar_main_inactive.png'),
      ),
      Tab(
        text: AppLocalizations.of(context).tabBarMyRecipes,
        icon: _tabController.index == 1
            ? Image.asset('assets/images/tab_bar_my_recipes_active.png')
            : Image.asset('assets/images/tab_bar_my_recipes_inactive.png'),
      ),
      Tab(
        text: AppLocalizations.of(context).tabBarReviews,
        icon: _tabController.index == 2
            ? Image.asset('assets/images/tab_bar_reviews_active.png')
            : Image.asset('assets/images/tab_bar_reviews_inactive.png'),
      ),
      Tab(
        // child: TabIcon(_tabController.index == 3),
        text: AppLocalizations.of(context).tabBarProfile,
        icon: _tabController.index == 3
            ? Image.asset('assets/images/tab_bar_profile_active.png')
            : Image.asset('assets/images/tab_bar_profile_inactive.png'),
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
                backgroundColor: Color(0x00000000),
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
                      labelColor: Theme.of(context).accentColor,
                      unselectedLabelColor: Theme.of(context).dividerColor,
                      tabs: tabs,
                    ),
                  ),
                ),
                body: TabBarView(
                  controller: _tabController,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    MainScreen(),
                    Center(child: Text('Work In Progress')),
                    Center(child: Text('Work In Progress')),
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
    return FullScreenBackgroundContainer(child: tabController);
  }
}
