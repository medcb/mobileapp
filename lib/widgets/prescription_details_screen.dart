import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:med_cashback/models/json_models.dart';
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

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
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

  @override
  Widget build(BuildContext context) {
    final prescription = widget.arguments.prescription;
    return Scaffold(
      appBar: AppBar(
        shadowColor: Color(0),
        title: Text(
          DateFormat('dd.MM.yyyy HH:mm').format(prescription.creationDate),
        ),
      ),
      body: StatefulScreen(
        screenState: _screenState,
        onRepeat: _loadData,
        child: Container(),
      ),
    );
  }
}
