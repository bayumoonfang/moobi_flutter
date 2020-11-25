



import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {


  startSplash() async {
    var duration = const Duration(seconds: 2);
    return Timer(duration,(){
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) {
            //return Home();
            //return DokterSearch();
          }),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset("assets/c.png",width: 200,height: 100,),
      ),
    );
  }


}