


import 'dart:async';
import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:moobi_flutter/Helper/check_connection.dart';
import 'package:moobi_flutter/Helper/page_route.dart';
import 'package:moobi_flutter/Helper/session.dart';
import 'package:moobi_flutter/page_login.dart';
import 'package:responsive_container/responsive_container.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:moobi_flutter/helper/api_link.dart';


class Jualan extends StatefulWidget{
  @override
  JualanState createState() => JualanState();
}


class JualanState extends State<Jualan> {
  List data;

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }
  bool _isvisible = true;


  String getEmail = '...';
  _session() async {
    int value = await Session.getValue();
    getEmail = await Session.getEmail();
    if (value != 1) {
      Navigator.pushReplacement(context, ExitPage(page: Login()));
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
      getBranchVal = data["c"].toString();
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

  startSCreen() async {
    var duration = const Duration(seconds: 1);
    return Timer(duration, () {
      setState(() {
        _isvisible = true;
      });
    });
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
          backgroundColor: Colors.white,
          leadingWidth: 38, // <-- Use this
          centerTitle: false,
          title:Align(
            alignment: Alignment.centerLeft,
            child: Padding(padding: const EdgeInsets.only(right: 5),
                child: Container(
                  height: 40,
                  child: TextFormField(

                    //controller: _nama,
                    style: TextStyle(fontFamily: "VarelaRound",fontSize: 15),
                    decoration: new InputDecoration(
                      fillColor: HexColor("#f4f5f7"),
                      filled: true,
                      contentPadding: const EdgeInsets.only(top: 1,left: 15,bottom: 1),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: HexColor("#DDDDDD"), width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: HexColor("#DDDDDD"), width: 1.0),
                      ),
                      hintText: 'Cari Produk...',
                    ),
                  ),
                )
            ),
          ),
          leading: Container(
            padding: const EdgeInsets.only(left: 7),
            child: Builder(
              builder: (context) => IconButton(
                  icon: new Icon(Icons.arrow_back),
                  color: Colors.black,
                  onPressed: () => {
                    Navigator.pop(context)
                  }),
            ),
          ),
          actions: [
            InkWell(
              onTap: () {
                //_showAlert();
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 25,top : 16),
                child: FaIcon(
                    FontAwesomeIcons.solidHeart,
                    color: HexColor("#6b727c"),
                    size: 18,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                //_showAlert();
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 27,top : 16),
                child: FaIcon(
                  FontAwesomeIcons.thList,
                  color: HexColor("#6b727c"),
                  size: 18,
                ),
              ),
            )
          ],
        ),
        body: Container(
          child: Column(
            children: [

              Padding(padding: const EdgeInsets.only(top: 10),),
              Visibility(
                  visible: _isvisible,
                  child :
                  Expanded(child: _dataField())
              )
              //
            ],
          ),
        ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(right : 10),
            child: Badge(
              badgeContent: Padding(padding: const EdgeInsets.all(2), child: Text("3",style: TextStyle(color: Colors.white,fontSize: 18),),),
              child: FloatingActionButton(
                onPressed: (){
                  //Navigator.push(context, ExitPage(page: ProdukInsert()));
                },
                child: FaIcon(FontAwesomeIcons.shoppingBasket),
              ),
            )
          )
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
                    child: ListTile(
                        leading:
                        data[i]["e"] != 0 ?
                        Badge(
                          position: BadgePosition.topEnd(top: 0, end: 0 ),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: HexColor("#602d98"),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 27,
                              backgroundImage:
                              data[i]["d"] == '' ?
                              CachedNetworkImageProvider(applink+"photo/nomage.jpg")
                                  :
                              CachedNetworkImageProvider(applink+"photo/"+getBranchVal+"/"+data[i]["d"],
                              ),
                            ),
                          ),
                          badgeContent: Text(data[i]["e"].toString(),style: TextStyle(color: Colors.white,
                              fontSize: 11),),
                          toAnimate: false,
                        )
                            :
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: HexColor("#602d98"),
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 27,
                            backgroundImage:
                            data[i]["d"] == '' ?
                            CachedNetworkImageProvider(applink+"photo/nomage.jpg")
                                :
                            CachedNetworkImageProvider(applink+"photo/"+getBranchVal+"/"+data[i]["d"],
                            ),
                          ),
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