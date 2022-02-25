



import 'dart:convert';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:moobi_flutter/Helper/api_link.dart';
import 'package:moobi_flutter/Helper/app_helper.dart';
import 'package:moobi_flutter/Helper/color_based.dart';
import 'package:moobi_flutter/Helper/page_route.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import '../page_intoduction.dart';
import '../page_login.dart';

class JualanHome extends StatefulWidget{
  final String getEmail;
  final String getLegalCode;
  final String getLegalId;
  final String getNamaUser;
  const JualanHome(this.getEmail, this.getLegalCode, this.getLegalId, this.getNamaUser);

  @override
  _JualanHome createState() => _JualanHome();
}


class _JualanHome extends State<JualanHome>{


  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }
  _cekLegalandUser() async {
    final response = await http.post(applink+"api_model.php?act=cek_legalanduser",
        body: {"username": widget.getEmail.toString()},
        headers: {"Accept":"application/json"});
    Map data = jsonDecode(response.body);
    setState(() {
      if (data["message"].toString() == '2' || data["message"].toString() == '3') {
        Navigator.pushReplacement(context, ExitPage(page: Introduction()));
      }
    });
  }

  String getTokoDefault = "...";
  String getStore_Id = "...";
  _tokoDefault() async {
    final response = await http.get(
        applink+"api_model.php?act=gettoko_default&id="+widget.getEmail);
    Map data = jsonDecode(response.body);
    setState(() {
      getTokoDefault = data["store_nama"].toString();
      getStore_Id = data["store_id"].toString();
    });
  }

  String getGudangDefault = "...";
  String getGudang_Id = "...";
  _gudangDefault() async {
    final response = await http.get(
        applink+"api_model.php?act=getgudang_default&id="+getStore_Id.toString());
    Map data = jsonDecode(response.body);
    setState(() {
      print(
          applink+"api_model.php?act=getgudang_default&id="+getStore_Id.toString());
      getGudangDefault = data["gudang_nama"].toString();
      getGudang_Id = data["gudang_id"].toString();
    });
  }


  //=============================================================================
  _startingVariable() async {
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      showToast("Koneksi terputus..", gravity: Toast.CENTER,duration:
      Toast.LENGTH_LONG);}});
    await AppHelper().getSession().then((value){
      if(value[0] != 1) {
        Navigator.pushReplacement(context, ExitPage(page: Login()));
      }
    });
    await _cekLegalandUser();
    await _tokoDefault();
    await _gudangDefault();

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

  Future<bool> _onWillPop() async {
    Navigator.pop(context);}



  _prepare() async {
    await _startingVariable();
  }

  @override
  void initState() {
    super.initState();
    _prepare();
  }



  @override
  Widget build(BuildContext context) {
      return WillPopScope(
          child: Scaffold(
            appBar: new AppBar(
              backgroundColor: HexColor("#602d98"),
              title: Text(
                "Mulai Jualan",
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
              width: double.infinity,
              height: double.infinity,
              child: Column(
                children: [
                  Padding(padding: const EdgeInsets.only(top:35,left: 25,right: 25),
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween,
                      children: [
                        Text(
                          "PENGATURAN",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontFamily: 'VarelaRound',
                              color: HexColor("#73767d"),
                              fontWeight: FontWeight.bold,
                              fontSize: 13),
                        ),
                      ],
                    ),),

                  Padding(padding: const EdgeInsets.only(top: 25,left: 9,right: 25),
                      child: InkWell(
                        child: ListTile(
                          onTap: (){
                           // Navigator.push(context,MaterialPageRoute(builder: (context) => OutletChangeGudang(widget.getEmail,widget.getLegalCode,widget.idOutlet))).then(onGoBack);
                            // Navigator.push(context, ExitPage(page: OutletChangeGudang(widget.getEmail,widget.getLegalCode,widget.idOutlet))).then(onGoBack);
                          },
                          title: Column(
                            children: [
                              Align(alignment: Alignment.centerLeft,
                                child: Text("Toko yang digunakan", style: TextStyle(color: HexColor("#72757a"),
                                  fontFamily: 'VarelaRound',fontSize: 11,)),),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  padding: const EdgeInsets.only(top:5 ),
                                  height: 25,
                                  child: Align(alignment: Alignment.centerLeft,
                                      child: Text(getTokoDefault, style: TextStyle(
                                        fontFamily: 'VarelaRound',
                                        fontSize: 15,fontWeight: FontWeight.bold)))
                                ),
                              )
                            ],
                          ),
                          trailing: FaIcon(FontAwesomeIcons.angleRight,color: HexColor(third_color),size: 23,),
                        ),
                      )
                  ),
                  Padding(padding: const EdgeInsets.only(top: 5,left: 25,right: 25),
                    child: Divider(height: 3,),),

                  Padding(padding: const EdgeInsets.only(top: 25,left: 9,right: 25),
                      child: InkWell(
                        child: ListTile(
                          onTap: (){
                            // Navigator.push(context,MaterialPageRoute(builder: (context) => OutletChangeGudang(widget.getEmail,widget.getLegalCode,widget.idOutlet))).then(onGoBack);
                            // Navigator.push(context, ExitPage(page: OutletChangeGudang(widget.getEmail,widget.getLegalCode,widget.idOutlet))).then(onGoBack);
                          },
                          title: Column(
                            children: [
                              Align(alignment: Alignment.centerLeft,
                                child: Text("Gudang yang digunakan", style: TextStyle(color: HexColor("#72757a"),
                                  fontFamily: 'VarelaRound',fontSize: 11,)),),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                    padding: const EdgeInsets.only(top:5 ),
                                    height: 25,
                                    child: Align(alignment: Alignment.centerLeft,
                                        child: Text(getGudangDefault, style: TextStyle(
                                            fontFamily: 'VarelaRound',
                                            fontSize: 15,fontWeight: FontWeight.bold)))
                                ),
                              )
                            ],
                          ),
                          trailing: FaIcon(FontAwesomeIcons.angleRight,color: HexColor(third_color),size: 23,),
                        ),
                      )
                  ),
                ],
              ),
            ),
          ),
          onWillPop: _onWillPop
      );
  }
}