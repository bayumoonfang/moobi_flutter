import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:moobi_flutter/SplashScreen.dart';
import 'package:moobi_flutter/page_home.dart';
import 'package:moobi_flutter/page_index.dart';
import 'package:moobi_flutter/page_intoduction.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(),
      builder: EasyLoading.init(),
      //home : Login()
    );
  }
}