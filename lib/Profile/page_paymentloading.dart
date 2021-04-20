



import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moobi_flutter/Helper/page_route.dart';
import 'package:moobi_flutter/page_home.dart';

class PaymentLoading extends StatefulWidget{

  @override
  PaymentLoadingState createState() => PaymentLoadingState();
}


class PaymentLoadingState extends State<PaymentLoading> {
  Future<bool> _onWillPop() async {
    //Toast.show("Toast plugin app", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
  }


  @override
  void initState() {
    super.initState();
    startSplashScreen();
  }

  startSplashScreen() async {
    var duration = const Duration(seconds: 5);
    return Timer(duration, () {
      Navigator.pushReplacement(context, ExitPage(page: Home()));
    });
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
            child:            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    width: 50, height: 50, child: CircularProgressIndicator()),
                Padding(padding: const EdgeInsets.all(25.0)),
                Text(
                  "Memproses pembayaran anda, jangan menutup aplikasi ini ...",
                  style: TextStyle(fontFamily: 'VarelaRound', fontSize: 13),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:5),
                  child:
                  Text(
                    "Mohon menunggu sebentar",
                    style: TextStyle(fontFamily: 'VarelaRound', fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            )
          ),
      ),
    );
  }
}