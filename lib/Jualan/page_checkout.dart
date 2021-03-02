


import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:moobi_flutter/Helper/check_connection.dart';
import 'package:moobi_flutter/Helper/page_route.dart';
import 'package:moobi_flutter/Helper/session.dart';
import 'package:moobi_flutter/page_login.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:moobi_flutter/helper/api_link.dart';

class Checkout extends StatefulWidget{
  @override
  CheckoutState createState() => CheckoutState();
}

class CheckoutState extends State<Checkout> {
  List data;
  bool _isvisible = true;
  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }


  String getEmail = '...';
  _session() async {
    int value = await Session.getValue();
    getEmail = await Session.getEmail();
    if (value != 1) {
      Navigator.pushReplacement(context, ExitPage(page: Login()));
    }
  }
  _connect() async {
    Checkconnection().check().then((internet){
      if (internet != null && internet) {
        // Internet Present Case
      } else {
        showToast("Koneksi terputus..", gravity: Toast.CENTER,
            duration: Toast.LENGTH_LONG);
      }
    });
  }

  String getBranchVal = '';
  String getNamaUser = '';
  _getBranch() async {
    final response = await http.get(
        applink+"api_model.php?act=userdetail&id="+getEmail.toString());
    Map data = jsonDecode(response.body);
    setState(() {
      getBranchVal = data["c"].toString();
      getNamaUser = data["j"].toString();
    });
  }


  String filter = "Semua";
  String filterq = "";
  String sortby = '0';
  Future<List> getData() async {
    http.Response response = await http.get(
        Uri.encodeFull(applink+"api_model.php?act=getdata_produkpending&id="+getBranchVal+"&filter="+filter
            +"&sort="+sortby+"&filterq="+filterq),
        headers: {"Accept":"application/json"}
    );
    setState((){
      data = json.decode(response.body);
    });
  }

  _prepare() async {
    await _connect();
    await _session();
    await _getBranch();
  }

  startSCreen() async {
    var duration = const Duration(seconds: 1);
    return Timer(duration, () {
      setState(() {
        _isvisible = true;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
      return WillPopScope(
        child: Scaffold(
          backgroundColor: HexColor("#ffffff"),
          appBar: new AppBar(
            elevation: 0.8,
            backgroundColor: HexColor("#ffffff"),
            leading: Builder(
              builder: (context) => IconButton(
                  icon: new Icon(Icons.arrow_back,size: 20,),
                  color: Colors.black,
                  onPressed: () => {
                    Navigator.pop(context)
                  }),
            ),
            title: Text(
              "Checkout",
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'VarelaRound',
                  fontSize: 16),
            ),
            actions: [
              InkWell(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  //alertSimpan();
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 27,top : 14),
                  child: FaIcon(
                      FontAwesomeIcons.check,color: Colors.black,
                  ),
                ),
              )
            ],
          ),
          body: Container(
            child: Column(
              children: [
                Padding(padding: const EdgeInsets.only(left: 0),
                child: Column(
                  children: [
                      Padding(padding: const EdgeInsets.only(left: 5,top: 5),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: FlatButton(
                          child: Text("Tambah Biaya",
                            style: TextStyle(
                                color: HexColor("#602d98"),
                                fontFamily: 'VarelaRound',
                                fontSize: 14,fontWeight: FontWeight.bold),),
                        ),
                      ),),
                    Padding(padding: const EdgeInsets.only(top:3),child: Divider(height: 3,),)
                  ],
                ),)
              ],
            ),
          ),
          bottomSheet: Container(
            width: double.infinity,
            height: 50,
            color: Colors.red,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("2000.000"),
              ),
            ),
          ),
        ),
      );

  }
}