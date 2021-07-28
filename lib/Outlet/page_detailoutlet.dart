

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:moobi_flutter/Helper/api_link.dart';
import 'package:moobi_flutter/Helper/app_helper.dart';
import 'package:moobi_flutter/Helper/color_based.dart';
import 'package:moobi_flutter/Helper/page_route.dart';
import 'package:moobi_flutter/page_login.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;


class DetailOutlet extends StatefulWidget {
  final String idOutlet;
  const DetailOutlet(this.idOutlet);
  @override
  _DetailOutlet createState() => _DetailOutlet();
}

class _DetailOutlet extends State<DetailOutlet> {
  List data;
  bool _isvisible = true;

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

  String getOutletName = "...";
  String getOutletAddress = "...";
  String getOutletCity = "...";
  String getOutletPhone = "...";
  String getOutletStatus = "...";
  String getOutletWarehouse = '...';
  String getLegalNama = '...';
  _outletDetail() async {
    final response = await http.get(
        applink+"api_model.php?act=outletdetail&id="+widget.idOutlet);
    Map data = jsonDecode(response.body);
    setState(() {
      getOutletName = data["a"].toString();
      getOutletAddress = data["b"].toString();
      getOutletCity = data["c"].toString();
      getOutletPhone = data["d"].toString();
      getOutletStatus = data["f"].toString();
      getOutletWarehouse = data["g"].toString();
      getLegalNama = data["h"].toString();
    });
  }



  Future<bool> _onWillPop() async {
    Navigator.pop(context);}


  _prepare() async {
    await _startingVariable();
    await _outletDetail();
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
            "Detail Outlet",
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
          actions: [
            InkWell(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                //alertSimpan();
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 27,top : 14),
                child: FaIcon(
                    FontAwesomeIcons.check
                ),
              ),
            )
          ],
        ),
        body: Container(
          child: Column(
            children: [
              Padding(padding: const EdgeInsets.only(left: 15,top: 20),
              child: Align(alignment: Alignment.centerLeft,child: Text(getOutletName,style: TextStyle(
                  color: Colors.black, fontFamily: 'VarelaRound',fontWeight: FontWeight.bold,fontSize: 20)),),),
              Padding(padding: const EdgeInsets.only(left: 15,top: 5),
                child: Align(alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Text("Owned By",style: TextStyle(
                          color: Colors.black, fontFamily: 'VarelaRound',fontSize: 12)),
                      Padding(padding: const EdgeInsets.only(right: 10)),
                      Container(
                        height: 20,
                        child: RaisedButton(
                          onPressed: (){},
                          color: HexColor("#eaffee"),
                          elevation: 1,
                          child: Text(getLegalNama,style: TextStyle(
                              color: HexColor("#00ac48"), fontFamily: 'VarelaRound',fontSize: 9)),
                        ),
                      )
                    ],
                  ),

                ),),
            ],
          ),
        ),
      ),
    );
  }
}