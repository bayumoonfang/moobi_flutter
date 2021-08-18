


import 'dart:async';
import 'dart:convert';

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

class OutletChangeGudang extends StatefulWidget{
  final String idOutlet;
  const OutletChangeGudang(this.idOutlet);
  _OutletChangeGudang createState() => _OutletChangeGudang();
}


class _OutletChangeGudang extends State<OutletChangeGudang> {
  List data;
  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);}

  String getEmail = "...";
  String getBranch = "...";
  _startingVariable() async {
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      showToast("Koneksi terputus..", gravity: Toast.CENTER,duration:
      Toast.LENGTH_LONG);}});
    await AppHelper().getSession().then((value){if(value[0] != 1) {
      Navigator.pushReplacement(context, ExitPage(page: Login()));}else{setState(() {getEmail = value[1];});}});
    await AppHelper().getDetailUser(getEmail.toString()).then((value){
      setState(() {
        getBranch = value[1];
      });
    });
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
            +getBranch),
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
      showToast(valNamaGudang+" sudah terpakai", gravity: Toast.BOTTOM,
          duration: Toast.LENGTH_LONG);
    } else {
      showToast("Gudang default berhasil diganti ke "+valNamaGudang, gravity: Toast.BOTTOM,
          duration: Toast.LENGTH_LONG);
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
                icon: new Icon(Icons.arrow_back),
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
              return ListView.builder(
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
            },
          ),
        ),
      ),
    );


  }
}