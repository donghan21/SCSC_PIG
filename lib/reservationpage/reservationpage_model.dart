import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import '/utils/model_utils.dart';

class ReservationPageModel extends Model {
  final unFocusNode = FocusNode();

  DateTime? selectedDay = DateTime.now();
  TextEditingController? reasonController;

  @override

  void initState(BuildContext context) {
  }

  @override
  void dispose() {
    unFocusNode.dispose();
    reasonController?.dispose();
  }
}
