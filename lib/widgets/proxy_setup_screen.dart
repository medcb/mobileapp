import 'package:flutter/material.dart';
import 'package:med_cashback/network/custom_proxy.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProxySetupScreen extends StatefulWidget {
  const ProxySetupScreen({Key? key}) : super(key: key);

  @override
  _ProxySetupScreenState createState() => _ProxySetupScreenState();
}

class _ProxySetupScreenState extends State<ProxySetupScreen> {
  String address = '';
  String port = '';

  final _addressController = TextEditingController();
  final _portController = TextEditingController();

  final _kAddressKey = 'proxyAddress';
  final _kPortKey = 'proxyPort';

  @override
  void initState() {
    super.initState();
    _restoreValues();
  }

  void _restoreValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      setState(() {
        _addressController.text = address = prefs.getString(_kAddressKey) ?? '';
        _portController.text = port = prefs.getString(_kPortKey) ?? '';
      });
    } catch (err) {
      print(err);
    }
  }

  Future<void> _saveValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_kAddressKey, address);
    prefs.setString(_kPortKey, port);
  }

  void _enableProxy() async {
    try {
      final proxy = CustomProxy(ipAddress: address, port: int.parse(port));
      proxy.enable();
      await _saveValues();
      Navigator.pushReplacementNamed(context, '/');
    } catch (err) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(err.toString())));
    }
  }

  void _skipProxy() {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _addressController,
                onChanged: (value) => address = value,
                decoration: InputDecoration(hintText: 'Адрес прокси'),
              ),
              TextField(
                controller: _portController,
                onChanged: (value) => port = value,
                decoration: InputDecoration(hintText: 'Порт прокси'),
              ),
              TextButton(
                onPressed: _enableProxy,
                child: Text('Включить прокси'),
              ),
              TextButton(
                onPressed: _skipProxy,
                child: Text('Продолжить без прокси'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
