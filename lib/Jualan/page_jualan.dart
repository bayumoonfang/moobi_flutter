


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
  List data2;
  FocusNode myFocusNode;
  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }
  bool _isvisible = true;
  bool isSemua = true;
  bool isTerjual = false;
  bool isDiskon = false;
  bool isTerlaris = false;
  bool isTermurah = false;
  bool isTermahal = false;
  TextEditingController _produkdibeli = TextEditingController();
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


  String filter = "Semua";
  String filterq = "";
  String sortby = '0';
  Future<List> getData() async {
    http.Response response = await http.get(
        Uri.encodeFull(applink+"api_model.php?act=getdata_produk_jual&id="+getBranchVal+"&filter="+filter
            +"&sort="+sortby+"&filterq="+filterq),
        headers: {"Accept":"application/json"}
    );
    setState((){
      data = json.decode(response.body);
    });
  }

  Future<List> getDataKategori() async {
    http.Response response = await http.get(
        Uri.encodeFull(applink+"api_model.php?act=getdata_kategori&branch="+getBranchVal+"&filter="),
        headers: {"Accept":"application/json"}
    );
    setState((){
      data2 = json.decode(response.body);
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
    _produkdibeli.text = "1";
  }


  dialogAdd(String valNama) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            //title: Text(),
            content: Container(
                width: double.infinity,
                height: 188,
                child: Column(
                  children: [
                    Align(alignment: Alignment.center, child:
                    Text("Jumlah Dibeli", style: TextStyle(fontFamily: 'VarelaRound', fontSize: 20,
                        fontWeight: FontWeight.bold)),),
                    Padding(padding: const EdgeInsets.only(top: 15), child:
                    Align(alignment: Alignment.center, child:
                    Text(valNama,
                        style: TextStyle(fontFamily: 'VarelaRound', fontSize: 12))
                    ),),
                    Padding(padding: const EdgeInsets.only(top: 15), child:
                    Align(alignment: Alignment.center, child:
                    TextFormField(
                      autofocus: true,
                      focusNode: myFocusNode,
                      controller: _produkdibeli,
                      style: TextStyle(fontFamily: "VarelaRound",fontSize: 15),
                      keyboardType: TextInputType.number,
                      decoration: new InputDecoration(
                        contentPadding: const EdgeInsets.only(top: 1,left: 10,bottom: 1),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: HexColor("#DDDDDD"), width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: HexColor("#DDDDDD"), width: 1.0),
                        ),
                        hintText: 'Contoh : 5, 25, dll',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintStyle: TextStyle(fontFamily: "VarelaRound", color: HexColor("#c4c4c4")),
                      ),
                    ),
                    )),
                    Padding(padding: const EdgeInsets.only(top: 25), child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(child: OutlineButton(
                          onPressed: () {Navigator.pop(context);}, child: Text("Tutup"),)),
                        Expanded(child: OutlineButton(
                          borderSide: BorderSide(width: 1.0, color: Colors.redAccent),
                          onPressed: () {
                            //doSimpandiskon();
                            //Navigator.pop(context);
                          }, child: Text("Add to Chart", style: TextStyle(color: Colors.red),),)),
                      ],),)
                  ],
                )
            ),
          );
        });


  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: new AppBar(
          elevation: 0.5,
          backgroundColor: Colors.white,
          leadingWidth: 38, // <-- Use this
          centerTitle: false,
          title:Align(
            alignment: Alignment.centerLeft,
            child: Padding(padding: const EdgeInsets.only(right: 5),
                child: Container(
                  height: 40,
                  child: TextFormField(
                    enableInteractiveSelection: false,
                    onChanged: (text) {
                      setState(() {
                        filterq = text;
                        _isvisible = false;
                        startSCreen();
                      });
                    },
                    //controller: _nama,
                    style: TextStyle(fontFamily: "VarelaRound",fontSize: 15),
                    decoration: new InputDecoration(
                      fillColor: HexColor("#f4f5f7"),
                      filled: true,
                      contentPadding: const EdgeInsets.only(top: 1,left: 15,bottom: 1),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 1.0),
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
          color: Colors.white,
          child: Column(
            children: [
              Container(
                height: 50,
                width: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Padding(padding: const EdgeInsets.only(left: 10),
                        child: Container(
                          height: 30,
                          child: RaisedButton(
                            elevation: 0,
                            child: Text("Semua",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,fontFamily: 'VarelaRound',
                                color: isSemua == true ? Colors.white : Colors.black
                            ),),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: isSemua == true ? HexColor("#602d98") : Colors.black,width: 0.8),
                            ),
                            color: isSemua == true ? HexColor("#602d98") : Colors.white ,
                            onPressed: (){
                              setState(() {
                                _isvisible = false;
                                isDiskon = false;
                                isTerjual = false;
                                isTerlaris = false;
                                isTermurah = false;
                                isTermahal = false;
                                isSemua = true;
                                filter = "Semua";
                                startSCreen();
                              });
                            },
                          ),
                        ),),

                      Padding(padding: const EdgeInsets.only(left: 10),
                        child: Container(
                          height: 30,
                          child: RaisedButton(
                            elevation: 0,
                            child: Text("Terjual Teakhir",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,fontFamily: 'VarelaRound',
                                color: isTerjual == true ? Colors.white : Colors.black
                            ),),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: isTerjual == true ? HexColor("#602d98") : Colors.black,width: 0.5),
                            ),
                            color: isTerjual == true ? HexColor("#602d98") : Colors.white ,
                            onPressed: (){
                              setState(() {
                                _isvisible = false;
                                isDiskon = false;
                                isTerjual = true;
                                isTerlaris = false;
                                isTermurah = false;
                                isTermahal = false;
                                isSemua = false;
                                filter = "Terjual";
                                startSCreen();
                              });
                            },
                          ),
                        ),),

                      Padding(padding: const EdgeInsets.only(left: 10),
                        child: Container(
                          height: 30,
                          child: RaisedButton(
                            elevation: 0,
                            child: Text("Diskon",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,fontFamily: 'VarelaRound',
                                color: isDiskon == true ? Colors.white : Colors.black
                            ),),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: isDiskon == true ? HexColor("#602d98") : Colors.black,width: 0.5),
                            ),
                            color: isDiskon == true ? HexColor("#602d98") : Colors.white ,
                            onPressed: (){
                              setState(() {
                                _isvisible = false;
                                isDiskon = true;
                                isTerjual = false;
                                isTerlaris = false;
                                isTermurah = false;
                                isTermahal = false;
                                isSemua = false;
                                filter = "Diskon";
                                startSCreen();
                              });
                            },
                          ),
                        ),),


                      Padding(padding: const EdgeInsets.only(left: 10),
                        child: Container(
                          height: 30,
                          child: RaisedButton(
                            elevation: 0,
                            child: Text("Terlaris",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,fontFamily: 'VarelaRound',
                                color: isTerlaris == true ? Colors.white : Colors.black
                            ),),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: isTerlaris == true ? HexColor("#602d98") : Colors.black,width: 0.5),
                            ),
                            color: isTerlaris == true ? HexColor("#602d98") : Colors.white ,
                            onPressed: (){
                              setState(() {
                                _isvisible = false;
                                isDiskon = false;
                                isTerjual = false;
                                isSemua = false;
                                isTerlaris = true;
                                isTermurah = false;
                                isTermahal = false;
                                filter = "Terlaris";
                                startSCreen();
                              });
                            },
                          ),
                        ),),


                      Padding(padding: const EdgeInsets.only(left: 10),
                        child: Container(
                          height: 30,
                          child: RaisedButton(
                            elevation: 0,
                            child: Text("Termurah",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,fontFamily: 'VarelaRound',
                                color: isTermurah == true ? Colors.white : Colors.black
                            ),),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: isTermurah == true ? HexColor("#602d98") : Colors.black,width: 0.5),
                            ),
                            color: isTermurah == true ? HexColor("#602d98") : Colors.white ,
                            onPressed: (){
                              setState(() {
                                _isvisible = false;
                                isDiskon = false;
                                isTerjual = false;
                                isSemua = false;
                                isTerlaris = false;
                                isTermurah = true;
                                isTermahal = false;
                                filter = "Termurah";
                                startSCreen();
                              });
                            },
                          ),
                        ),),


                      Padding(padding: const EdgeInsets.only(left: 10,right: 10),
                        child: Container(
                          height: 30,
                          child: RaisedButton(
                            elevation: 0,
                            child: Text("Termahal",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,fontFamily: 'VarelaRound',
                                color: isTermahal == true ? Colors.white : Colors.black
                            ),),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: isTermahal == true ? HexColor("#602d98") : Colors.black,width: 0.5),
                            ),
                            color: isTermahal == true ? HexColor("#602d98") : Colors.white ,
                            onPressed: (){
                              setState(() {
                                _isvisible = false;
                                isDiskon = false;
                                isTerjual = false;
                                isSemua = false;
                                isTerlaris = false;
                                isTermurah = false;
                                isTermahal = true;
                                filter = "Termahal";
                                startSCreen();
                              });
                            },
                          ),
                        ),),



                    ],
                  ),
                )
              ),
              Padding(padding: const EdgeInsets.only(left: 15,right: 15),
              child: Divider(height: 4,),),
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
        floatingActionButton: Container(
          height: 70,
          width: 70,
          child: FittedBox(
            child: Badge(
              badgeContent: Text("3",style: TextStyle(color: Colors.white),),
              position: BadgePosition(end: 0,top: 0),
              child: FloatingActionButton(onPressed: () {},
                child: FaIcon(FontAwesomeIcons.shoppingBasket),
              ),
            )
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
                      FocusScope.of(context).requestFocus(FocusNode());
                      dialogAdd(data[i]["a"]);
                      myFocusNode.requestFocus();
                    },
                    child: ListTile(
                        leading:
                        data[i]["e"] != 0 ?
                           Badge(
                             badgeContent: Text(data[i]["e"].toString(),style: TextStyle(color: Colors.white,fontSize: 12),),
                             child:  SizedBox(
                                 width: 60,
                                 height: 100,
                                 child: ClipRRect(
                                   borderRadius: BorderRadius.circular(6.0),
                                   child : CachedNetworkImage(
                                     fit: BoxFit.cover,
                                     imageUrl:
                                     data[i]["d"] == '' ?
                                      applink+"photo/nomage.jpg"
                                      :
                                      applink+"photo/"+getBranchVal+"/"+data[i]["d"],
                                     progressIndicatorBuilder: (context, url, downloadProgress) =>
                                         CircularProgressIndicator(value: downloadProgress.progress),
                                     errorWidget: (context, url, error) => Icon(Icons.error),
                                   ),
                                 ))
                           )

                            :
                        SizedBox(
                            width: 60,
                            height: 100,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6.0),
                              child : CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl:
                                data[i]["d"] == '' ?
                                applink+"photo/nomage.jpg"
                                    :
                                applink+"photo/"+getBranchVal+"/"+data[i]["d"],
                                progressIndicatorBuilder: (context, url, downloadProgress) =>
                                    CircularProgressIndicator(value: downloadProgress.progress),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                              ),
                            )),
                        title: Align(alignment: Alignment.centerLeft,
                          child: Text(data[i]["a"],
                              style: TextStyle(fontFamily: "VarelaRound",
                                  fontSize: 13,fontWeight: FontWeight.bold)),),
                        subtitle: Align(alignment: Alignment.centerLeft,
                          child:
                          data[i]["e"] != 0 ?
                          ResponsiveContainer(
                            widthPercent: 45,
                            heightPercent: 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                    fontFamily: 'VarelaRound',fontSize: 12),),)
                              ],
                            ),
                          )
                              :
                          Text("Rp "+
                              NumberFormat.currency(
                                  locale: 'id', decimalDigits: 0, symbol: '').format(
                                  data[i]["c"]), style: new TextStyle(
                              fontFamily: 'VarelaRound',fontSize: 12),)
                        ),
                    ),
                  ),
                  Padding(padding: const EdgeInsets.only(top :10 ))
                ],
              );
            },
          );
        }
      },
    );
  }


}