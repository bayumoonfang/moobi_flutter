





import 'dart:convert';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:moobi_flutter/page_resetpin.dart';
import 'Helper/api_link.dart';
import 'Helper/color_based.dart';
import 'Helper/setting_apps.dart';

class ResetPinToken extends StatefulWidget {

  @override
  _ResetPinToken createState() => _ResetPinToken();

}



class _ResetPinToken extends State<ResetPinToken> {
  TextEditingController val_email = TextEditingController();

  Future<bool> _onWillPop() async {
    //Navigator.pop(context);
  }


  @override
  void initState() {
    super.initState();
    val_email.clear();
  }


  showFlushBarsuccess(BuildContext context, String stringme) => Flushbar(
    // title:  "Hey Ninja",
    message:  stringme,
    shouldIconPulse: false,
    duration:  Duration(seconds: 3),
    backgroundColor: Colors.black,
    flushbarPosition: FlushbarPosition.BOTTOM ,
  )..show(context);

  void showsuccess(String txtError){
    showFlushBarsuccess(context, txtError);
    return;
  }



  doVerifikasi() async {
    EasyLoading.show(status: easyloading_text);
    //FocusScope.of(context).requestFocus(FocusNode());
    //Navigator.pop(context);
    if(val_email.text == '') {
      EasyLoading.dismiss();
      showsuccess("Form tidak boleh kosong");
      return false;
    }

    final response = await http.post(applink+"api_model.php?act=resetpin_cekemail", body: {
      "val_email": val_email.text
    });
    Map data = jsonDecode(response.body);
    setState(() {
      if (data["message"].toString() == '0') {
        showsuccess("Email tidak ditemukan");
        return false;
      } else {
        showsuccess("Tax berhasil diedit");
        return false;
      }
    });
  }



  deleteToken() async {
    FocusScope.of(context).requestFocus(FocusNode());
    EasyLoading.show(status: easyloading_text);

    final response = await http.post(applink+"api_model.php?act=resetpin_delete", body: {
      "val_email": val_email.text
    });
    Map data = jsonDecode(response.body);
    setState(() {
      EasyLoading.dismiss();
      FocusScope.of(context).requestFocus(FocusNode());
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ResetPin()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child : Scaffold(
          body: Container(
            height: double.infinity,
            width: double.infinity,
            padding: const EdgeInsets.only(left: 25,right: 35),
            child: SingleChildScrollView(
                child : Column(
                  children: [

                    Padding(
                      padding: const EdgeInsets.only(top: 60,left: 7),
                      child : Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                              onTap: (){
                                deleteToken();
                              },
                              child : FaIcon(FontAwesome5.times, size: 26,)
                          )
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 60,left: 7),
                      child : Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Token Verification",style : GoogleFonts.varelaRound(fontSize: 24,fontWeight: FontWeight.bold))
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5,left: 7),
                      child : Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Silahkan masukkan token yang sudah dikirimkan ke email anda.",style : GoogleFonts.varelaRound(fontSize: 14))
                      ),
                    ),


                    Padding(padding: const EdgeInsets.only(left: 15,top: 50,right: 15),
                        child: Column(
                          children: [
                            Align(alignment: Alignment.centerLeft,child: Padding(
                              padding: const EdgeInsets.only(left: 0,top: 15),
                              child: Text("Token",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "VarelaRound",
                                  fontSize: 12,color: HexColor("#0074D9")),),
                            ),),
                            Align(alignment: Alignment.centerLeft,child: Padding(
                              padding: const EdgeInsets.only(left: 0),
                              child: TextFormField(
                                controller: val_email,
                                maxLength: 6,
                                style: TextStyle(fontSize: 34),
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(top:2),
                                  labelText: '',
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  hintStyle: TextStyle(fontFamily: "VarelaRound", color: HexColor("#c4c4c4"),),
                                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: HexColor("#DDDDDD")),),
                                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: HexColor("#8c8989")),),
                                  border: UnderlineInputBorder(borderSide: BorderSide(color: HexColor("#DDDDDD")),),
                                ),
                              ),
                            ),),
                          ],
                        )
                    ),




                    Padding(padding: const EdgeInsets.only(left: 15,right: 15,top: 60),child:
                    Container(
                        height: 50,
                        width: double.infinity,
                        child :
                        OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(width: 1, color: Colors.black),
                            ),
                            child: Text(
                              "Send Email Verification",
                              style: TextStyle(
                                  fontFamily: 'VarelaRound',
                                  fontSize: 14,
                                  color: Colors.black
                              ),
                            ),
                            onPressed: () {
                              doVerifikasi();
                            }
                        )
                    )
                    ),





                  ],
                )
            ),
          ),
        )

    );


  }
}