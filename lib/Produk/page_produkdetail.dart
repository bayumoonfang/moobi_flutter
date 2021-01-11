


import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:moobi_flutter/helper/api_link.dart';
import 'package:moobi_flutter/helper/check_connection.dart';
import 'package:moobi_flutter/helper/page_route.dart';
import 'package:moobi_flutter/helper/session.dart';
import 'package:moobi_flutter/page_login.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;


class ProdukDetail extends StatefulWidget {
  final String idItem;
  const ProdukDetail(this.idItem);
  @override
  _ProdukDetailState createState() => _ProdukDetailState();
}


class _ProdukDetailState extends State<ProdukDetail> {

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


  String getName = '...';
  String getPhoto = '...';
  String getDiscount = '0';
  String getDiscountVal = '0';
  String getHarga = '0';
  _getDetail() async {
    final response = await http.get(applink+"api_model.php?act=item_detail&id="+widget.idItem);
    Map data = jsonDecode(response.body);
    setState(() {
      getName = data["a"].toString();
      getPhoto = data["g"].toString();
      getDiscount = data["b"].toString();
      getDiscountVal = data["k"].toString();
      getHarga = data["d"].toString();
    });
  }





  _prepare() async {
    await _connect();
    await _session();
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
            backgroundColor: HexColor("#602d98"),
            leading: Builder(
              builder: (context) => IconButton(
                  icon: new Icon(Icons.arrow_back,size: 20,),
                  color: Colors.white,
                  onPressed: () => {
                    Navigator.pop(context)
                  }),
            ),
            actions: [
              Padding(padding: const EdgeInsets.only(top: 20,right: 25),child:
              InkWell(
                child: FaIcon(FontAwesomeIcons.pencilAlt,color: Colors.white,size: 18,),
              ),),
              Padding(padding: const EdgeInsets.only(top: 20,right: 20),child:
              InkWell(
                child: FaIcon(FontAwesomeIcons.percent,color: Colors.white,size: 18,),
              ),)

            ],
            title: Text(
              "Detail Produk",
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'VarelaRound',
                  fontSize: 16),
            ),
          ),
          body: Container(
            height: double.infinity,
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(padding: const EdgeInsets.only(top: 20),
                    child: ListTile(
                      leading:  CircleAvatar(
                        radius: 30,
                        backgroundColor: HexColor("#602d98"),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 27,
                          backgroundImage:
                          getPhoto == '' ?
                          CachedNetworkImageProvider(applink+"photo/nomage.jpg")
                              :
                          CachedNetworkImageProvider(applink+"photo/"+getPhoto,
                          ),
                        ),
                      ),
                      title: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(getName.toString(),style: TextStyle(
                            fontFamily: 'VarelaRound', fontSize: 18,
                            fontWeight: FontWeight.bold)),),
                      subtitle: Align(
                        alignment: Alignment.centerLeft,
                        child:
                          getDiscount != '0' ?
                          Row(
                            children: [
                              Text("Rp "+
                                  NumberFormat.currency(
                                      locale: 'id', decimalDigits: 0, symbol: '').format(
                                      double.parse(getHarga)), style: new TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  fontFamily: 'VarelaRound',fontSize: 12),),
                              Padding(padding: const EdgeInsets.only(left: 5),child:
                              Text("Rp "+
                                  NumberFormat.currency(
                                      locale: 'id', decimalDigits: 0, symbol: '').format(
                                      double.parse(getHarga)- double.parse(getDiscountVal)), style: new TextStyle(
                                      fontFamily: 'VarelaRound',fontSize: 12, color: Colors.black,
                                      fontWeight: FontWeight.bold),),)
                            ],
                          )
                              :
                          Text("Rp "+
                              NumberFormat.currency(
                                  locale: 'id', decimalDigits: 0, symbol: '').format(
                                  double.parse(getHarga)), style: new TextStyle(
                              fontFamily: 'VarelaRound',fontSize: 12,fontWeight: FontWeight.bold),))
                    ),
                  ),
                  Padding(padding: const EdgeInsets.only(left: 15,right: 15,top: 10),
                    child: Divider(height: 3,),),
                  Padding(padding: const EdgeInsets.only(left: 15,right: 15),
                    child: ListTile(
                        title: Opacity(
                          opacity: 0.6,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Produk Terjual",style: TextStyle(fontWeight: FontWeight.bold
                                , fontFamily: 'VarelaRound')),),
                        ),
                        trailing: Container(
                          height: 30,
                          child: RaisedButton(
                            onPressed: (){

                            },
                            color: HexColor("#602d98"),
                            shape: RoundedRectangleBorder(side: BorderSide(
                                color: Colors.black,
                                width: 0.1,
                                style: BorderStyle.solid
                            ),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            child: Text("Upgrade",style: TextStyle(
                                color: Colors.white, fontFamily: 'VarelaRound',fontSize: 13)),
                          ),
                        )
                    ),),
                ],
              ),
            ),
          ),
        ),
      );

  }
}