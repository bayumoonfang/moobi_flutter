

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:moobi_flutter/helper/api_link.dart';

import 'package:moobi_flutter/helper/check_connection.dart';
import 'package:moobi_flutter/helper/page_route.dart';
import 'package:moobi_flutter/helper/session.dart';
import 'package:moobi_flutter/page_detailproduk.dart';
import 'package:moobi_flutter/page_home.dart';
import 'package:moobi_flutter/page_login.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:responsive_container/responsive_container.dart';
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


  String getEmail,getUsername = '...';
  _session() async {
    int value = await Session.getValue();
    getEmail = await Session.getEmail();
   // getUsername = await Session.getUsername();
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
        applink+"api_model.php?act=userdetail&id="+getEmail.toString());
    Map data = jsonDecode(response.body);
    setState(() {
      getBranchVal = data["f"].toString();
    });
  }


  String filter = "";
  String sortby = '0';
  Future<List> getData() async {
    http.Response response = await http.get(
        Uri.encodeFull(applink+"api_model.php?act=getdata_produk&id="+getBranchVal+"&filter="+filter
            +"&sort="+sortby),
        headers: {"Accept":"application/json"}
    );
    setState((){
      data = json.decode(response.body);
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

  void _filterMe() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content:
            Container(
              height: 125,
              child:
              SingleChildScrollView(
                child :
              Column(
                children: [
                  InkWell(
                    onTap: (){
                        setState(() {
                          sortby = '1';
                          Navigator.pop(context);
                        });
                    },
                    child: Align(alignment: Alignment.centerLeft,
                    child:    Text(
                      "Harga Terendah",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: 'VarelaRound',
                          fontSize: 15),
                    ),),
                  ),
                  Padding(padding: const EdgeInsets.only(top:15,bottom: 15,left: 4,right: 4),
                  child: Divider(height: 5,),),
                  InkWell(
                    onTap: (){
                      setState(() {
                        sortby = '2';
                        Navigator.pop(context);
                      });
                    },
                    child: Align(alignment: Alignment.centerLeft,
                      child:    Text(
                        "Harga Tertinggi",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontFamily: 'VarelaRound',
                            fontSize: 15),
                      ),),
                  ),
                  Padding(padding: const EdgeInsets.only(top:15,bottom: 15,left: 4,right: 4),
                    child: Divider(height: 5,),),
                  InkWell(
                    onTap: (){
                      setState(() {
                        sortby = '3';
                        Navigator.pop(context);
                      });
                    },
                    child: Align(alignment: Alignment.centerLeft,
                      child:    Text(
                        "Produk Diskon",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontFamily: 'VarelaRound',
                            fontSize: 15),
                      ),),
                  )
                ],
              ),
            ))
           /* actions: [
              new FlatButton(
                  onPressed: () {
                    _doDelete(valme);
                  },
                  child:
                  Text("Iya", style: TextStyle(fontFamily: 'VarelaRound',
                      fontWeight: FontWeight.bold,
                      fontSize: 18)))
            ],*/
          );
        });
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
                actions: [
                  Padding(padding: const EdgeInsets.only(top:0,right: 18), child:
                  Builder(
                    builder: (context) => IconButton(
                      icon: new FaIcon(FontAwesomeIcons.sortAmountDown,size: 18,),
                      color: Colors.black,
                      onPressed: ()  {
                        _filterMe();
                      }
                    ),
                  )),

                ],
              ),
              body: Container(
                child: Column(
                  children: [
                    Padding(padding: const EdgeInsets.only(left: 15,top: 10,right: 15),
                      child: Container(
                        height: 40,
                        child: TextFormField(
                          onChanged: (text) {
                              setState(() {
                                  filter = text;
                              });
                          },
                          keyboardType: TextInputType.emailAddress,
                          validator: (val) => val.isEmpty || !val.contains("@")
                              ? "enter a valid email"
                              : null,
                          style: TextStyle(fontFamily: "VarelaRound",fontSize: 14),
                          decoration: new InputDecoration(
                            contentPadding: const EdgeInsets.all(10),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Icon(Icons.search,size: 18,),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: HexColor("#DDDDDD"), width: 1.0,),
                              borderRadius: BorderRadius.circular(2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: HexColor("#DDDDDD"), width: 1.0),
                            ),
                            hintText: 'Cari Produk...',
                          ),
                        ),
                      )
                    ),
                    Padding(padding: const EdgeInsets.only(top: 10),),
                        Expanded(child: _dataField())
                  ],
                ),
              ),
              floatingActionButton: Padding(
                padding: const EdgeInsets.only(right : 10),
                child: FloatingActionButton(
                  onPressed: (){

                  },
                  child: FaIcon(FontAwesomeIcons.plus),
                ),
              )
              //floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
                               new ListView.builder(
                                        itemCount: data == null ? 0 : data.length,
                                        padding: const EdgeInsets.only(top: 2,bottom: 80),
                                        itemBuilder: (context, i) {
                                              return Column(
                                                  children: <Widget>[
                                                        InkWell(
                                                          onTap: () {
                                                            Navigator.push(context, ExitPage(page: DetailProduk(data[i]["g"])));
                                                          },
                                                          child: ListTile(
                                                            leading:
                                                    data[i]["e"] != 0 ?
                                                            Badge(
                                                              position: BadgePosition.topEnd(top: 0, end: 0 ),
                                                              child:
                                                              CircleAvatar(
                                                                backgroundImage:
                                                                data[i]["d"] == '' ?
                                                                CachedNetworkImageProvider(""
                                                                    "https://duakata-dev.com/moobi/m-moobi/photo/nomage.jpg")
                                                                    :
                                                                CachedNetworkImageProvider(""
                                                                    "https://duakata-dev.com/moobi/m-moobi/photo/"+data[i]["d"],
                                                                ),
                                                                backgroundColor: Colors.white,
                                                                radius: 23,
                                                              ),
                                                              badgeContent: Text(data[i]["e"].toString(),style: TextStyle(color: Colors.white,
                                                              fontSize: 11),),
                                                              toAnimate: false,
                                                            )
                                                        :
                                                            CircleAvatar(
                                                            backgroundImage:
                                                            data[i]["d"] == '' ?
                                                            CachedNetworkImageProvider("https://duakata-dev.com/moobi/m-moobi/photo/nomage.jpg")
                                                                :
                                                            CachedNetworkImageProvider("https://duakata-dev.com/moobi/m-moobi/photo/"+data[i]["d"],
                                                            ),
                                                            backgroundColor: Colors.white,
                                                            radius: 23,
                                                            ),

                                                            title: Align(alignment: Alignment.centerLeft,
                                                              child: Text(data[i]["a"],
                                                                  style: TextStyle(fontFamily: "VarelaRound",
                                                                      fontSize: 13,fontWeight: FontWeight.bold)),),
                                                            subtitle: Align(alignment: Alignment.centerLeft,
                                                              child: Text(data[i]["b"],
                                                                  style: TextStyle(fontFamily: "VarelaRound",
                                                                    fontSize: 11,)),
                                                            ),
                                                              trailing:
                                                              data[i]["e"] != 0 ?
                                                              ResponsiveContainer(
                                                                widthPercent: 35,
                                                                heightPercent: 2,
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                                  children: [
                                                                    Text("Rp "+
                                                                        NumberFormat.currency(
                                                                            locale: 'id', decimalDigits: 0, symbol: '').format(
                                                                            data[i]["c"]), style: new TextStyle(
                                                                        decoration: TextDecoration.lineThrough,
                                                                        fontFamily: 'VarelaRound',fontSize: 12),),
                                                                    Padding(padding: const EdgeInsets.only(left: 5),child:
                                                                    Text("Rp "+
                                                                        NumberFormat.currency(
                                                                            locale: 'id', decimalDigits: 0, symbol: '').format(
                                                                            data[i]["c"] - double.parse(data[i]["f"])), style: new TextStyle(
                                                                        fontFamily: 'VarelaRound',fontSize: 12,fontWeight: FontWeight.bold),),)
                                                                  ],
                                                                ),
                                                              )
                                                                  :
                                                              Text("Rp "+
                                                                  NumberFormat.currency(
                                                                      locale: 'id', decimalDigits: 0, symbol: '').format(
                                                                      data[i]["c"]), style: new TextStyle(
                                                                  fontFamily: 'VarelaRound',fontSize: 12,fontWeight: FontWeight.bold),)
                                                          ),
                                                        ),
                                                  ],
                                              );
                                        },
                                    );
                  }
              },
        );
  }


}