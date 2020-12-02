


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moobi_flutter/helper/check_connection.dart';
import 'package:moobi_flutter/helper/page_route.dart';
import 'package:moobi_flutter/helper/session.dart';
import 'package:moobi_flutter/page_login.dart';
import 'package:toast/toast.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;


class DetailProduk extends StatefulWidget {
  final String idItem;

  const DetailProduk(this.idItem);
  @override
  _DetailProdukState createState() => _DetailProdukState();
}


class _DetailProdukState extends State<DetailProduk> {
  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }


  String getEmail,getUsername = '';
  _session() async {
    int value = await Session.getValue();
    getEmail = await Session.getEmail();
    getUsername = await Session.getUsername();
    if (value != 1) {
      Navigator.push(context, ExitPage(page: Login()));
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
  _getBranch() async {
    final response = await http.get(
        "https://duakata-dev.com/moobi/m-moobi/api_model.php?act=userdetail&id="+getUsername);
    Map data = jsonDecode(response.body);
    setState(() {
      getBranchVal = data["c"].toString();
    });
  }


  //String getBranchVal = '';
  _getDetail() async {
    final response = await http.get(
        "https://duakata-dev.com/moobi/m-moobi/api_model.php?act=item_detail&id="+widget.idItem+"&branch="+getBranchVal);
    Map data = jsonDecode(response.body);
    setState(() {
      //getBranchVal = data["c"].toString();
    });
  }


  _prepare() async {
    await _connect();
    await _session();
    await _getBranch();
    await _getDetail();
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
          backgroundColor: Colors.white,
          leading: Builder(
            builder: (context) => IconButton(
                icon: new Icon(Icons.arrow_back,size: 20,),
                color: Colors.black,
                onPressed: () => {
                  Navigator.pop(context)
                }),
          ),
        ),
      ),
    );
  }
}