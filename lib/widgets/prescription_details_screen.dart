import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:med_cashback/constants/cashback_colors.dart';
import 'package:med_cashback/generated/lib/generated/locale_keys.g.dart';
import 'package:med_cashback/models/json_models.dart';
import 'package:med_cashback/network/auth_service.dart';
import 'package:med_cashback/network/prescriptions_service.dart';
import 'package:med_cashback/widgets/stateful_screen.dart';

class PrescriptionDetailsScreenArguments {
  final Prescription prescription;

  PrescriptionDetailsScreenArguments(this.prescription);
}

class PrescriptionDetailsScreen extends StatefulWidget {
  const PrescriptionDetailsScreen({Key? key, required this.arguments})
      : super(key: key);

  final PrescriptionDetailsScreenArguments arguments;

  @override
  _PrescriptionDetailsScreenState createState() =>
      _PrescriptionDetailsScreenState();
}

class _PrescriptionDetailsScreenState extends State<PrescriptionDetailsScreen> {
  StatefulScreenState _screenState = StatefulScreenState.loading;

  PrescriptionDetails? _prescriptionDetails;

  String? _authToken;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    _authToken = await AuthService.instance.authToken();
    setState(() {
      _screenState = StatefulScreenState.loading;
    });
    try {
      final details = await PrescriptionsService.instance
          .loadPrescriptionDetails(widget.arguments.prescription);
      await PrescriptionsService.instance
          .setFlag(widget.arguments.prescription);
      setState(() {
        _prescriptionDetails = details;
        _screenState = StatefulScreenState.content;
      });
    } catch (err) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(err.toString())));
      setState(() {
        _screenState = StatefulScreenState.error;
      });
    }
  }

  void _checkPrescription() async {
    setState(() {
      _screenState = StatefulScreenState.loading;
    });
  }

  @override
  Widget build(BuildContext context) {
    final prescription = widget.arguments.prescription;
    List<Widget> listChildren = [];

    if (_prescriptionDetails != null) {
      final details = _prescriptionDetails!;
      // TODO: Doesn't work correctly for large texts - need to investigate
      listChildren.add(
        Row(
          children: [
            Container(
              constraints: BoxConstraints(
                minHeight: 20,
              ),
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              // height: 20,
              alignment: AlignmentDirectional.center,
              decoration: BoxDecoration(
                color: details.statusColor(),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                details.cashbackReason ?? details.reason ?? details.status,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: CashbackColors.contrastTextColor,
                ),
              ),
            ),
          ],
        ),
      );

      if (details.photoIds != null && details.photoIds!.length > 0) {
        listChildren.add(GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          padding: EdgeInsets.symmetric(vertical: 16),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: details.photoIds!.length,
          itemBuilder: (context, index) => ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            child: Image.network(
              PrescriptionsService.instance.photoUrl(
                prescriptionId: prescription.id,
                photoId: details.photoIds![index],
              ),
              headers: {'Authorization': 'Bearer $_authToken'},
              color: CashbackColors.shadowColor,
              errorBuilder: (context, error, stackTrace) => Container(
                color: CashbackColors.shadowColor,
              ),
              loadingBuilder: (context, child, loadingProgress) => Container(
                color: CashbackColors.shadowColor,
              ),
            ),
          ),
        ));
      }

      if (details.specialty != null) {
        listChildren.add(PrescriptionDetailsItem(
          title: LocaleKeys.prescriptionDetailsSpecialty.tr(),
          values: [details.specialty!],
        ));
      }

      if (details.date != null) {
        listChildren.add(PrescriptionDetailsItem(
          title: LocaleKeys.prescriptionDetailsDate.tr(),
          values: [DateFormat('dd.MM.yyyy').format(details.date!)],
        ));
      }

      if (details.clinic != null) {
        listChildren.add(PrescriptionDetailsItem(
          title: LocaleKeys.prescriptionDetailsClinic.tr(),
          values: [details.clinic!],
        ));
      }

      if (details.diagnosis != null && details.diagnosis!.length > 0) {
        listChildren.add(PrescriptionDetailsItem(
          title: LocaleKeys.prescriptionDetailsDiagnosis.tr(),
          values: details.diagnosis!.map((e) => e.name).toList(),
        ));
      }

      if (details.drugs != null && details.drugs!.length > 0) {
        listChildren.add(PrescriptionDetailsItem(
          title: LocaleKeys.prescriptionDetailsDrugs.tr(),
          values: details.drugs!.map((e) => e.name).toList(),
        ));
      }

      if (details.needsCheck) {
        // listChildren.add(FilledButton(onPressed: onPressed, title: title))
      }
    }

    return Scaffold(
      appBar: AppBar(
        shadowColor: Color(0),
        title: Text(
          DateFormat('dd.MM.yyyy, HH:mm').format(prescription.creationDate),
        ),
      ),
      body: StatefulScreen(
        screenState: _screenState,
        onRepeat: _loadData,
        child: Container(
          color: CashbackColors.backgroundColor,
          child: ListView(
            padding: EdgeInsets.all(16),
            children: listChildren,
          ),
        ),
      ),
    );
  }
}

class PrescriptionDetailsItem extends StatelessWidget {
  const PrescriptionDetailsItem(
      {Key? key, required this.title, required this.values})
      : super(key: key);

  final String title;
  final List<String> values;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: CashbackColors.secondaryTextColor,
                ),
              ),
            ] +
            values
                .map(
                  (value) => Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      value,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: CashbackColors.mainTextColor,
                      ),
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }
}
