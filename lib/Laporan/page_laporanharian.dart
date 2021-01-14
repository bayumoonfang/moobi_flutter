


import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:moobi_flutter/Helper/api_link.dart';
import 'package:moobi_flutter/Helper/check_connection.dart';
import 'package:moobi_flutter/Helper/page_route.dart';
import 'package:moobi_flutter/Helper/session.dart';
import 'package:moobi_flutter/page_home.dart';
import 'package:moobi_flutter/Laporan/page_laporanhome.dart';
import 'package:http/http.dart' as http;
import 'package:moobi_flutter/page_login.dart';
import 'package:toast/toast.dart';

class LaporanHarian extends StatefulWidget {
  @override
  _LaporanHarianState createState() => _LaporanHarianState();
}


class _LaporanHarianState extends State<LaporanHarian> {
  List data;
  Future<bool> _onWillPop() async {Navigator.pushReplacement(context, EnterPage(page: LaporanHome()));}
  void showToast(String msg, {int duration, int gravity}) {
  Toast.show(msg, context, duration: duration, gravity: gravity);}

  _connect() async {
  Checkconnection().check().then((internet){
  if (internet != null && internet) {} else {
  showToast("Koneksi terputus..", gravity: Toast.CENTER,duration: Toast.LENGTH_LONG);}});}

  String getEmail = '...';
  _session() async {
  int value = await Session.getValue();
  getEmail = await Session.getEmail();
  if (value != 1) {Navigator.pushReplacement(context, ExitPage(page: Login()));}}

  String getBranchVal = '';
  _getBranch() async {
    final response = await http.get(applink+"api_model.php?act=userdetail&id="+getEmail.toString());
    Map data = jsonDecode(response.body);
    setState(() {getBranchVal = data["c"].toString();});}

  String getBulan = '...';String getTahun = "...";String gethari = "...";String getfulldate = "...";
  getDateNow() async {
    final response = await http.get(applink+"api_model.php?act=getdatenow");
    Map data2 = jsonDecode(response.body);
    setState(() {
      getBulan = data2["a"].toString();
      getTahun = data2["b"].toString();
      gethari = data2["c"].toString();
      getfulldate = data2["d"].toString();});}


  Future<List> getData() async {
    http.Response response = await http.get(
        Uri.encodeFull(applink+"api_model.php?act=getdata_produkterlarisdaily"
            "&tanggalq="+getfulldate.toString()
            +"&branch="+getBranchVal.toString()), headers: {"Accept":"application/json"}
    );
    setState((){
      data = json.decode(response.body);
    });
  }



