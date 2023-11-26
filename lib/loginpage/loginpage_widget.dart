import 'loginpage_model.dart';
export 'loginpage_model.dart';


import '/utils/model_utils.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPageWidget extends StatefulWidget {
  const LoginPageWidget({super.key});

  @override
  State<LoginPageWidget> createState() => _LoginPageWidgetState();
}

class _LoginPageWidgetState extends State<LoginPageWidget> {
  late LoginPageModel _model;
  late double H;
  late double W;
  bool signInResult = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoginPageModel());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  bool checkControllers() {
    if (_model.emailController!.text == '' ||
        _model.passwordController!.text == '') {
      Fluttertoast.showToast(msg: '모든 항목을 입력해주세요.');
      return false;
    } else {
      return true;
    }
  }

  Future<bool> signIn() async {
    if (!checkControllers()) {
      return false;
    }
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _model.emailController!.text,
          password: _model.passwordController!.text);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(msg: '존재하지 않는 이메일입니다.');
        return false;
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(msg: '비밀번호가 틀렸습니다.');
        return false;
      }
      Fluttertoast.showToast(msg: '로그인에 실패했습니다.');
      debugPrint('error: $e');
      return false;
    } catch (e) {
      Fluttertoast.showToast(msg: '로그인에 실패했습니다.');
      debugPrint('error: $e');
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: H * 0.1),
                SizedBox(
                    height: H * 0.1,
                    width: W * 0.7,
                    child: const Center(
                        child: Text(
                      'Login',
                      style: TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold),
                    ),),),
                SizedBox(
                  height: H * 0.2,
                ),
                Container(
                    height: H * 0.07,
                    width: W * 0.82,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    child: Row(
                      children: [
                        Container(
                            height: H * 0.07,
                            width: W * 0.15,
                            color: Colors.grey,
                            child: const Center(child: Icon(Icons.email))),
                        SizedBox(
                            height: H * 0.07,
                            width: W * 0.65,
                            child: TextField(
                              controller: _model.emailController,
                              decoration: const InputDecoration(
                                  hintText: '  이메일',
                                  border: InputBorder.none),
                            )),
                      ],
                    )),
                SizedBox(height: H * 0.02),
                Container(
                    height: H * 0.07,
                    width: W * 0.82,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    child: Row(
                      children: [
                        Container(
                            height: H * 0.07,
                            width: W * 0.15,
                            color: Colors.grey,
                            child: const Center(child: Icon(Icons.lock))),
                        SizedBox(
                            height: H * 0.07,
                            width: W * 0.65,
                            child: TextField(
                              controller: _model.passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                  hintText: '  비밀번호',
                                  border: InputBorder.none),
                            )),
                      ],
                    )),
                SizedBox(height: H * 0.1),
                ElevatedButton(
                  onPressed: () async {
                    signInResult = await signIn();
                    if(signInResult) {
                      Navigator.pushReplacementNamed(context, '/homepage');
                    }
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                      minimumSize: MaterialStateProperty.all<Size>(
                          Size(W * 0.8, H * 0.07))),
                  child: const Text(
                    '로그인',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                SizedBox(height: H * 0.15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('아직 회원이 아니신가요?'),
                    TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                        child: const Text(
                          '회원가입',
                          style: TextStyle(color: Colors.blue),
                        ))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
