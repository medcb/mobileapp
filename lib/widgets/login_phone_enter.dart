import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:med_cashback/constants/cashback_colors.dart';
import 'package:med_cashback/constants/constants.dart';
import 'package:med_cashback/constants/route_name.dart';
import 'package:med_cashback/generated/lib/generated/locale_keys.g.dart';
import 'package:med_cashback/network/auth_service.dart';
import 'package:med_cashback/widgets/components/full_screen_background_container.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:url_launcher/url_launcher.dart';

enum _LoginPhoneEnterScreenStatus {
  phoneEnter,
  codeEnter,
  loading,
}

final _codeLength = 4;

class LoginPhoneEnterScreen extends StatefulWidget {
  @override
  _LoginPhoneEnterScreenState createState() => _LoginPhoneEnterScreenState();
}

class _LoginPhoneEnterScreenState extends State<LoginPhoneEnterScreen> {
  _LoginPhoneEnterScreenStatus _screenStatus =
      _LoginPhoneEnterScreenStatus.phoneEnter;
  String? _phone;

  void _registerTapped(String phone) async {
    if (_phone == phone) {
      setState(() {
        _screenStatus = _LoginPhoneEnterScreenStatus.codeEnter;
      });
      return;
    }
    _register(phone);
  }

  void _register(String phone) async {
    setState(() {
      _screenStatus = _LoginPhoneEnterScreenStatus.loading;
    });
    try {
      await AuthService.instance.register(phone);
      setState(() {
        _phone = phone;
        _screenStatus = _LoginPhoneEnterScreenStatus.codeEnter;
      });
    } catch (err) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(err.toString())));
      setState(() {
        _screenStatus = _LoginPhoneEnterScreenStatus.phoneEnter;
      });
    }
  }

  void _changePhone() {
    setState(() {
      _screenStatus = _LoginPhoneEnterScreenStatus.phoneEnter;
    });
  }

  void _resendCode() async {
    if (_phone == null) {
      print('No phone found to resend code');
      return;
    }

    _register(_phone!);
  }

  void _sendCode(String code) async {
    if (code.length != _codeLength) return;
    setState(() {
      _screenStatus = _LoginPhoneEnterScreenStatus.loading;
    });
    try {
      await AuthService.instance.login(phone: _phone!, sms: code);
      final accountInfo = await AuthService.instance.getAccountInfo();
      if (!accountInfo.isFilled()) {
        Navigator.pushReplacementNamed(context, RouteName.profileFillInfo);
      } else {
        Navigator.pushReplacementNamed(context, RouteName.home);
      }
    } catch (err) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(err.toString())));
      setState(() {
        _screenStatus = _LoginPhoneEnterScreenStatus.codeEnter;
      });
    }
  }

  Widget? widgetForCurrentScreenStatus() {
    switch (_screenStatus) {
      case _LoginPhoneEnterScreenStatus.phoneEnter:
        return PhoneEnterContainer(_registerTapped);
      case _LoginPhoneEnterScreenStatus.loading:
        return Padding(
          padding: EdgeInsets.only(top: 16.0),
          child: Align(
            alignment: AlignmentDirectional.topCenter,
            child: CircularProgressIndicator(),
          ),
        );
      case _LoginPhoneEnterScreenStatus.codeEnter:
        return CodeEnterContainer(
          phone: _phone,
          changePhoneCallback: _changePhone,
          sendCodeCallback: _sendCode,
          resendCodeCallback: _resendCode,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final window = MediaQuery.of(context);
    return FullScreenBackgroundContainer(
      child: Stack(
        children: [
          AnimatedPadding(
            padding: EdgeInsets.fromLTRB(
                window.padding.left,
                window.padding.top,
                window.padding.right,
                window.viewInsets.bottom > 0
                    ? window.viewInsets.bottom
                    : window.padding.bottom),
            duration: const Duration(milliseconds: 100),
            curve: Curves.decelerate,
            child: Scaffold(
              backgroundColor: CashbackColors.backgroundColor,
              extendBody: true,
              resizeToAvoidBottomInset: false,
              body: Column(
                children: [
                  SizedBox(height: 50),
                  LogoAndTitle(),
                  LoginContentContainer(
                    child: widgetForCurrentScreenStatus(),
                  ),
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
          LocaleKeys.loginPhoneEnterWelcomeMessage.tr(),
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
        Padding(padding: EdgeInsets.only(top: 5)),
        Image.asset('assets/images/medcashback_text.png'),
      ],
    );
  }
}

class LoginContentContainer extends StatelessWidget {
  LoginContentContainer({
    Widget? child,
  }) : this.child = child;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadiusDirectional.only(
            topStart: Radius.circular(10), topEnd: Radius.circular(10)),
        color: Theme.of(context).colorScheme.background,
      ),
      padding: EdgeInsets.all(8.0),
      child: child,
    );
  }
}

class PhoneEnterContainer extends StatelessWidget {
  final Function(String) callback;

  PhoneEnterContainer(this.callback);

  void _openPrivacyPolicy() async {
    if (await canLaunch(Constants.kPrivacyPolicyURL)) {
      launch(Constants.kPrivacyPolicyURL);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 18, bottom: 24),
          child: Text(
            LocaleKeys.loginPhoneEnterEnterPhone.tr(),
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        PhoneEnterField((String phone) {
          callback(phone);
        }),
        SizedBox(
          height: 8,
        ),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: LocaleKeys.loginPhoneEnterPrivacyPolicyText.tr(),
            style: Theme.of(context).textTheme.bodyText1,
            children: [
              TextSpan(
                text: LocaleKeys.loginPhoneEnterPrivacyPolicyLink.tr(),
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .apply(decoration: TextDecoration.underline),
                recognizer: TapGestureRecognizer()..onTap = _openPrivacyPolicy,
              )
            ],
          ),
        ),
      ],
    );
  }
}

