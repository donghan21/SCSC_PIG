import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import '/utils/model_utils.dart';

class NavigationBarModel extends Model {
  final unFocusNode = FocusNode();

  @override
  void initState(BuildContext context) {

  }

  @override
  void dispose() {
    unFocusNode.dispose();
  }

}