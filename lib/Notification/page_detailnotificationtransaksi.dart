


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
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
      noNoTrans = data["d"].toString();
      getTanggal = data["b"].toString();
    });
  }


  String getIsi = "...";
  String getAmount = "...";
  _getDetailInvoice() async {
    final response = await http.get(applink+"api_model.php?act=getdetail_notifikasitransaksi&id="+noNoTrans.toString());
    Map data2 = jsonDecode(response.body);
    setState(() {
      getAmount = data2["b"].toString();
      getIsi = data2["c"].toString();
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
    await _getDetailInvoice();
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
          centerTitle: true,
          elevation: 0,
          backgroundColor: HexColor("#f8f8f8"),
          title: Image.asset("assets/logo2.png",width: 100,),
          leading: Builder(
            builder: (context) => IconButton(
                icon: new Icon(Icons.arrow_back),
                color: HexColor("#6c767f"),
                onPressed: () => {
                  Navigator.pop(context)
                }),
          ),
        ),
        body: Container(
          color: Colors.white,
          child: Container(
            width: double.infinity,
            color: HexColor("#f8f8f8"),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Column(
                  children: [
               Text( "Rp. "+
                NumberFormat.currency(
                    locale: 'id', decimalDigits: 0, symbol: '').format(
                    int.parse(getAmount.toString())),
                  style: TextStyle(fontFamily: "VarelaRound",
                  fontWeight: FontWeight.bold,
                  fontSize: 32,color: HexColor("#72bd00"))),
                    Text(getAmount.toString())
                  ],
                ),
              )
            ),
          ),
        ),
      ),
    );

  }
}