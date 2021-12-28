import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:med_cashback/constants/cashback_colors.dart';
import 'package:med_cashback/generated/lib/generated/locale_keys.g.dart';
import 'package:med_cashback/models/json_models.dart';
import 'package:med_cashback/network/balance_service.dart';
import 'package:med_cashback/widgets/components/filled_button.dart';
import 'package:med_cashback/widgets/payout_type_select.dart';
import 'package:med_cashback/widgets/stateful_screen.dart';

class BalanceHistoryScreenArguments {
  final Balance balance;
  final Function(Balance) onBalanceUpdated;

  BalanceHistoryScreenArguments(
      {required this.balance, required this.onBalanceUpdated});
}

class BalanceHistoryScreen extends StatefulWidget {
  const BalanceHistoryScreen({Key? key, required this.arguments})
      : super(key: key);

  final BalanceHistoryScreenArguments arguments;

  @override
  _BalanceHistoryScreenState createState() => _BalanceHistoryScreenState();
}

class _BalanceHistoryScreenState extends State<BalanceHistoryScreen> {
  late Balance _balance;
  StatefulScreenState _screenState = StatefulScreenState.content;
  String _errorText = '';
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _balance = widget.arguments.balance;
    if (_balance.history.isEmpty) {
      _screenState = StatefulScreenState.empty;
    } else {
      _screenState = StatefulScreenState.content;
    }
  }

  Future<void> _reloadBalance() async {
    if (_screenState == StatefulScreenState.error ||
        _screenState == StatefulScreenState.empty) {
      setState(() {
        _screenState = StatefulScreenState.loading;
      });
    }
    try {
      _balance = await BalanceService().loadBalance();
      widget.arguments.onBalanceUpdated(_balance);
      if (!mounted) return;
      setState(() {
        if (_balance.history.isEmpty) {
          _screenState = StatefulScreenState.empty;
        } else {
          _screenState = StatefulScreenState.content;
        }
      });
    } catch (err) {
      if (!mounted) return;
      setState(() {
        _errorText = err.toString();
        _screenState = StatefulScreenState.error;
      });
    }
  }

  void _onBalanceUpdated(Balance newBalance) {
    setState(() {
      _balance = newBalance;
    });
    widget.arguments.onBalanceUpdated(newBalance);
  }

  void _openPayout() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Color(0),
      builder: (context) => PayoutTypeSelect(
        balance: _balance,
        onBalanceUpdated: _onBalanceUpdated,
      ),
    );
  }

  Widget _balanceHeader() {
    NumberFormat format = NumberFormat.currency(symbol: '₽');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            LocaleKeys.balanceHistoryTitle.tr(),
            style: TextStyle(
              color: CashbackColors.mainTextColor,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
        ),
        Container(
          color: CashbackColors.buttonSecondaryBackgroundColor,
          padding: EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  LocaleKeys.balanceHistoryBalanceTitle.tr(),
                  style: TextStyle(
                    color: CashbackColors.mainTextColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                  ),
                ),
              ),
              Text(
                format.format(_balance.balance.toDouble() / 100),
                style: TextStyle(
                  color: CashbackColors.mainTextColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Color(0),
        backgroundColor: CashbackColors.backgroundColor,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Image.asset('assets/images/back_gray_icon.png'),
        ),
      ),
      body: StatefulScreen(
        screenState: _screenState,
        errorText: _errorText,
        onRepeat: _reloadBalance,
        child: Container(
          color: CashbackColors.backgroundColor,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _balanceHeader(),
                Expanded(
                  child: RefreshIndicator(
                    key: _refreshIndicatorKey,
                    onRefresh: _reloadBalance,
                    child: ListView.separated(
                      itemCount: _balance.history.length,
                      separatorBuilder: (context, index) => Container(
                        color: CashbackColors.shadowColor,
                        height: 1,
                      ),
                      itemBuilder: (context, index) => BalanceHistoryItemCell(
                          historyItem: _balance.history[index]),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: FilledButton(
                    onPressed: _openPayout,
                    title: LocaleKeys.balancePayout.tr(),
                    icon: Image.asset(
                      'assets/images/payout_arrow.png',
                      color: CashbackColors.contrastTextColor,
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

class BalanceHistoryItemCell extends StatelessWidget {
  const BalanceHistoryItemCell({Key? key, required this.historyItem})
      : super(key: key);

  final BalanceHistoryItem historyItem;

  @override
  Widget build(BuildContext context) {
    NumberFormat format = NumberFormat.currency(symbol: '₽');

    String _destinationString() {
      switch (historyItem.type) {
        case BalanceHistoryItemType.self:
          return '';
        case BalanceHistoryItemType.phone:
          return LocaleKeys.balanceHistoryTypeFormatPhone
              .tr(args: [historyItem.destination ?? '']);
        case BalanceHistoryItemType.wallet:
          return LocaleKeys.balanceHistoryTypeFormatWallet
              .tr(args: [historyItem.destination ?? '']);
      }
    }

    String _statusText() {
      if (historyItem.status == null) {
        return LocaleKeys.balanceHistoryStatusInProgress.tr();
      } else if (historyItem.status!) {
        return LocaleKeys.balanceHistoryStatusCompleted.tr();
      } else {
        return LocaleKeys.balanceHistoryStatusFailed.tr();
      }
    }

    Color _statusColor() {
      if (historyItem.status == null) {
        return CashbackColors.secondaryTextColor;
      } else if (historyItem.status!) {
        return CashbackColors.prescriptionStatusSentColor;
      } else {
        return CashbackColors.prescriptionStatusDeclinedColor;
      }
    }

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  DateFormat('dd.MM.yyyy, HH:mm').format(historyItem.date),
                  style: TextStyle(
                    color: CashbackColors.mainTextColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                  ),
                ),
              ),
              Text(
                (historyItem.amount > 0 ? '+' : '') +
                    format.format(historyItem.amount.toDouble().abs() / 100),
                style: TextStyle(
                  color: CashbackColors.mainTextColor,
                  fontWeight: historyItem.amount > 0
                      ? FontWeight.w500
                      : FontWeight.w400,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          if (historyItem.type != BalanceHistoryItemType.self) ...{
            SizedBox(height: 8),
            Text(
              _destinationString(),
              style: TextStyle(
                color: CashbackColors.secondaryTextColor,
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 16),
            Text(
              _statusText(),
              style: TextStyle(
                color: _statusColor(),
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
          },
        ],
      ),
    );
  }
}