  _prepare() async {
    await _connect();
    await _session();
    await getDateNow();
    await _getBranch();
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
          backgroundColor: HexColor("#602d98"),
          leading: Builder(
            builder: (context) => IconButton(icon: new Icon(Icons.arrow_back,size: 20,),color: Colors.white,
                onPressed: () => {Navigator.pushReplacement(context, EnterPage(page: LaporanHome()))}),),
          title: Text("Laporan Transaksi Harian", style: TextStyle(color: Colors.white, fontFamily: 'VarelaRound',fontSize: 16),),),
        body: Container(
              width: double.infinity,
              child:
          SingleChildScrollView(
          child :
          Padding(padding: const EdgeInsets.only(left: 0),child:
            Column(
            children: [
              Padding(padding: const EdgeInsets.only(top: 20,left: 25,right: 25),child: Align(alignment: Alignment.center,child:
              Text("Daily Report", style: TextStyle(color: Colors.black, fontFamily: 'VarelaRound',fontSize: 16,
              fontWeight: FontWeight.bold))),),
              Padding(padding: const EdgeInsets.only(top: 5),child: Align(alignment: Alignment.center,child:
              Text(gethari.toString()+" "+getBulan.toString()+" "+getTahun.toString(),
                  style: TextStyle(color: Colors.black, fontFamily: 'VarelaRound',fontSize: 11))),),

              Padding(padding: const EdgeInsets.only(top: 10,left: 25,right: 25), child: Container(height: 70,
                  decoration: BoxDecoration(border: Border.all(color: Colors.black38)),child:
                  ListTile(title: Text("2",
                  style: TextStyle(color: Colors.black, fontFamily: 'VarelaRound',
                      fontSize: 22, fontWeight: FontWeight.bold)),
                  subtitle: Opacity(opacity: 0.5, child: Text("Total Transaction",
                    style: TextStyle(color: Colors.black,fontFamily: 'VarelaRound',fontSize: 12)),),),),),

              Padding(padding: const EdgeInsets.only(top: 5,left: 25,right: 25), child: Container(height: 70,
                  decoration: BoxDecoration(border: Border.all(color: Colors.black38)),child:
                    ListTile(title: Text("Rp. 24.000.000",
                    style: TextStyle(color: Colors.black, fontFamily: 'VarelaRound',
                        fontSize: 22, fontWeight: FontWeight.bold)),
                    subtitle: Opacity(opacity: 0.5, child: Text("Total Sales Transaction",
                      style: TextStyle(color: Colors.black,fontFamily: 'VarelaRound',fontSize: 12)),),),),),

              Padding(padding: const EdgeInsets.only(top: 5,left: 25,right: 25), child: Container(height: 70,
                  decoration: BoxDecoration(border: Border.all(color: Colors.black38)),child:
                    ListTile(title: Text("Rp. 5.000.000",
                    style: TextStyle(color: Colors.black, fontFamily: 'VarelaRound',
                        fontSize: 22, fontWeight: FontWeight.bold)),
                    subtitle: Opacity(opacity: 0.5, child: Text("Total Tax / PPn",
                      style: TextStyle(color: Colors.black,fontFamily: 'VarelaRound',fontSize: 12)),),),),),

              Padding(padding: const EdgeInsets.only(top: 25,left: 25,right: 25), child: Container(height: 80,
                decoration: BoxDecoration(border: Border.all(color: HexColor("#eff3f6")),
                  color: HexColor("#eff3f6"),),child:
                Column(
                  children: [
                    Padding(padding: const EdgeInsets.only(top: 12),child:
                    Align(alignment: Alignment.center,child: Text("Total NetSales",
                        style: TextStyle(color: HexColor("#6e6f73"),
                            fontFamily: 'VarelaRound',fontSize: 12)),),),
                    Padding(padding: const EdgeInsets.only(top: 10),child:
                    Align(alignment: Alignment.center,child: Text("Rp.2.000.400.000",
                        style: TextStyle(color: Colors.black, fontFamily: 'VarelaRound',
                            fontSize: 26, fontWeight: FontWeight.bold)),),)],),),),
              Padding(padding: const EdgeInsets.only(top :10,left: 25,right: 25),
                child: Container(
                  height: 5,
                  width: double.infinity,
                  color: HexColor("#f4f4f4"),
                ),),

              Padding(padding: const EdgeInsets.only(top :10,left: 25,right: 25),
                child: Container(
                  height: 200,
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(padding: const EdgeInsets.only(top: 10,left: 10),
                          child: Align(alignment: Alignment.centerLeft,child: Text("Informasi Produk",style: TextStyle(
                              color: Colors.black, fontFamily: 'VarelaRound',fontSize: 15,
                              fontWeight: FontWeight.bold)),)),
                        Container(
                          height: 200,
                          child:
                          FutureBuilder(
                            future: getData(),
                            builder: (context, snapshot) {
                              if (data == null ) {
                                return Container(height: 2,width: 2,);
                              } else {
                                return ListView.builder(
                                  itemCount: data == null ? 0 : data.length,
                                  itemBuilder: (context, i) {
                                    return Column(
                                      children: [
                                        ListTile(
                                            title: Text(data[i]["c"]),
                                        )
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  )
                ),),


            ],
          ),
          )
        ),
      )),
    );
  }
}