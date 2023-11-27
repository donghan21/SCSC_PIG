import 'package:fluttertoast/fluttertoast.dart';

import 'signuppage_model.dart';
export 'signuppage_model.dart';

import '/utils/model_utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpPageWidget extends StatefulWidget {
  const SignUpPageWidget({super.key});

  @override
  State<SignUpPageWidget> createState() => _SignUpPageWidgetState();
}

class _SignUpPageWidgetState extends State<SignUpPageWidget> {
  late double H;
  late double W;
  late SignUpPageModel _model;
  bool signUpResult = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SignUpPageModel());
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  bool checkControllers() {
    if(_model.emailController!.text == '' || _model.passwordController!.text == '' || _model.passwordCheckController!.text == '' || _model.quizController!.text == '') {
      Fluttertoast.showToast(msg: '모든 항목을 입력해주세요.');
      return false;
    }
    else if(_model.passwordController!.text != _model.passwordCheckController!.text) {
      Fluttertoast.showToast(msg: '비밀번호와 비밀번호 확인이 일치하지 않습니다.');
      return false;
    }
    else if(_model.passwordController!.text.length < 6) {
      Fluttertoast.showToast(msg: '비밀번호는 6자리 이상이어야 합니다.');
      return false;
    }
    else if(!(_model.quizController!.text == '이찬양')) {
      Fluttertoast.showToast(msg: 'SCSC 부원이 아니신가요?');
      return false;
    }
    else {
      return true;
    }
  }

  Future<bool> signUp() async {

    if(!checkControllers()) {
      return false;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _model.emailController!.text, password: _model.passwordController!.text);
      Fluttertoast.showToast(msg: '회원가입에 성공했습니다.');
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(msg: '비밀번호가 너무 약합니다.');
        return false;
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(msg: '이미 사용중인 이메일입니다.');
        return false;
      } else if(e.code == 'invalid-email') {
        Fluttertoast.showToast(msg: '이메일 형식이 올바르지 않습니다.');
        return false;
      }
      else {
        Fluttertoast.showToast(msg: '회원가입에 실패했습니다.');
        debugPrint(e.code.toString());
        return false;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: '회원가입에 실패했습니다.');
      debugPrint(e.toString());
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    H = MediaQuery.of(context).size.height;
    W = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: H * 0.15),
                SizedBox(
                  height: H * 0.1,
                  width: W * 0.8,
                  child: TextField(
                    controller: _model.emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '이메일',
                    ),
                  ),
                ),
                SizedBox(height: H * 0.05),
                SizedBox(
                  height: H * 0.1,
                  width: W * 0.8,
                  child: TextField(
                    controller: _model.passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '비밀번호',
                        hintText: '6자리 이상'),
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp('[ㄱ-ㅎㅏ-ㅣ가-힣]')),
                    ],
                  ),
                ),
                SizedBox(height: H * 0.02),
                SizedBox(
                  height: H * 0.1,
                  width: W * 0.8,
                  child: TextField(
                    controller: _model.passwordCheckController,
                    obscureText: true,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: '비밀번호 확인'),
                  ),
                ),
                SizedBox(height: H * 0.07),
                SizedBox(
                  height: H * 0.1,
                  width: W * 0.8,
                  child: TextField(
                    controller: _model.quizController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: 'SCSC 회장님의 존함은? (동아리원 확인용)'),
                  ),
                ),
                SizedBox(height: H * 0.1),
               ElevatedButton(
                  onPressed: () async {
                    signUpResult = await signUp();
                    if(signUpResult) {
                      Navigator.pop(context);
                    }
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                      minimumSize: MaterialStateProperty.all<Size>(
                          Size(W * 0.8, H * 0.07))),
                  child: const Text(
                    '회원가입',
                    style: TextStyle(fontSize: 20, color: Colors.white),
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
