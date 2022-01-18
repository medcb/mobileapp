import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:med_cashback/constants/cashback_colors.dart';
import 'package:med_cashback/constants/constants.dart';
import 'package:med_cashback/constants/route_name.dart';
import 'package:med_cashback/generated/lib/generated/locale_keys.g.dart';
import 'package:med_cashback/network/auth_service.dart';
import 'package:med_cashback/widgets/stateful_screen.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  StatefulScreenState _screenState = StatefulScreenState.content;

  void _logout() async {
    final yesButton = TextButton(
      onPressed: () async {
        Navigator.pop(context);
        await AuthService.instance.clearAuthData();
        Navigator.pushReplacementNamed(context, RouteName.home);
      },
      child: Text(LocaleKeys.profileLogoutAlertYes.tr()),
    );
    final noButton = TextButton(
      onPressed: () => Navigator.pop(context),
      child: Text(LocaleKeys.profileLogoutAlertNo.tr()),
    );
    final alertDialog = AlertDialog(
      title: Text(LocaleKeys.profileLogoutAlertTitle.tr()),
      actions: [noButton, yesButton],
    );
    showDialog(
      context: context,
      builder: (context) => alertDialog,
    );
  }

  void _deleteAccount() async {
    final yesButton = TextButton(
      onPressed: () async {
        Navigator.pop(context);
        _performAccountDelete();
      },
      child: Text(LocaleKeys.profileDeleteAccountAlertYes.tr()),
    );
    final noButton = TextButton(
      onPressed: () => Navigator.pop(context),
      child: Text(LocaleKeys.profileDeleteAccountAlertNo.tr()),
    );
    final alertDialog = AlertDialog(
      title: Text(LocaleKeys.profileDeleteAccountAlertTitle.tr()),
      actions: [noButton, yesButton],
    );
    showDialog(
      context: context,
      builder: (context) => alertDialog,
    );
  }

  void _performAccountDelete() async {
    setState(() {
      _screenState = StatefulScreenState.loading;
    });
    try {
      await AuthService.instance.deleteAccount();
      Navigator.pushReplacementNamed(context, RouteName.home);
    } catch (err) {
      setState(() {
        _screenState = StatefulScreenState.content;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(err.toString())));
    }
  }

  void _openAgreement() async {
    if (await canLaunch(Constants.kPrivacyPolicyURL)) {
      launch(Constants.kPrivacyPolicyURL);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StatefulScreen(
      screenState: _screenState,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: ListView(
                children: [
                  SizedBox(height: 16),
                  ProfileHeader(),
                  ProfileScreenItem(
                    onTap: () => _openAgreement(),
                    itemName: LocaleKeys.profileAgreement.tr(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Container(
                      height: 1,
                      color: CashbackColors.buttonSecondaryBackgroundColor,
                    ),
                  ),
                  ProfileScreenItem(
                    onTap: () => _logout(),
                    itemName: LocaleKeys.profileLogout.tr(),
                    imageName: 'assets/images/logout.png',
                  ),
                  ProfileScreenItem(
                    onTap: () => _deleteAccount(),
                    itemName: LocaleKeys.profileDeleteAccount.tr(),
                    imageName: 'assets/images/delete.png',
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Container(
                      height: 1,
                      color: CashbackColors.buttonSecondaryBackgroundColor,
                    ),
                  ),
                  ProfileAppVersion(),
                  SizedBox(height: 16),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ProfileScreenItem extends StatelessWidget {
  const ProfileScreenItem({
    Key? key,
    required this.onTap,
    required this.itemName,
    this.imageName,
  }) : super(key: key);

  final Function() onTap;
  final String itemName;
  final String? imageName;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            if (imageName != null) ...{
              Image.asset(imageName!),
              SizedBox(width: 16),
            },
            Text(
              itemName,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.profileTitle.tr(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileAppVersion extends StatefulWidget {
  @override
  _ProfileAppVersionState createState() => _ProfileAppVersionState();
}

class _ProfileAppVersionState extends State<ProfileAppVersion> {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    final version =
        _packageInfo.version.isNotEmpty ? _packageInfo.version : "???";
    final buildNumber =
        _packageInfo.buildNumber.isNotEmpty ? _packageInfo.buildNumber : "???";
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        LocaleKeys.profileVersion.tr(args: ['$version ($buildNumber)']),
        style: TextStyle(
          color: CashbackColors.secondaryTextColor,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
