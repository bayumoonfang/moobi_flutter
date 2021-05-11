


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:moobi_flutter/Helper/color_based.dart';
import 'package:moobi_flutter/Helper/page_route.dart';
import 'package:moobi_flutter/Setting/page_addmetodebayar.dart';
import 'package:moobi_flutter/Setting/page_legalentites.dart';
import 'package:toast/toast.dart';

class PaymentMethod extends StatefulWidget {

  @override
  PaymentMethodState createState() => PaymentMethodState();
}


class PaymentMethodState extends State<PaymentMethod> {
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
              "Metode Pembayaran",
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

          ),
          floatingActionButton:
          Padding(
            padding: const EdgeInsets.only(right : 10),
            child: FloatingActionButton(
              onPressed: (){
                Navigator.push(context, ExitPage(page: AddPaymentMethod()));
              },
              child: FaIcon(FontAwesomeIcons.plus),
            ),
          ),
        ),
     );
  }
}