class PhoneEnterField extends StatefulWidget {
  final Function(String) callback;

  PhoneEnterField(this.callback);

  @override
  _PhoneEnterFieldState createState() => _PhoneEnterFieldState();
}

class _PhoneEnterFieldState extends State<PhoneEnterField> {
  var phone = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadiusDirectional.all(Radius.circular(4)),
        boxShadow: [
          BoxShadow(color: CashbackColors.textFieldBackgroundColor),
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
                  hintText: LocaleKeys.loginPhoneEnterPhonePlaceholder.tr(),
                  border: InputBorder.none),
              inputFormatters: [
                PhoneTextFieldFormatter(),
              ],
              onChanged: (string) {
                setState(() {
                  this.phone = string;
                });
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10),
          ),
          TextButton(
            onPressed: () {
              if (!isValidPhone()) {
                return;
              }
              widget.callback(phone);
            },
            child: Container(
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: this.isValidPhone()
                    ? CashbackColors.accentColor
                    : CashbackColors.disabledColor,
                borderRadius: BorderRadiusDirectional.all(Radius.circular(4)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Text(
                  LocaleKeys.loginPhoneEnterContinue.tr(),
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

class CodeEnterContainer extends StatefulWidget {
  final String? phone;
  final Function() changePhoneCallback;
  final Function(String) sendCodeCallback;
  final Function() resendCodeCallback;

  CodeEnterContainer({
    required this.phone,
    required this.changePhoneCallback,
    required this.sendCodeCallback,
    required this.resendCodeCallback,
  });

  @override
  _CodeEnterContainerState createState() => _CodeEnterContainerState();
}

class _CodeEnterContainerState extends State<CodeEnterContainer> {
  final _totalTimeToResend = 120;
  var _leftTimeToResend = 0;

  @override
  void initState() {
    super.initState();
    _setupResendTimer();
  }

  void _setupResendTimer() {
    setState(() {
      _leftTimeToResend = _totalTimeToResend;
    });
    Timer(Duration(seconds: 1), _resendTimerTick);
  }

  void _resendCode() {
    _setupResendTimer();
    widget.resendCodeCallback();
  }

  void _resendTimerTick() {
    if (_leftTimeToResend > 0) {
      _leftTimeToResend -= 1;
      if (mounted) {
        setState(() {});
      }
      Timer(Duration(seconds: 1), _resendTimerTick);
    }
  }

  void _codeEntered(String code) {
    widget.sendCodeCallback(code);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16),
        Text(
          LocaleKeys.loginCodeEnterTitle.tr(),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.phone!,
              style: TextStyle(fontSize: 12),
            ),
            SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                widget.changePhoneCallback();
              },
              child: Text(
                LocaleKeys.loginCodeEnterChangeNumber.tr(),
                style: TextStyle(
                  fontSize: 12,
                  color: CashbackColors.accentColor,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        SizedBox(
          width: 288,
          child: PinCodeTextField(
            appContext: context,
            length: _codeLength,
            onChanged: _codeEntered,
            autoFocus: true,
            boxShadows: [
              BoxShadow(color: CashbackColors.textFieldBackgroundColor),
            ],
            textStyle: TextStyle(
              fontSize: 18,
              color: CashbackColors.accentColor,
            ),
            inputFormatters: [CodeTextFieldFormatter()],
            keyboardType: TextInputType.numberWithOptions(),
            beforeTextPaste: (text) => false,
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(4),
              activeFillColor: CashbackColors.textFieldBackgroundColor,
              activeColor: CashbackColors.textFieldBackgroundColor,
              inactiveFillColor: CashbackColors.textFieldBackgroundColor,
              inactiveColor: CashbackColors.textFieldBackgroundColor,
              selectedFillColor: CashbackColors.textFieldBackgroundColor,
              selectedColor: CashbackColors.textFieldBackgroundColor,
              fieldWidth: 60,
              fieldHeight: 48,
            ),
          ),
        ),
        SizedBox(height: 16),
        _leftTimeToResend == 0
            ? GestureDetector(
                onTap: _resendCode,
                child: Text(LocaleKeys.loginCodeEnterResendButton.tr(),
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: CashbackColors.accentColor)),
              )
            : TimeLeftToResend(leftTimeToResend: _leftTimeToResend),
        SizedBox(
          height: 16,
        )
      ],
    );
  }
}

class TimeLeftToResend extends StatelessWidget {
  const TimeLeftToResend({
    Key? key,
    required this.leftTimeToResend,
  }) : super(key: key);

  final int leftTimeToResend;

  @override
  Widget build(BuildContext context) {
    return Text(
      LocaleKeys.loginCodeEnterResendTime.tr() +
          ' ${leftTimeToResend ~/ 60}:${NumberFormat('00').format(leftTimeToResend % 60)}',
      style: TextStyle(
        fontSize: 12,
        color: Theme.of(context).dividerColor,
      ),
    );
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

class CodeTextFieldFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final number = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    return TextEditingValue(
        text: number,
        selection: TextSelection.collapsed(offset: number.length));
  }
}
