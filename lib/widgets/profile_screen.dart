import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:med_cashback/constants/route_name.dart';
import 'package:med_cashback/generated/lib/generated/locale_keys.g.dart';
import 'package:med_cashback/network/auth_service.dart';
import 'package:package_info/package_info.dart';

class ProfileScreen extends StatelessWidget {
  void _logout(BuildContext context) async {
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

  void _openAgreement(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Пока у нас нет URL соглашения 🤷‍')));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                  onTap: () => _openAgreement(context),
                  itemName: LocaleKeys.profileAgreement.tr(),
                ),
                ProfileScreenItem(
                  onTap: () => _logout(context),
                  itemName: LocaleKeys.profileLogout.tr(),
                ),
                ProfileAppVersion(),
                SizedBox(height: 16),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class ProfileScreenItem extends StatelessWidget {
  const ProfileScreenItem({
    Key? key,
    required this.onTap,
    required this.itemName,
  }) : super(key: key);

  final Function() onTap;
  final String itemName;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          itemName,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
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
                  'Профиль',
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
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
