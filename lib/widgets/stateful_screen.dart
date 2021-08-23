import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:med_cashback/constants/cashback_colors.dart';

enum StatefulScreenState { loading, error, content, empty }

class StatefulScreen extends StatefulWidget {
  StatefulScreen({
    required StatefulScreenState screenState,
    required Widget child,
    String? errorText,
    String? emptyText,
    VoidCallback? onRepeat,
  })  : this.screenState = screenState,
        this.child = child,
        this.errorText = errorText,
        this.emptyText = emptyText,
        this.onRepeat = onRepeat;

  final StatefulScreenState screenState;
  final Widget child;
  final String? errorText;
  final String? emptyText;
  final VoidCallback? onRepeat;

  @override
  _StatefulScreenState createState() => _StatefulScreenState();
}

class _StatefulScreenState extends State<StatefulScreen> {
  Image? _errorImage;

  @override
  void initState() {
    super.initState();
    _errorImage = Image.asset('assets/images/error_icon.png');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(_errorImage!.image, context);
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.screenState) {
      case StatefulScreenState.loading:
        return Container(
          child: Center(
            child: CircularProgressIndicator(
              color: CashbackColors.accentColor,
            ),
          ),
        );
      case StatefulScreenState.error:
        return emptyView(
          widget.errorText ?? AppLocalizations.of(context)!.errorDefault,
          AppLocalizations.of(context)!.repeatRequestError,
        );
      case StatefulScreenState.content:
        return widget.child;
      case StatefulScreenState.empty:
        return emptyView(
          AppLocalizations.of(context)!.emptyDefault,
          AppLocalizations.of(context)!.repeatRequestEmpty,
        );
    }
  }

  Widget emptyView(String title, String buttonText) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _errorImage!,
            Text(
              title,
              style: TextStyle(
                color: CashbackColors.contrastTextColor,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextButton(
              onPressed: () {
                if (widget.onRepeat != null) {
                  widget.onRepeat!();
                } else {
                  throw 'onRepeat should be implemented!';
                }
              },
              child: Text(
                buttonText,
                style: TextStyle(
                  color: CashbackColors.accentColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
