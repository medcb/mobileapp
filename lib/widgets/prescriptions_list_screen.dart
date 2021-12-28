import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:med_cashback/constants/cashback_colors.dart';
import 'package:med_cashback/constants/route_name.dart';
import 'package:med_cashback/generated/lib/generated/locale_keys.g.dart';
import 'package:med_cashback/models/json_models.dart';
import 'package:med_cashback/network/balance_service.dart';
import 'package:med_cashback/network/prescriptions_service.dart';
import 'package:med_cashback/widgets/balance_history_screen.dart';
import 'package:med_cashback/widgets/components/filled_button.dart';
import 'package:med_cashback/widgets/payout_type_select.dart';
import 'package:med_cashback/widgets/photo_shutter_screen.dart';
import 'package:med_cashback/widgets/prescription_details_screen.dart';
import 'package:med_cashback/widgets/stateful_screen.dart';

class PrescriptionsListScreen extends StatefulWidget {
  const PrescriptionsListScreen({Key? key}) : super(key: key);

  @override
  _PrescriptionsListScreenState createState() =>
      _PrescriptionsListScreenState();
}

class _PrescriptionsListScreenState extends State<PrescriptionsListScreen> {
  StatefulScreenState _screenState = StatefulScreenState.loading;
  String _errorText = '';

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  var _listenPrescriptionsServiceChange;
  List<Prescription> _prescriptions = [];
  Balance? _balance;

  @override
  void initState() {
    super.initState();

    _listenPrescriptionsServiceChange = _prescriptionsStateChanged;
    PrescriptionsService.instance
        .addListener(_listenPrescriptionsServiceChange);
    _loadData();
  }

  @override
  void dispose() {
    PrescriptionsService.instance
        .removeListener(_listenPrescriptionsServiceChange);
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      _balance = await BalanceService().loadBalance();
    } catch (error) {
      setState(() {
        _errorText = error.toString();
        _screenState = StatefulScreenState.error;
      });
      return;
    }
    await PrescriptionsService.instance.reloadPrescriptions();
    setState(() {});
  }

  void _prescriptionsStateChanged() {
    if (!mounted) return;
    if (_screenState == StatefulScreenState.content &&
        PrescriptionsService.instance.state ==
            PrescriptionsServiceLoadState.loading) {
      // update by RefreshIndicator
      return;
    }
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      if (_balance == null) {
        return;
      }
      setState(() {
        switch (PrescriptionsService.instance.state) {
          case PrescriptionsServiceLoadState.notLoaded:
            _screenState = StatefulScreenState.empty;
            break;
          case PrescriptionsServiceLoadState.loading:
            _screenState = StatefulScreenState.loading;
            break;
          case PrescriptionsServiceLoadState.loaded:
            _prescriptions = PrescriptionsService.instance.prescriptions ?? [];
            _screenState = _prescriptions.length > 0
                ? StatefulScreenState.content
                : StatefulScreenState.empty;
            break;
          case PrescriptionsServiceLoadState.error:
            _errorText = PrescriptionsService.instance.error.toString();
            _screenState = StatefulScreenState.error;
            break;
        }
      });
    });
  }

  void _addPrescription() {
    Navigator.pushNamed(
      context,
      RouteName.addRecipe,
      arguments: PhotoShutterScreenArguments(),
    );
  }

  void _openPrescription(Prescription prescription) {
    Navigator.pushNamed(
      context,
      RouteName.prescriptionDetails,
      arguments: PrescriptionDetailsScreenArguments(prescription),
    );
  }

  void _openPayout() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Color(0),
      builder: (context) => PayoutTypeSelect(
        balance: _balance!,
        onBalanceUpdated: _onBalanceUpdated,
      ),
    );
  }

  void _onBalanceUpdated(Balance newBalance) {
    setState(() {
      _balance = newBalance;
    });
  }

  void _openBalanceHistory() {
    if (_balance == null) return;
    Navigator.of(context).pushNamed(
      RouteName.balanceHistory,
      arguments: BalanceHistoryScreenArguments(
        balance: _balance!,
        onBalanceUpdated: _onBalanceUpdated,
      ),
    );
  }

  Widget _prescriptionsList() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        color: CashbackColors.backgroundColor,
      ),
      child: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _loadData,
        child: ListView.separated(
          itemCount: _prescriptions.length,
          itemBuilder: (context, index) => GestureDetector(
            onTap: () => _openPrescription(_prescriptions[index]),
            child: PrescriptionsListItem(prescription: _prescriptions[index]),
          ),
          separatorBuilder: (ctx, index) => Container(
            color: CashbackColors.shadowColor,
            height: 1,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_balance != null) ...{
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: BalanceHeader(
              balance: _balance!,
              onPayoutTap: _openPayout,
              onBalanceHistoryTap: _openBalanceHistory,
            ),
          ),
        },
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            LocaleKeys.prescriptionsListTitle.tr(),
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
              color: CashbackColors.mainTextColor,
            ),
          ),
        ),
        Expanded(
          child: StatefulScreen(
            onRepeat: _loadData,
            screenState: _screenState,
            emptyText: LocaleKeys.prescriptionsListEmpty.tr(),
            errorText: _errorText,
            child: _prescriptionsList(),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: CashbackColors.backgroundColor,
            border: Border(
              top: BorderSide(color: CashbackColors.shadowColor, width: 1),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton(
              onPressed: _addPrescription,
              title: LocaleKeys.prescriptionsListAdd.tr(),
            ),
          ),
        ),
      ],
    );
  }
}

