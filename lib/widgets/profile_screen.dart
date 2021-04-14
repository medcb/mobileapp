import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'ФИО',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              ProfileHeader(),
              ProfileScreenItem('Дети'),
              ProfileScreenItem('Отзывы'),
              ProfileScreenItem('Способы вывода средств'),
              ProfileScreenItem('История выводов'),
              ProfileScreenItemWithSwitch('Вход по отпечатку пальца'),
              ProfileScreenItem('Условия и соглашения'),
              ProfileScreenItem('Обратная связь'),
              ProfileScreenItem('Выйти'),
              ProfileAppVersion(),
              SizedBox(height: 16),
            ],
          ),
        )
      ],
    );
  }
}

class ProfileScreenItem extends StatelessWidget {
  final String itemName;

  ProfileScreenItem(this.itemName);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        itemName,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class ProfileScreenItemWithSwitch extends StatefulWidget {
  final String itemName;

  ProfileScreenItemWithSwitch(this.itemName);

  @override
  _ProfileScreenItemWithSwitchState createState() =>
      _ProfileScreenItemWithSwitchState();
}

class _ProfileScreenItemWithSwitchState
    extends State<ProfileScreenItemWithSwitch> {
  var enabled = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 2,
        horizontal: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              widget.itemName,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Switch.adaptive(
            value: enabled,
            activeColor: Theme.of(context).accentColor,
            onChanged: (value) {
              setState(() {
                enabled = value;
              });
              print('changed');
            },
          )
        ],
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
          Image.asset('assets/images/profile_placeholder.png'),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ФИО',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  '+7 999 999-12-34',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 7),
                Text(
                  'email@mailservice.com',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 16),
          Icon(Icons.edit),
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
        'Версия $version ($buildNumber)',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
