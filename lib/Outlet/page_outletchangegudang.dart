


import 'dart:async';
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
import 'package:moobi_flutter/Outlet/page_detailoutlet.dart';
import 'package:moobi_flutter/page_login.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../page_intoduction.dart';

class OutletChangeGudang extends StatefulWidget{
  final String getEmail;
  final String getLegalCode;
  final String idOutlet;

  const OutletChangeGudang(this.getEmail, this.getLegalCode,this.idOutlet);
  _OutletChangeGudang createState() => _OutletChangeGudang();
}


class _OutletChangeGudang extends State<OutletChangeGudang> {
  List data;
  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);}

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

  _prepare() async {
    await _startingVariable();
  }




  @override
  void initState() {
    super.initState();
    _prepare();
  }

  var client = http.Client();
  Future<dynamic> getDataGudang() async {
    http.Response response = await client.get(
        Uri.parse(applink+"api_model.php?act=getdata_gudangall&id="
            +widget.getLegalCode),
        headers: {
          "Accept":"application/json",
          "Content-Type": "application/json"}
    );
    return json.decode(response.body);
  }



  Future<bool> _onWillPop() async {
    //Navigator.pushReplacement(context, EnterPage(page: DetailOutlet(widget.idOutlet)));
    Navigator.pop(context);
  }


  String getMessage;
  void changeGudang(String valGudang, String valNamaGudang, String valIDOutlet) async {
    final response = await http.post(applink+"api_model.php?act=action_changegudangdefault",
        body: {
          "idGudang": valGudang,
          "namaGudang" :valNamaGudang,
          "idOutlet":valIDOutlet
        },
        headers: {"Accept":"application/json"});
    Map showdata = jsonDecode(response.body);
    getMessage = showdata["message"].toString();
    if(getMessage == '0') {
      showsuccess(valNamaGudang+" sudah terpakai");
    } else {
      showsuccess("Gudang default berhasil diganti ke "+valNamaGudang);
      setState(() {
        getDataGudang();
      });
    }

  }




  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: new AppBar(
          backgroundColor: HexColor(main_color),
          title: Text(
            "Ubah Gudang Default",
            style: TextStyle(
                color: Colors.white, fontFamily: 'VarelaRound', fontSize: 16),
          ),
          leading: Builder(
            builder: (context) => IconButton(
                icon: new FaIcon(FontAwesomeIcons.times),
                color: Colors.white,
                onPressed: () => {
                    //Navigator.pushReplacement(context, EnterPage(page: DetailOutlet(widget.idOutlet)))
                Navigator.pop(context)
                }),
          )
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: FutureBuilder(
            future: getDataGudang(),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return Center(
                    child: CircularProgressIndicator()
                );
              } else {
                return snapshot.data == 0 ?
                Container(
                    height: double.infinity, width : double.infinity,
                    child: new
                    Center(
                        child :
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new Text(
                              "Tidak ada data",
                              style: new TextStyle(
                                  fontFamily: 'VarelaRound', fontSize: 18),
                            ),
                            new Text(
                              "Silahkan lakukan input data",
                              style: new TextStyle(
                                  fontFamily: 'VarelaRound', fontSize: 12),
                            ),
                          ],
                        )))
                    :

                ListView.builder(
                  itemCount: snapshot.data == null ? 0 : snapshot.data.length,
                  itemBuilder: (context, i) {
                    return Padding(padding: const EdgeInsets.only(left: 10,right: 10,top: 5),
                      child:
                      snapshot.data[i]["d"] == '0' ?
                      InkWell(
                          onTap: () {
                            changeGudang(snapshot.data[i]["a"].toString(), snapshot.data[i]["b"].toString(), widget.idOutlet);
                          },
                          child :
                          Card(
                            child: ListTile(
                              leading: FaIcon(FontAwesomeIcons.warehouse, size: 18,),
                              title: Text(snapshot.data[i]["b"],style: TextStyle(
                                  color: Colors.black, fontFamily: 'VarelaRound',fontSize: 15)),
                            ),
                          ))

                          :
                      Opacity(
                        opacity: 0.5,
                        child: Card(
                          color: HexColor("#DDDDDD"),
                          child: ListTile(
                            leading: FaIcon(FontAwesomeIcons.warehouse, size: 18,),
                            title: Text(snapshot.data[i]["b"],style: TextStyle(
                                color: Colors.black, fontFamily: 'VarelaRound',fontSize: 15)),
                          ),
                        ),
                      )

                      ,);
                  },
                );
              }
            },
          ),
        ),
      ),
    );


  }
}