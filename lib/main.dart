// import 'package:chit_chat/firebase_options.dart';
import 'package:chit_chat/firebase_options.dart';
import 'package:chit_chat/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/auth/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  // this method call to firebase
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) {
    _initializefirebase();
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Chate kro",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          appBarTheme: AppBarTheme(
              centerTitle: true,
              backgroundColor: Colors.blue,
              titleTextStyle:
                  TextStyle(fontStyle: FontStyle.italic, fontSize: 24))),
      home: SplashScreen(),
    );
  }
}

_initializefirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
