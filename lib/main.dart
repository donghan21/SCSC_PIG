import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:scscpig/homepage/homepage_widget.dart';
import 'utils/firebase_options.dart';
import 'index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/' : (context) => const LoginPageWidget(),
        '/signup' : (context) => const SignUpPageWidget(),
        '/homepage' : (context) => const HomePageWidget(),        
      }
    );
  }
}
