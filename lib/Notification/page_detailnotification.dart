


import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:moobi_flutter/Helper/check_connection.dart';
import 'package:moobi_flutter/Helper/color_based.dart';
import 'package:moobi_flutter/Helper/page_route.dart';
import 'package:moobi_flutter/Helper/session.dart';
import 'package:moobi_flutter/page_login.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:moobi_flutter/helper/api_link.dart';
import 'dart:convert';




class DetailNotification extends StatefulWidget{
  final String idNotif;
  final String judulNotif;
  const DetailNotification(this.idNotif, this.judulNotif);
  @override
  DetailNotificationState createState() => DetailNotificationState();
}


class DetailNotificationState extends State<DetailNotification> {
  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }


  String getEmail = '...';
  _session() async {
    int value = await Session.getValue();
    getEmail = await Session.getEmail();
    if (value != 1) {Navigator.pushReplacement(context, ExitPage(page: Login()));}
  }

  _connect() async {
    Checkconnection().check().then((internet){
      if (internet != null && internet) {} else {
        showToast("Koneksi terputus..", gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      }
    });
  }


  String getType = '...';
  String getTanggal = "2021-04-20 15:55:01";
  String getIsi = "...";
  _getDetail() async {
    final response = await http.get(applink+"api_model.php?act=getdetail_notifikasi&id="+widget.idNotif);
    Map data = jsonDecode(response.body);
    setState(() {
      getType = data["a"].toString();
      getTanggal = data["b"].toString();
      getIsi = data["c"].toString();
    });
  }


  void _nonaktifproduk() {
    var url = applink+"api_model.php?act=action_readnotif";
    http.post(url, body: {
          "id": widget.idNotif
        });
  }


  _prepare() async {
    await _connect();
    await _session();
    await _getDetail();
    _nonaktifproduk();
  }


  Future<bool> _onWillPop() async {
    Navigator.pop(context);
  }



  @override
  void initState() {
    super.initState();
    _prepare();
  }


  @override
  Widget build(BuildContext context) {
      return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          appBar: new AppBar(
            backgroundColor: HexColor(main_color),
            title: Text(
              getType.toString()+" Moobie",
              overflow: TextOverflow.ellipsis,
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
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(left: 15,right: 15,top: 15),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(widget.judulNotif,
                          style: TextStyle(fontFamily: "VarelaRound",
                              fontWeight: FontWeight.bold,
                              fontSize: 18,color: Colors.black)),
                    ),
                  ),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            Text(getType.toString(),
                                style: TextStyle(fontFamily: "OpenSans",
                                    fontSize: 13,color: HexColor("#a1a0a0"))),
                            Padding(padding: const EdgeInsets.only(left: 5,right: 5),
                              child: Icon(Icons.fiber_manual_record, color: Colors.grey, size: 7),),
                            Text(getTanggal.toString().substring(8,10)+"-"+getTanggal.toString().substring(5,7)+"-"+
                                getTanggal.toString().substring(0,4),
                                style: TextStyle(fontFamily: "VarelaRound",
                                    fontSize: 13,color: HexColor("#a1a0a0"))),
                          ],
                        )
                    ),
                  ),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child:   Divider(
                        height: 3,
                      ),
                    ),
                  ),


                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child:   Text(getIsi.toString(),
                          style: TextStyle(fontFamily: "OpenSans",
                              fontSize: 16,color: Colors.black,height: 1.7)),
                    ),
                  ),
                ],
              ),
            ),
          )
        ),
      );
  }
}