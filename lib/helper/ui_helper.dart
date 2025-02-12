import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UIHelper{
  static void setDefaultUIStyle() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.blue, // Change as needed
      systemNavigationBarColor: Colors.white, // Change as needed
      systemNavigationBarIconBrightness: Brightness.dark, // Light or Dark icons
      statusBarIconBrightness: Brightness.light, // Light or Dark status bar icons
    ));
  }
}
