import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:moobi_flutter/helper/page_route.dart';
import 'package:moobi_flutter/page_index.dart';
import 'package:moobi_flutter/page_login.dart';

class SuksesRegister extends StatefulWidget {
  final String email;
  const SuksesRegister(this.email);

  @override
  _SuksesRegisterState createState() => _SuksesRegisterState();
}


class _SuksesRegisterState extends State<SuksesRegister> {

  Future<bool> _onWillPop() async {
    //Toast.show("Toast plugin app", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: _onWillPop,
      child : Scaffold(
        body: (
            Container(
                   height: double.infinity,
                   width: double.infinity,
                  child:
                  Center(
        child :
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(padding: const EdgeInsets.all(25.0)),
                      Text(
                        "Terima Kasih",
                        style: TextStyle(fontFamily: 'VarelaRound', fontSize: 23),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top:2,left: 15,right: 15),
                        child:
                            Align (
                              alignment: Alignment.topCenter,
                                  child :
                                  Text(
                                    "Sudah mendaftar sebagai pengguna aplikasi moobie.",
                                    style: TextStyle(fontFamily: 'VarelaRound', fontSize: 13,),textAlign: TextAlign.center,
                                  )),
                      ),
            Padding(padding: const EdgeInsets.only(top:10),
                child: RaisedButton(
              color:  HexColor("#602d98"),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
                //side: BorderSide(color: Colors.red, width: 2.0)
              ),
              child: Text(
                "Login ke Akun Anda",
                style: TextStyle(
                    fontFamily: 'VarelaRound',
                    fontSize: 14,
                    color: Colors.white
                ),
              ),
              onPressed: (){
                Navigator.push(context, ExitPage(page: Login()));
              },
            ),)

                    ],
                  ))
            )
        ),
      )
    );
  }
}