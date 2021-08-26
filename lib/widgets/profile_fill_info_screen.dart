import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:med_cashback/constants/cashback_colors.dart';
import 'package:med_cashback/constants/route_name.dart';
import 'package:med_cashback/generated/lib/generated/locale_keys.g.dart';
import 'package:med_cashback/network/auth_service.dart';
import 'package:med_cashback/widgets/components/filled_button.dart';
import 'package:med_cashback/widgets/components/filled_button_secondary.dart';

import 'full_screen_background_container.dart';

enum Gender { male, female }

class ProfileFillInfoScreen extends StatefulWidget {
  const ProfileFillInfoScreen({Key? key}) : super(key: key);

  @override
  _ProfileFillInfoScreenState createState() => _ProfileFillInfoScreenState();
}

class _ProfileFillInfoScreenState extends State<ProfileFillInfoScreen> {
  String? secondName;
  String? firstName;
  String? middleName;
  Gender? _gender;
  DateTime? birthday;

  void _setGender(Gender? gender) {
    setState(() {
      _gender = gender;
    });
  }

  void _setBirthday(DateTime date) {
    setState(() {
      birthday = date;
    });
  }

  bool _isDataValid() {
    return (secondName?.trim().length ?? 0) > 0 &&
        (firstName?.trim().length ?? 0) > 0 &&
        _gender != null &&
        birthday != null;
  }

  void _save() async {
    if (!_isDataValid()) {
      return;
    }
    AuthService.instance.setAccountInfo(
      secondName: secondName!,
      firstName: firstName!,
      middleName: middleName,
      gender: _gender!,
      birthYear: birthday!.year,
    );
  }

  void _cancel() async {
    await AuthService.instance.clearAuthData();
    Navigator.pushReplacementNamed(context, RouteName.home);
  }

  @override
  Widget build(BuildContext context) {
    final window = MediaQuery.of(context);
    return FullScreenBackgroundContainer(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            window.padding.left,
            window.padding.top,
            window.padding.right,
            window.viewInsets.bottom > 0
                ? window.viewInsets.bottom
                : window.padding.bottom),
        child: Scaffold(
          extendBody: true,
          resizeToAvoidBottomInset: false,
          backgroundColor: Color(0),
          body: Container(
            decoration: BoxDecoration(
              color: CashbackColors.backgroundColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: CashbackColors.shadowColor,
                  blurRadius: 8,
                )
              ],
            ),
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    LocaleKeys.profileFillInfoTitle.tr(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: CashbackColors.mainTextColor,
                    ),
                  ),
                ),
                ProfileFillInfoScreenTextField(
                  title: LocaleKeys.profileFillInfoSecondName.tr(),
                  onChanged: (text) => setState(() {
                    secondName = text;
                  }),
                ),
                ProfileFillInfoScreenTextField(
                  title: LocaleKeys.profileFillInfoFirstName.tr(),
                  onChanged: (text) => setState(() {
                    firstName = text;
                  }),
                ),
                ProfileFillInfoScreenTextField(
                  title: LocaleKeys.profileFillInfoMiddleName.tr(),
                  onChanged: (text) => setState(() {
                    middleName = text;
                  }),
                ),
                ProfileFillInfoScreenGenderSelector(
                  gender: _gender,
                  completion: _setGender,
                ),
                ProfileInfoEnterBirthdaySelector(
                  date: birthday,
                  onChanged: _setBirthday,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: FilledButton(
                    onPressed: _save,
                    isEnabled: _isDataValid(),
                    title: LocaleKeys.profileFillInfoSave.tr(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: TextButton(
                    onPressed: _cancel,
                    child: Text(
                      LocaleKeys.profileFillInfoCancel.tr(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileFillInfoScreenTextField extends StatefulWidget {
  const ProfileFillInfoScreenTextField({
    Key? key,
    required this.title,
    required this.onChanged,
  }) : super(key: key);

  final String title;
  final Function(String) onChanged;

  @override
  _ProfileFillInfoScreenTextFieldState createState() =>
      _ProfileFillInfoScreenTextFieldState();
}

class _ProfileFillInfoScreenTextFieldState
    extends State<ProfileFillInfoScreenTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: CashbackColors.mainTextColor,
            ),
          ),
          SizedBox(height: 8),
          SizedBox(
            height: 40,
            child: TextField(
              onChanged: widget.onChanged,
              textAlignVertical: TextAlignVertical.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: CashbackColors.mainTextColor,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: CashbackColors.textFieldBackgroundColor,
                contentPadding: EdgeInsets.only(left: 8, right: 8, bottom: 16),
                border: UnderlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileFillInfoScreenGenderSelector extends StatelessWidget {
  const ProfileFillInfoScreenGenderSelector(
      {Key? key, required this.gender, required this.completion})
      : super(key: key);

  final Gender? gender;
  final Function(Gender?) completion;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            LocaleKeys.profileFillInfoGender.tr(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: CashbackColors.mainTextColor,
            ),
          ),
          SizedBox(height: 8),
          SizedBox(
            height: 40,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: FilledButtonSecondary(
                    onPressed: () => completion(Gender.male),
                    title: LocaleKeys.profileFillInfoGenderMale.tr(),
                    state: gender == Gender.male
                        ? FilledButtonSecondaryState.selected
                        : FilledButtonSecondaryState.enabled,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: FilledButtonSecondary(
                    onPressed: () => completion(Gender.female),
                    title: LocaleKeys.profileFillInfoGenderFemale.tr(),
                    state: gender == Gender.female
                        ? FilledButtonSecondaryState.selected
                        : FilledButtonSecondaryState.enabled,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ProfileInfoEnterBirthdaySelector extends StatelessWidget {
  const ProfileInfoEnterBirthdaySelector({
    Key? key,
    required this.date,
    required this.onChanged,
  }) : super(key: key);

  final DateTime? date;
  final Function(DateTime) onChanged;

  void _selectDate(BuildContext context) async {
    final selectedDate = await showDatePicker(
        context: context,
        initialDate: date ?? DateTime(1980, 1, 1),
        firstDate: DateTime(1900, 1, 1),
        lastDate: DateTime.now());
    if (selectedDate != null) {
      onChanged(selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            LocaleKeys.profileFillInfoBirthday.tr(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: CashbackColors.mainTextColor,
            ),
          ),
          SizedBox(height: 8),
          SizedBox(
            height: 40,
            child: InkWell(
              onTap: () => _selectDate(context),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: CashbackColors.textFieldBackgroundColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          date != null
                              ? DateFormat('dd.MM.yyyy').format(date!)
                              : LocaleKeys.profileFillInfoBirthdayEmpty.tr(),
                          style: TextStyle(
                            color: date != null
                                ? CashbackColors.mainTextColor
                                : CashbackColors.disabledColor,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.calendar_today,
                        size: 22,
                        color: CashbackColors.disabledColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
