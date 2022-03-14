


import 'dart:convert';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:moobi_flutter/Helper/api_link.dart';
import 'package:moobi_flutter/Helper/app_helper.dart';
import 'package:moobi_flutter/Helper/page_route.dart';
import 'package:moobi_flutter/Produk/page_produk.dart';
import 'package:moobi_flutter/Produk/page_kategori.dart';
import 'package:moobi_flutter/Produk/page_satuan.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import '../page_intoduction.dart';
import '../page_login.dart';
class ProdukHome extends StatefulWidget {
  final String getEmail;
  final String getLegalCode;
  final String getNamaUser;

  const ProdukHome(this.getEmail, this.getLegalCode, this.getNamaUser);
  @override
  _ProdukHomeState createState() => _ProdukHomeState();
}


class _ProdukHomeState extends State<ProdukHome> {


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



  Future<bool> _onWillPop() async {
    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: new AppBar(
          backgroundColor: HexColor("#602d98"),
          leading: Builder(
            builder: (context) => IconButton(
                icon: new Icon(Icons.arrow_back),
                color: Colors.white,
                onPressed: () {
                  _onWillPop();
                }
            ),
          ),
          title: Text(
            "Kelola Produk",
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'VarelaRound',
                fontSize: 16),
          ),
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.only(top: 10,left: 5,right: 15),
            child: Column(
              children: [
                InkWell(
                  child: ListTile(
                    onTap: (){Navigator.push(context, ExitPage(page: Produk(widget.getEmail, widget.getLegalCode, widget.getNamaUser)));},
                    title: Text("Master Data Produk",style: TextStyle(
                        color: Colors.black, fontFamily: 'VarelaRound',fontSize: 15,
                        fontWeight: FontWeight.bold)),
                    subtitle: Text("Kelola produk toko anda dengan mudah disini",style: TextStyle(
                        color: Colors.black, fontFamily: 'VarelaRound',fontSize: 12)),
                    trailing: FaIcon(FontAwesomeIcons.angleRight,color: HexColor("#594d75"),size: 15,),
                  ),
                ),
                Padding(padding: const EdgeInsets.only(top: 5,left: 15),
                  child: Divider(height: 3,),),

                InkWell(
                  child: ListTile(
                    onTap: (){Navigator.push(context, ExitPage(page: ProdukSatuan(widget.getEmail, widget.getLegalCode)));},
                    title: Text("Satuan ",style: TextStyle(
                        color: Colors.black, fontFamily: 'VarelaRound',fontSize: 15,
                        fontWeight: FontWeight.bold)),
                    subtitle: Text("Kelola satuan jual untuk produk kamu disini",style: TextStyle(
                        color: Colors.black, fontFamily: 'VarelaRound',fontSize: 12)),
                    trailing: FaIcon(FontAwesomeIcons.angleRight,color: HexColor("#594d75"),size: 15,),
                  ),
                ),
                Padding(padding: const EdgeInsets.only(top: 5,left: 15),
                  child: Divider(height: 3,),),

                InkWell(
                  child: ListTile(
                    onTap: (){Navigator.push(context, ExitPage(page: ProdukKategori(widget.getEmail, widget.getLegalCode)));},
                    title: Text("Kategori",style: TextStyle(
                        color: Colors.black, fontFamily: 'VarelaRound',fontSize: 15,
                        fontWeight: FontWeight.bold)),
                    subtitle: Text("Kelola kategori produk kamu dengan mudah disini",style: TextStyle(
                        color: Colors.black, fontFamily: 'VarelaRound',fontSize: 12)),
                    trailing: FaIcon(FontAwesomeIcons.angleRight,color: HexColor("#594d75"),size: 15,),
                  ),
                ),
                Padding(padding: const EdgeInsets.only(top: 5,left: 15),
                  child: Divider(height: 3,),),


              ],
            ),
          ),
        ),
      ),
    );

  }
}