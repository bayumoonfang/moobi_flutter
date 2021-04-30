


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
import 'dart:async';


class DetailNotifikasiTransaksi extends StatefulWidget {
  final String idNotif;
  final String judulNotif;
  const DetailNotifikasiTransaksi(this.idNotif, this.judulNotif);
  @override
  DetailNotifikasiTransaksiState createState() => DetailNotifikasiTransaksiState();
}


class DetailNotifikasiTransaksiState extends State<DetailNotifikasiTransaksi> {
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
  Future<bool> _onWillPop() async {
    Navigator.pop(context);
  }

  String noNoTrans = '...';
  String getTanggal = "2021-04-20 15:55:01";
  String getType = "...";
  _getDetail() async {
    final response = await http.get(applink+"api_model.php?act=getdetail_notifikasi&id="+widget.idNotif);
    Map data = jsonDecode(response.body);
    setState(() {
      noNoTrans = data["a"].toString();
      getTanggal = data["b"].toString();
    });
  }


  String getIsi = "...";
  _getDetailInvoice() async {
    final response = await http.get(applink+"api_model.php?act=getdetail_notifikasitransaksi&id="+noNoTrans.toString());
    Map data = jsonDecode(response.body);
    setState(() {
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
      ),
    );

  }
}