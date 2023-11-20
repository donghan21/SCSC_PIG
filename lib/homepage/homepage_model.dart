import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import '/utils/model_utils.dart';

class HomePageModel extends Model {
  final unFocusNode = FocusNode();
  int data = 1;

  @override
  void initState(BuildContext context) {

  }

  @override
  void dispose() {
    unFocusNode.dispose();
  }

}