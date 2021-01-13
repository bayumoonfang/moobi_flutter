




import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:moobi_flutter/helper/api_link.dart';
import 'package:moobi_flutter/helper/check_connection.dart';
import 'package:moobi_flutter/helper/page_route.dart';
import 'package:moobi_flutter/helper/session.dart';
import 'package:moobi_flutter/page_login.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;


class ProdukStok extends StatefulWidget{
  final String idProduk, namaProduk;
  const ProdukStok(this.idProduk,this.namaProduk);
  @override
  _ProdukStokState createState() => _ProdukStokState();
}

class _ProdukStokState extends State<ProdukStok> {
  List data;
  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }

  _connect() async {
    Checkconnection().check().then((internet){
      if (internet != null && internet) {} else {
        showToast("Koneksi terputus..", gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      }
    });
  }



  String getEmail = '...';
  _session() async {
    int value = await Session.getValue();
    getEmail = await Session.getEmail();
    if (value != 1) {Navigator.pushReplacement(context, ExitPage(page: Login()));}
  }


  String getBranch = "...";
  _getBranch() async {
    final response = await http.get(applink+"api_model.php?act=userdetail&id="+getEmail.toString());
    Map data = jsonDecode(response.body);
    setState(() {
      getBranch = data["c"].toString();
    });
  }


  _prepare() async {
    await _connect();
    await _session();
    await _getBranch();
  }


  @override
  void initState() {
    super.initState();
    _prepare();
  }

  Future<List> getData() async {
    http.Response response = await http.get(
        Uri.encodeFull(applink+"api_model.php?act=getdata_stock&branch="+getBranch.toString()+"&"
            "id="+widget.idProduk.toString()),
        headers: {"Accept":"application/json"}
    );
    setState((){
      data = json.decode(response.body);
    });
  }



  Future<bool> _onWillPop() async {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
     return WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: HexColor("#602d98"),
              leading: Builder(
                builder: (context) => IconButton(
                  icon: new Icon(Icons.arrow_back),
                  color: Colors.white,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              title: Text(
                "Stok Produk",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'VarelaRound',
                    fontSize: 16),
              ),
            ),
            body: Container(
              child: Column(
                children: [
                  Padding(padding: const EdgeInsets.only(top: 20,right: 15,left: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween,
                      children: [
                        Text(
                          "Kode Produk",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontFamily: 'VarelaRound',
                              fontSize: 13),
                        ),
                        Text(widget.idProduk.toString(),
                            style: TextStyle(
                                fontFamily: 'VarelaRound',
                                fontSize: 14)),
                      ],
                    ),),

                  Padding(padding: const EdgeInsets.only(top: 5,right: 15,left: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween,
                      children: [
                        Text(
                          "Nama Produk",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontFamily: 'VarelaRound',
                              fontSize: 13),
                        ),
                        Text(widget.namaProduk.toString(),
                            style: TextStyle(
                                fontFamily: 'VarelaRound',
                                fontSize: 14)),
                      ],
                    ),),
                  Padding(padding: const EdgeInsets.only(top :15),
                    child: Container(
                      height: 10,
                      width: double.infinity,
                      color: HexColor("#f4f4f4"),
                    ),),
                  Expanded(
                    child: FutureBuilder(
                      future: getData(),
                      builder: (context, snapshot){
                        if(data == null) {
                          return Center(
                              child: Image.asset(
                                "assets/loadingq.gif",
                                width: 110.0,
                              )
                          );
                        } else {
                          return data == 0 ?
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
                                        "Data tidak ditemukan",
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
                                itemCount: data == null ? 0 : data.length,
                                itemBuilder: (context, i) {
                                  return ListTile(
                                      leading: Padding(padding: const EdgeInsets.only(top: 5),child:
                                      FaIcon(FontAwesomeIcons.warehouse),),
                                      title: Align(alignment: Alignment.centerLeft,child: Text(data[i]["c"],
                                        style: new TextStyle(
                                            fontFamily: 'VarelaRound', fontSize: 14,
                                            fontWeight: FontWeight.bold),),),
                                      subtitle: Align(alignment: Alignment.centerLeft,child: Text(data[i]["b"],
                                        style: new TextStyle(
                                            fontFamily: 'VarelaRound', fontSize: 12),),),
                                    trailing: Container(
                                      height: 25,
                                      child: RaisedButton(
                                        onPressed: (){},
                                        color: HexColor("#602d98"),
                                        shape: RoundedRectangleBorder(side: BorderSide(
                                            color: Colors.black,
                                            width: 0.1,
                                            style: BorderStyle.solid
                                        ),
                                          borderRadius: BorderRadius.circular(50.0),
                                        ),
                                        child: Text(data[i]["a"].toString(),style: TextStyle(
                                            color: Colors.white, fontFamily: 'VarelaRound',fontSize: 13)),
                                      ),
                                    )
                                  );
                                }
                              );
                        }
                      }

                    ),
                  )


                ],
              ),
            ),
          ),
     );

  }
}