class BalanceHeader extends StatelessWidget {
  const BalanceHeader(
      {Key? key,
      required this.balance,
      required this.onPayoutTap,
      required this.onBalanceHistoryTap})
      : super(key: key);

  final Balance balance;
  final Function onPayoutTap;
  final Function onBalanceHistoryTap;

  @override
  Widget build(BuildContext context) {
    final integerFormat = NumberFormat()..maximumFractionDigits = 0;
    final fractionFormat = NumberFormat()
      ..maximumFractionDigits = 0
      ..minimumIntegerDigits = 2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          LocaleKeys.balanceTitle.tr(),
          style: TextStyle(
            color: CashbackColors.mainTextColor,
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
        SizedBox(height: 6),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: integerFormat.format((balance.balance / 100).floor()),
                style: TextStyle(
                  color: CashbackColors.accentColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 38,
                ),
              ),
              TextSpan(
                text: "," +
                    fractionFormat.format(balance.balance % 100) +
                    " " +
                    LocaleKeys.balanceRubleSign.tr(),
                style: TextStyle(
                  color: CashbackColors.accentColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ],
          ),
        ),
        if (balance.balance > 0) ...{
          SizedBox(height: 24),
          Row(
            children: [
              Container(
                height: 44,
                decoration: BoxDecoration(
                  color: CashbackColors.backgroundColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => onPayoutTap(),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Image.asset('assets/images/payout_arrow.png'),
                          SizedBox(width: 10),
                          Text(
                            LocaleKeys.balancePayout.tr(),
                            style: TextStyle(
                              color: CashbackColors.accentColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        },
        Row(
          children: [
            TextButton(
              onPressed: () => onBalanceHistoryTap(),
              child: Text(
                LocaleKeys.balanceHistory.tr(),
                style: TextStyle(
                  color: CashbackColors.secondaryTextColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class PrescriptionsListItem extends StatelessWidget {
  const PrescriptionsListItem({Key? key, required this.prescription})
      : super(key: key);

  final Prescription prescription;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(
          left: 8,
          top: 24,
          right: 16,
          bottom: 16,
        ),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color:
                    prescription.flag ? CashbackColors.accentColor : Color(0),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            SizedBox(width: 4),
            Image.asset('assets/images/prescription_icon.png'),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    DateFormat('dd.MM.yyyy HH:mm')
                        .format(prescription.creationDate),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: CashbackColors.mainTextColor,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    prescription.reason ??
                        prescription.status.localizedDescription(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: prescription.reason != null
                          ? CashbackColors.errorTextColor
                          : CashbackColors.mainTextColor,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
