

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:moobi_flutter/helper/check_connection.dart';
import 'package:moobi_flutter/helper/page_route.dart';
import 'package:moobi_flutter/helper/session.dart';
import 'package:moobi_flutter/page_home.dart';
import 'package:moobi_flutter/page_login.dart';
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';


class Produk extends StatefulWidget{
  @override
  _ProdukState createState() => _ProdukState();
}


class _ProdukState extends State<Produk> {
  List data;
  String getFilter = '';
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
        showToast("Koneksi terputus..", gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      }
    });
  }


  Future<List> getData() async {
    http.Response response = await http.get(
        Uri.encodeFull("https://duakata-dev.com/moobi/m-moobi/api_model.php?act=getdata_produk&id=TI"),
        headers: {"Accept":"application/json"}
    );
    setState((){
      data = json.decode(response.body);
    });
  }

  Future<void> _getData() async {
    setState(() {
      getFilter = '';
      getData();
    });
  }

  _prepare() async {
      await _connect();
      await _session();
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
              appBar: AppBar(
                backgroundColor: Colors.white,
                leading: Builder(
                  builder: (context) => IconButton(
                    icon: new Icon(Icons.arrow_back),
                    color: Colors.black,
                    onPressed: () => Navigator.push(context, EnterPage(page: Home())),
                  ),
                ),
                title: Text(
                  "Produk Saya",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'VarelaRound',
                      fontSize: 16),
                ),
              ),
              body: Container(
                child: Column(
                  children: [
                        Padding(padding: const EdgeInsets.only(top: 10),),
                        Expanded(child: _dataField())
                  ],
                ),
              ),
            ),
        );
  }

  Widget _dataField() {
        return FutureBuilder(
              future : getData(),
              builder: (context, snapshot) {
                  if (data == null) {
                    return Center(
                        child: Image.asset(
                          "assets/loadingq.gif",
                          width: 110.0,
                        )
                    );
                  } else {
                            return data.isEmpty ?
                            Center(
                                child: new Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    new Text(
                                      "Data tidak ditemukan",
                                      style: new TextStyle(
                                          fontFamily: 'VarelaRound', fontSize: 20),
                                    ),
                                    new Text(
                                      "Silahkan lakukan input data..",
                                      style: new TextStyle(
                                          fontFamily: 'VarelaRound', fontSize: 16),
                                    ),
                                  ],
                                ))
                                :
                                RefreshIndicator(
                                    onRefresh: _getData,
                                    child: new ListView.builder(
                                        itemCount: data == null ? 0 : data.length,
                                        itemBuilder: (context, i) {
                                              return Column(
                                                  children: <Widget>[
                                                        InkWell(
                                                          onTap: () {},
                                                          child: ListTile(
                                                            leading:
                                                            CircleAvatar(
                                                              backgroundImage:
                                                              data[i]["e"] == '' ? AssetImage("assets/mira-ico.png") :
                                                              CachedNetworkImageProvider("https://duakata-dev.com/moobi/m-moobi/photo/"+data[i]["d"],
                                                              ),
                                                              backgroundColor: Colors.white,
                                                              radius: 28,
                                                            ),
                                                            title: Align(
                                                              alignment: Alignment.centerLeft,
                                                              child: Text(
                                                                data[i]["a"],
                                                                style: TextStyle(
                                                                    fontSize: 17,
                                                                    fontFamily: 'VarelaRound'),
                                                              ),
                                                            ),
                                                            subtitle: Column(
                                                              children: [
                                                                Padding(
                                                                    padding:
                                                                    const EdgeInsets.all(
                                                                        2.0)
                                                                ),
                                                                Align(
                                                                  alignment:
                                                                  Alignment.bottomLeft,
                                                                  child: Text(
                                                                      data[i]["b"],
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                          'VarelaRound')),
                                                                ),
                                          Padding(
                                          padding: const EdgeInsets.only(top:5),
                                          child : Text("Rp "+
                                              NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: '').format(data[i]["i"]),
                                            style: new TextStyle(decoration: TextDecoration.lineThrough,fontFamily:
                                            'VarelaRound'),),)
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                  ],
                                              );
                                        },
                                    ),
                                );
                  }
              },
        );
  }


}