import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:med_cashback/constants/cashback_colors.dart';
import 'package:med_cashback/constants/route_name.dart';
import 'package:med_cashback/generated/lib/generated/locale_keys.g.dart';
import 'package:med_cashback/models/json_models.dart';
import 'package:med_cashback/network/prescriptions_service.dart';
import 'package:med_cashback/widgets/components/filled_button.dart';
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

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  var _listenPrescriptionsServiceChange;
  List<Prescription> _prescriptions = [];

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
    await PrescriptionsService.instance.reloadPrescriptions();
  }

  void _prescriptionsStateChanged() {
    print('_prescriptionsStateChanged');
    if (!mounted) return;
    print('mounted ${PrescriptionsService.instance.state}');
    if (_screenState == StatefulScreenState.content &&
        PrescriptionsService.instance.state ==
            PrescriptionsServiceLoadState.loading) {
      // update by RefreshIndicator
      return;
    }
    SchedulerBinding.instance!.addPostFrameCallback((_) {
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
          itemBuilder: (context, index) => GestureDetector(
            onTap: () => _openPrescription(_prescriptions[index]),
            child: PrescriptionsListItem(prescription: _prescriptions[index]),
          ),
          separatorBuilder: (ctx, index) => Container(
            color: CashbackColors.shadowColor,
            height: 1,
          ),
          itemCount: _prescriptions.length,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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

class PrescriptionsListItem extends StatelessWidget {
  const PrescriptionsListItem({Key? key, required this.prescription})
      : super(key: key);

  final Prescription prescription;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CashbackColors.backgroundColor,
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
                    prescription.reason ?? prescription.status,
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
