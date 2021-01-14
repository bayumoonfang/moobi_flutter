

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:moobi_flutter/Produk/page_produkdetail.dart';
import 'package:moobi_flutter/helper/api_link.dart';
import 'package:moobi_flutter/helper/check_connection.dart';
import 'package:moobi_flutter/helper/page_route.dart';
import 'package:moobi_flutter/helper/session.dart';
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
  FocusNode focusNode;
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
                          _isvisible = false;
                          startSCreen();
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
                        _isvisible = false;
                        startSCreen();
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
                        _isvisible = false;
                        startSCreen();
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
          );
        });
  }

  Future<bool> _onWillPop() async {
    Navigator.pushReplacement(context, EnterPage(page: Home()));
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
                    onPressed: () => Navigator.pushReplacement(context, EnterPage(page: Home())),
                  ),
                ),
                title: Text(
                  "Produk Saya",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'VarelaRound',
                      fontSize: 16),
                ),
                actions: [
                  Padding(padding: const EdgeInsets.only(top:0,right: 18), child:
                  Builder(
                    builder: (context) => IconButton(
                      icon: new FaIcon(FontAwesomeIcons.sortAmountDown,size: 18,),
                      color: Colors.white,
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
                        height: 50,
                        child: TextFormField(
                          enableInteractiveSelection: false,
                          onChanged: (text) {
                              setState(() {
                                  filter = text;
                                 _isvisible = false;
                                  startSCreen();
                              });
                          },
                          style: TextStyle(fontFamily: "VarelaRound",fontSize: 14),
                          decoration: new InputDecoration(
                            contentPadding: const EdgeInsets.all(10),
                            fillColor: HexColor("#f4f4f4"),
                            filled: true,
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Icon(Icons.search,size: 18,color: HexColor("#6c767f"),),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white, width: 1.0,),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: HexColor("#f4f4f4"), width: 1.0),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            hintText: 'Cari Produk...',
                          ),
                        ),
                      )
                    ),
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
                                                            Navigator.push(context, ExitPage(page: ProdukDetail(data[i]["i"].toString())));
                                                          },
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
                                                                 CachedNetworkImageProvider(applink+"photo/"+data[i]["d"],
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
                                                                 CachedNetworkImageProvider(applink+"photo/"+data[i]["d"],
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