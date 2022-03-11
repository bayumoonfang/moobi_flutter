




import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:moobi_flutter/Helper/app_helper.dart';
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

  Future<List> getData() async {
    http.Response response = await http.get(
        Uri.encodeFull(applink+"api_model.php?act=getdata_stock&branch="+getBranch.toString()+"&"
            "id="+widget.idProduk.toString()),
        headers: {"Accept":"application/json"}
    );
    return json.decode(response.body);

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
                        if(snapshot.data == null) {
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
                                itemCount: snapshot.data == null ? 0 : snapshot.data.length,
                                itemBuilder: (context, i) {
                                  return ListTile(
                                      leading: Padding(padding: const EdgeInsets.only(top: 5),child:
                                      FaIcon(FontAwesomeIcons.warehouse),),
                                      title: Align(alignment: Alignment.centerLeft,child: Text(snapshot.data[i]["c"],
                                        style: new TextStyle(
                                            fontFamily: 'VarelaRound', fontSize: 14,
                                            fontWeight: FontWeight.bold),),),
                                      subtitle: Align(alignment: Alignment.centerLeft,child: Text(snapshot.data[i]["b"],
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
                                        child: Text(snapshot.data[i]["a"].toString(),style: TextStyle(
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