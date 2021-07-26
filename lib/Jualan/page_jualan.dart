


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
import 'package:moobi_flutter/Helper/color_based.dart';
import 'package:moobi_flutter/Helper/page_route.dart';
import 'package:moobi_flutter/Helper/session.dart';
import 'package:moobi_flutter/Jualan/page_checkout.dart';
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
  List data3;
  FocusNode myFocusNode;
  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }


  bool _isvisible = true;

  TextEditingController _tambahanNama = TextEditingController();
  TextEditingController _tambahanBiaya = TextEditingController();
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
  String getNamaUser = '';
  _getBranch() async {
    final response = await http.get(
        applink+"api_model.php?act=userdetail&id="+getEmail.toString(),
        headers: {"Accept":"application/json","Content-Type": "application/json"}).
        timeout(Duration(seconds: 10),
        onTimeout: () {
          showToast("Connection Timeout", gravity: Toast.CENTER,
              duration: Toast.LENGTH_LONG);
          return;
        });
    Map data = jsonDecode(response.body);
    setState(() {
      getBranchVal = data["c"].toString();
      getNamaUser = data["j"].toString();
    });
  }


  String filter = "";
  String sortby = '0';
  Future<List> getData() async {
    http.Response response = await http.get(
        Uri.encodeFull(applink+"api_model.php?act=getdata_produk&id="+getBranchVal+""
            "&filter="+filter
            +"&sort="+sortby),
        headers: {"Accept":"application/json","Content-Type": "application/json"}
    );
    setState((){
      data = json.decode(response.body);
    });
  }

  Future<List> getDataOrderPending() async {
    http.Response response = await http.get(
        Uri.encodeFull(applink+"api_model.php?act=getdata_countorderpending&branch="
            +getBranchVal+"&namauser="+getNamaUser),
        headers: {"Accept":"application/json","Content-Type": "application/json"}
    );
    setState((){
      data2 = json.decode(response.body);
    });
  }

  Future<List> getDataKategori() async {
    http.Response response = await http.get(
        Uri.encodeFull(applink+"api_model.php?act=getdata_kategori&branch="
            +getBranchVal+"&filter="),
        headers: {"Accept":"application/json","Content-Type": "application/json"}
    );
    setState((){
      data3 = json.decode(response.body);
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


  int valJumlahq = 1;
  TextEditingController _transcomment = TextEditingController();
  void _kurangqty() {
    setState(() {
      valJumlahq -= 1;
    });
  }

  void _tambahqty() {
    setState(() {
      valJumlahq += 1;
    });
  }


  addKeranjang2(String valProduk) async {
    final response = await http.post(applink+"api_model.php?act=add_keranjang2",
        body: {
            "produk_id": valProduk,
            "emailuser" : getEmail,
            "produk_branch" : getBranchVal,
            "trans_comment" : _transcomment.text,
            "trans_jumlah" : valJumlahq.toString()
        }).timeout(Duration(seconds: 10),
        onTimeout: () {
          showToast("Connection Timeout", gravity: Toast.CENTER,
              duration: Toast.LENGTH_LONG);
          return;
        });
    Map data = jsonDecode(response.body);
    setState(() {
      if (data["message"].toString() == '0') {
        showToast("Mohon maaf produk tidak aktif", gravity: Toast.BOTTOM,
            duration: Toast.LENGTH_LONG);
        return false;
      } else if (data["message"].toString() == '1') {
        showToast("Mohon maaf stock habis", gravity: Toast.BOTTOM,
            duration: Toast.LENGTH_LONG);
        return false;
      } else if (data["message"].toString() == '2') {
        showToast("Mohon maaf stock tidak mencukupi", gravity: Toast.BOTTOM,
            duration: Toast.LENGTH_LONG);
        return false;
      }
    });

    Navigator.pop(context);
  }


  addKeranjang(String valProduk) async {
    final response = await http.post(applink+"api_model.php?act=add_keranjang", body: {
      "produk_id": valProduk,
      "emailuser" : getEmail,
      "produk_branch" : getBranchVal
    }).timeout(Duration(seconds: 10),
        onTimeout: () {
          showToast("Connection Timeout", gravity: Toast.CENTER,
              duration: Toast.LENGTH_LONG);
          return;
        });
    Map data = jsonDecode(response.body);
    setState(() {
      if (data["message"].toString() == '0') {
        showToast("Stock tidak bisa digunakan", gravity: Toast.BOTTOM,
            duration: Toast.LENGTH_LONG);
        return false;
      } else if (data["message"].toString() == '1') {
        showToast("Mohon maaf stock habis", gravity: Toast.BOTTOM,
            duration: Toast.LENGTH_LONG);
        return false;
      } else if (data["message"].toString() == '2') {
        showToast("Mohon maaf stock tidak mencukupi", gravity: Toast.BOTTOM,
            duration: Toast.LENGTH_LONG);
        return false;
      }
    });
  }


  addKeranjangLain() async {
    final response = await http.post(applink+"api_model.php?act=add_keranjanglain",
        body: {
            "emailuser" : getEmail,
            "produk_branch" : getBranchVal,
            "produk_name" : _tambahanNama.text,
            "produk_harga" : _tambahanBiaya.text
          }).timeout(Duration(seconds: 10),
        onTimeout: () {
          showToast("Connection Timeout", gravity: Toast.CENTER,
              duration: Toast.LENGTH_LONG);
          return;
        });
    Map data = jsonDecode(response.body);
    setState(() {
      FocusScope.of(context).requestFocus(FocusNode());
      Navigator.pop(context);
      _tambahanNama.text = "";
      _tambahanBiaya.text = "";
    });
  }



  hapus_trans() async {
    final response = await http.post(applink+"api_model.php?act=hapus_trans",
        body: {
      "emailuser" : getEmail,
      "produk_branch" : getBranchVal
    }).timeout(Duration(seconds: 10),
        onTimeout: () {
          showToast("Connection Timeout", gravity: Toast.CENTER,
              duration: Toast.LENGTH_LONG);
          return;
        });
    Map data = jsonDecode(response.body);
  }



  void _filterMe() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content:
              Container(
                  height: 125,
                  child: Scrollbar(
                      isAlwaysShown: true,
                      child :
                      SingleChildScrollView(
                        child :
                        Column(
                          children: [
                            InkWell(
                              onTap: (){
                                setState(() {
                                  sortby = '0';
                                  _isvisible = false;
                                  startSCreen();
                                  Navigator.pop(context);
                                });
                              },
                              child: Align(alignment: Alignment.centerLeft,
                                child:    Text(
                                  "Semua",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontFamily: 'VarelaRound',
                                      fontSize: 15),
                                ),),
                            ),
                            Padding(padding: const EdgeInsets.only(top:15,
                                bottom: 15,left: 4,right: 4),
                              child: Divider(height: 5,),),
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
                            Padding(padding: const EdgeInsets.only(top:15,bottom: 15,
                                left: 4,right: 4),
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
                            Padding(padding: const EdgeInsets.only(top:15,bottom: 15,
                                left: 4,right: 4),
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
                      )))
          );
        });
  }



  dialogAdd(String valNama, String valID) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          int valJumlahq2 = 1;
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                //title: Text(),
                content: ResponsiveContainer(
                    widthPercent: 100,
                    heightPercent: 35,
                    child: Column(
                      children: [
                        Padding(padding: const EdgeInsets.only(top: 8), child:
                        Align(alignment: Alignment.center, child: Text(valNama,
                            style: TextStyle(fontFamily: 'VarelaRound', fontSize: 16,
                                fontWeight: FontWeight.bold))
                        ),),
                        Padding(padding: const EdgeInsets.only(top: 25,bottom: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FlatButton(child: Text("-",style: TextStyle(fontSize: 48,
                                  fontWeight: FontWeight.bold),),
                                onPressed: (){
                                  setState(() {
                                    _kurangqty();
                                    valJumlahq2 -= 1;
                                  });
                                },),
                              Text("$valJumlahq2",style: TextStyle(fontSize: 52,
                                  fontWeight: FontWeight.bold),),
                              FlatButton(child: Text("+",style: TextStyle(fontSize: 46,
                                  fontWeight: FontWeight.bold),),
                                onPressed: (){
                                  setState(() {
                                    _tambahqty();
                                    valJumlahq2 += 1;
                                  });
                                },),
                            ],
                          ),),


                        Padding(padding: const EdgeInsets.only(top: 15), child:
                        Align(alignment: Alignment.center, child:
                        TextFormField(
                          controller: _transcomment,
                          style: TextStyle(fontFamily: "VarelaRound",fontSize: 15),
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: new InputDecoration(
                            contentPadding: const EdgeInsets.only(top: 1,left: 10,
                                bottom: 1),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: HexColor("#DDDDDD"),
                                  width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: HexColor("#DDDDDD"),
                                  width: 1.0),
                            ),
                            hintText: 'Note. Contoh : Pedas, Tidak Pedas',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintStyle: TextStyle(fontFamily: "VarelaRound",
                                color: HexColor("#c4c4c4")),
                          ),
                        ),
                        )),
                        Padding(padding: const EdgeInsets.only(top: 20),
                          child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Expanded(child: OutlineButton(
                              onPressed: () {Navigator.pop(context);},
                              child: Text("Tutup"),)),
                            Expanded(child: OutlineButton(
                              borderSide: BorderSide(width: 1.0, color:
                              Colors.redAccent),
                              onPressed: () {
                                addKeranjang2(valID);
                              }, child: Text("Add to Chart",
                              style: TextStyle(color: Colors.red),),)),
                          ],),)
                      ],
                    )
                ),
              );
            },
          );
        });
  }


  TambahBiayaAdd() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                //title: Text(),
                content: ResponsiveContainer(
                    widthPercent: 100,
                    heightPercent: 26.5,
                    child: Column(
                      children: [
                        Padding(padding: const EdgeInsets.only(top: 8), child:
                        Align(alignment: Alignment.center,
                            child: Text("Tambah Biaya Lainnya",
                            style: TextStyle(fontFamily: 'ProximaNova',
                                fontSize: 16, fontWeight: FontWeight.bold))
                        ),),
                        Padding(padding: const EdgeInsets.only(top: 15), child:
                        Align(alignment: Alignment.center, child:
                        TextFormField(
                          controller: _tambahanNama,
                          style: TextStyle(fontFamily: "ProximaNova",
                              fontSize: 15,fontWeight: FontWeight.bold),
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: new InputDecoration(
                            contentPadding: const EdgeInsets.only(top: 1,left: 10,
                                bottom: 1),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: HexColor("#DDDDDD"),
                                  width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: HexColor("#DDDDDD"),
                                  width: 1.0),
                            ),
                            hintText: 'Nama Biaya. Contoh : Ongkir, dll',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintStyle: TextStyle(fontFamily: "ProximaNova",
                                color: HexColor("#c4c4c4"),fontSize: 15),
                          ),
                        ),
                        )),
                        Padding(padding: const EdgeInsets.only(top: 5), child:
                        Align(alignment: Alignment.center, child:
                        TextFormField(
                          controller: _tambahanBiaya,
                          style: TextStyle(fontFamily: "ProximaNova",fontSize: 15,
                              fontWeight: FontWeight.bold),
                          keyboardType: TextInputType.number,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: new InputDecoration(
                            contentPadding: const EdgeInsets.only(top: 1,left: 10,
                                bottom: 1),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: HexColor("#DDDDDD"),
                                  width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: HexColor("#DDDDDD"),
                                  width: 1.0),
                            ),
                            hintText: 'Biaya. Contoh : 12000, 15000',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintStyle: TextStyle(fontFamily: "ProximaNova",
                                color: HexColor("#c4c4c4"), fontSize: 15),
                          ),
                        ),
                        )),
                        Padding(padding: const EdgeInsets.only(top: 20), child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Expanded(child: OutlineButton(
                              onPressed: () {
                                Navigator.pop(context);
                              }, child: Text("Keluar",style: TextStyle(
                                fontFamily: "ProximaNova",fontWeight:
                            FontWeight.bold),),)),
                            Expanded(child: OutlineButton(
                              borderSide: BorderSide(width: 1.0,
                                  color: Colors.redAccent),
                              onPressed: () {

                                addKeranjangLain();
                              }, child: Text("Tambah", style: TextStyle(color:
                            Colors.red,fontFamily: "ProximaNova",
                                fontWeight: FontWeight.bold),),)),
                          ],),)
                      ],
                    )
                ),
              );
            },
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
            title: Text(
              "Transaksi Baru",
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Nunito',
                  fontSize: 18,fontWeight: FontWeight.bold),
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
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  TambahBiayaAdd();
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 25,top : 16),
                  child: FaIcon(
                    FontAwesomeIcons.plus,
                    color: HexColor("#6b727c"),
                    size: 18,
                  ),
                ),
              ),
              InkWell(
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  _filterMe();
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 25,top : 16),
                  child: FaIcon(
                    FontAwesomeIcons.sortAmountDown,
                    color: HexColor("#6b727c"),
                    size: 18,
                  ),
                ),
              ),
              InkWell(
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  hapus_trans();
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 27,top : 16),
                  child: FaIcon(
                    FontAwesomeIcons.trashAlt,
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
                Padding(padding: const EdgeInsets.only(left: 15,top: 10,
                    right: 15),
                    child: Container(
                      height: 45,
                      child: TextFormField(
                        enableInteractiveSelection: false,
                        onChanged: (text) {
                          setState(() {
                            filter = text;
                            _isvisible = false;
                            startSCreen();
                          });
                        },
                        style: TextStyle(fontFamily: "ProximaNova",fontSize: 15),
                        decoration: new InputDecoration(
                          contentPadding: const EdgeInsets.all(10),
                          fillColor: HexColor("#f4f4f4"),
                          filled: true,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Icon(Icons.search,size: 18,
                              color: HexColor("#6c767f"),),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white,
                              width: 1.0,),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: HexColor("#f4f4f4"),
                                width: 1.0),
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
                ),
                Padding(padding: const EdgeInsets.only(bottom: 10),),
                //
              ],
            ),
          ),
          floatingActionButton:
          Container(
            height: 65,
            width: 65,
            child: FutureBuilder(
                future: getDataOrderPending(),
                builder: (context, snapshot) {
                  return ListView.builder(
                      itemCount: data2 == null ? 0 : data2.length,
                      itemBuilder: (context, i) {
                        return  FittedBox(
                            child: Badge(
                              badgeContent: Text(
                                data2[i]["a"].toString() == "null" ? "0" :
                                data2[i]["a"].toString()
                                ,style: TextStyle(color: Colors.white,fontSize: 14),),
                              position: BadgePosition(end: 0,top: 0),
                              child: FloatingActionButton(
                                backgroundColor: HexColor(main_color),
                                onPressed: () {
                                  data2[i]["a"].toString() == "null" ?
                                  FocusScope.of(context).requestFocus(FocusNode())
                                      :
                                  Navigator.push(context, ExitPage(page: Checkout()));
                                },
                                child: FaIcon(FontAwesomeIcons.shoppingBasket),
                              ),
                            )
                        );
                      });
                }
            ),

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
                    onTap: () {
                      addKeranjang(data[i]["i"].toString());
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    onLongPress: (){
                      setState(() {
                        valJumlahq = 1;
                        _transcomment.text = "";
                      });
                      FocusScope.of(context).requestFocus(FocusNode());
                      dialogAdd(data[i]["a"], data[i]["i"].toString());
                      //myFocusNode.requestFocus();
                    }
                    ,
                    child: ListTile(
                      leading:
                      data[i]["e"] != 0 ?
                      Badge(
                          badgeContent: Text(data[i]["e"].toString(),
                            style: TextStyle(color: Colors.white,fontSize: 12),),
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
                                  progressIndicatorBuilder: (context, url,
                                      downloadProgress) =>
                                      CircularProgressIndicator(value:
                                      downloadProgress.progress),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
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
                              progressIndicatorBuilder: (context, url,
                                  downloadProgress) =>
                                  CircularProgressIndicator(value:
                                  downloadProgress.progress),
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
                                        locale: 'id', decimalDigits: 0, symbol: '').
                                    format(
                                        data[i]["c"]), style: new TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    fontFamily: 'VarelaRound',fontSize: 12),),
                                Padding(padding: const EdgeInsets.only(left: 5),child:
                                Text("Rp "+
                                    NumberFormat.currency(
                                        locale: 'id', decimalDigits: 0, symbol: '').
                                    format(
                                        data[i]["c"] - double.parse(data[i]["f"])),
                                  style: new TextStyle(
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