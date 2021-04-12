import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        return SafeArea(
          child: Scaffold(
            bottomNavigationBar: TabBar(
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
            body: TabBarView(
              controller: _tabController,
              physics: NeverScrollableScrollPhysics(),
              children: tabs.map((Tab tab) {
                return Center(
                  child: Column(
                    children: [
                      tab.icon,
                      Text(
                        tab.text,
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        );
      }),
    );
    return tabController;
  }
}
