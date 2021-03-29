import 'dart:math';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPhoneEnterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: Image.asset('assets/images/background_circles.png').image,
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Color(0x00000000),
        // appBar: AppBar(),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(padding: EdgeInsets.only(top: 60)),
              LogoAndTitle(),
              Spacer(),
              PhoneEnterContainer(),
            ],
          ),
        ),
      ),
    );
  }
}

class LogoAndTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Image.asset(
            'assets/images/app_logo.png',
          ),
        ),
        Text(
          AppLocalizations.of(context).loginPhoneEnterWelcomeMessage,
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
        Padding(padding: EdgeInsets.only(top: 5)),
        Image.asset('assets/images/medcashback_text.png'),
      ],
    );
  }
}

class PhoneEnterContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadiusDirectional.only(
            topStart: Radius.circular(10), topEnd: Radius.circular(10)),
        color: Theme.of(context).colorScheme.background,
      ),
      padding: EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 18, bottom: 24),
            child: Text(
              AppLocalizations.of(context).loginPhoneEnterEnterPhone,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          PhoneEnterField(),
          SizedBox(
            height: 8,
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text:
                  AppLocalizations.of(context).loginPhoneEnterPrivacyPolicyText,
              style: Theme.of(context).textTheme.bodyText1,
              children: [
                TextSpan(
                  text: AppLocalizations.of(context)
                      .loginPhoneEnterPrivacyPolicyLink,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .apply(decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      const _url = 'https://google.com';
                      await canLaunch(_url)
                          ? launch(_url)
                          : print('cannot launch url');
                    },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PhoneEnterField extends StatefulWidget {
  @override
  _PhoneEnterFieldState createState() => _PhoneEnterFieldState();
}

class _PhoneEnterFieldState extends State<PhoneEnterField> {
  var phone = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // color: Colors.white,
        borderRadius: BorderRadiusDirectional.all(Radius.circular(4)),
        boxShadow: [
          BoxShadow(color: Color(0xffF7F8FA)),
          BoxShadow(color: Color(0xD000000), spreadRadius: -2, blurRadius: 8),
        ],
      ),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              autofillHints: [AutofillHints.telephoneNumber],
              keyboardType: TextInputType.phone,
              style: Theme.of(context).textTheme.subtitle1,
              autofocus: true,
              decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)
                      .loginPhoneEnterPhonePlaceholder,
                  border: InputBorder.none),
              inputFormatters: [
                PhoneTextFieldFormatter(),
              ],
              onChanged: (string) {
                setState(() {
                  this.phone = string;
                });
              },
              // controller: PhoneTextFieldFormatter(),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10),
          ),
          GestureDetector(
            onTap: () {
              if (!isValidPhone()) {
                return;
              }
              FocusScope.of(context).unfocus();
              // TODO: Handle tap here
            },
            child: Container(
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: this.isValidPhone()
                    ? Theme.of(context).accentColor
                    : Theme.of(context).disabledColor,
                borderRadius: BorderRadiusDirectional.all(Radius.circular(4)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Text(
                  'Продолжить',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool isValidPhone() {
    return phone.length == 18;
  }
}

class PhoneTextFieldFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    int usedSubstringIndex = 1;
    final newTextBuffer = StringBuffer();
    var plainNumber = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    if (plainNumber.length >= 1) {
      if (plainNumber.startsWith(RegExp(r'[789]'))) {
        newTextBuffer.write('+7 (');
        usedSubstringIndex = 1;
        if (plainNumber.startsWith('9')) {
          newTextBuffer.write('9');
          usedSubstringIndex = 2;
        }
      }
    }

    if (plainNumber.length > usedSubstringIndex) {
      newTextBuffer.write(plainNumber.substring(
          usedSubstringIndex, min(usedSubstringIndex + 3, plainNumber.length)));
      usedSubstringIndex += 3;
    }

    if (plainNumber.length > usedSubstringIndex) {
      newTextBuffer.write(') ');
      newTextBuffer.write(plainNumber.substring(
          usedSubstringIndex, min(usedSubstringIndex + 3, plainNumber.length)));
      usedSubstringIndex += 3;
    }

    if (plainNumber.length > usedSubstringIndex) {
      newTextBuffer.write('-');
      newTextBuffer.write(plainNumber.substring(
          usedSubstringIndex, min(usedSubstringIndex + 2, plainNumber.length)));
      usedSubstringIndex += 2;
    }

    if (plainNumber.length > usedSubstringIndex) {
      newTextBuffer.write('-');
      newTextBuffer.write(plainNumber.substring(
          usedSubstringIndex, min(usedSubstringIndex + 2, plainNumber.length)));
      usedSubstringIndex += 2;
    }

    return TextEditingValue(
      text: newTextBuffer.toString(),
      selection: TextSelection.collapsed(offset: newTextBuffer.length),
    );
  }
}
