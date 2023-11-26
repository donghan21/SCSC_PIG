import 'package:flutter/material.dart';
import '/utils/model_utils.dart';

class SignUpPageModel extends Model {
  final unFocusNode = FocusNode();

  TextEditingController? emailController = TextEditingController();
  TextEditingController? passwordController = TextEditingController();
  TextEditingController? passwordCheckController = TextEditingController();
  TextEditingController? quizController = TextEditingController();

  @override
  void initState(BuildContext context) {

  }

  @override
  void dispose() {
    unFocusNode.dispose();
    emailController!.dispose();
    passwordController!.dispose();
    quizController!.dispose();
  }

}