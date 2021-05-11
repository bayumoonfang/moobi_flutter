

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:moobi_flutter/Helper/color_based.dart';
import 'package:toast/toast.dart';

class AddPaymentMethod extends StatefulWidget {

  @override
  AddPaymentMethodState createState() => AddPaymentMethodState();
}


class AddPaymentMethodState extends State<AddPaymentMethod> {
  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }

  Future<bool> _onWillPop() async {
    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
        return WillPopScope(
          onWillPop: _onWillPop,
           child: Scaffold(
             appBar: new AppBar(
               backgroundColor: HexColor(main_color),
               title: Text(
                 "Verifikasi Pembayaran",
                 style: TextStyle(
                     color: Colors.white, fontFamily: 'VarelaRound', fontSize: 16),
               ),
               leading: Builder(
                 builder: (context) => IconButton(
                     icon: new Icon(Icons.arrow_back),
                     color: Colors.white,
                     onPressed: () => {
                       Navigator.pop(context)
                     }),
               ),
             ),
             body: Container(
               padding: const EdgeInsets.only(left: 5,right: 5),

             ),
           ),
        );
  }
}