import 'package:flutter/material.dart';
import 'package:scscpig/utils/model_utils.dart';

class UserInfoModel extends Model {
  final unFocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unFocusNode.dispose();
  }
}
