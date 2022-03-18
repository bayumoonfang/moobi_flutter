


import 'dart:async';
import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:moobi_flutter/Helper/app_helper.dart';
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

import '../page_intoduction.dart';


class Jualan extends StatefulWidget{
  final String getEmail;
  final String getLegalCode;
  final String getLegalId;
  final String getStoreId;
  final String getWarehouseKode;
  final String getUserNama;
  final String getWarehouseId;
  final String getTipe;
  const Jualan(this.getEmail, this.getLegalCode,this.getLegalId,this.getStoreId,this.getWarehouseKode, this.getUserNama,
      this.getWarehouseId, this.getTipe);
  @override
  JualanState createState() => JualanState();
}


class JualanState extends State<Jualan> {
  List data;
  String selectedCust;
  List customerList = List();


  Future<bool> _onWillPop() async {
    Navigator.pop(context);
  }
  FocusNode myFocusNode;
  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }


  TextEditingController _tambahanNama = TextEditingController();
  TextEditingController _tambahanBiaya = TextEditingController();

  bool _isVisible = true;
  startSCreen() async {
    Timer.periodic(Duration(milliseconds: 600), (timer) {
      setState(() {
        _isVisible = true;
      });
    });
  }



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

  String filter = "";
  String sortby = '';
  Future<List> getData() async {
    http.Response response = await http.get(
        Uri.encodeFull(applink+"api_model.php?act=getdata_produk_jual&"
            "branch="+widget.getLegalCode+""
            "&warehouse_kode="+widget.getWarehouseKode+""
            "&store_id="+widget.getStoreId+""
            "&filter="+filter+""
            "&sortby="+sortby+""
            "&getTipe="+widget.getTipe),
        headers: {
          "Accept":"application/json",
          "Content-Type": "application/json"}
    );
    return json.decode(response.body);

  }


  Future getCustomer() async {
    var response = await http.get(
        Uri.encodeFull(applink+"api_model.php?act=get_customer&legalid="+widget.getLegalCode));
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        //customerList = jsonData;
      });
    }
    //print(bankUserList);
  }


  Future<List> getDataOrderPending() async {
    http.Response response = await http.get(
        Uri.encodeFull(applink+"api_model.php?act=getdata_countorderpending&branch="
            +widget.getLegalCode+"&namauser="+widget.getUserNama),
        headers: {"Accept":"application/json","Content-Type": "application/json"}
    );
    return json.decode(response.body);
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

  _prepare() async {
    await _startingVariable();
    await getCustomer();
  }

  @override
  void initState() {
    super.initState();
    _prepare();
  }


  addKeranjang2(String valProduk) async {
    final response = await http.post(applink+"api_model.php?act=add_keranjang2",
        body: {
          "produk_id": valProduk,
          "emailuser" : widget.getEmail,
          "produk_branch" : widget.getLegalCode,
          "trans_comment" : _transcomment.text,
          "trans_jumlah" : valJumlahq.toString()
        }).timeout(Duration(seconds: 10),
        onTimeout: () {
          showsuccess("Connection Timeout");
          return;
        });
    Map data = jsonDecode(response.body);
    setState(() {
      if (data["message"].toString() == '0') {
        showsuccess("Mohon maaf produk tidak aktif");
        return false;
      } else if (data["message"].toString() == '1') {
        showsuccess("Mohon maaf stock habis");
        return false;
      } else if (data["message"].toString() == '2') {
        showsuccess("Mohon maaf stock tidak mencukupi");
        return false;
      }
    });

    Navigator.pop(context);
  }


  addKeranjang(String valProduk) async {
    final response = await http.post(applink+"api_model.php?act=add_keranjang", body: {
      "produk_id": valProduk,
      "emailuser" : widget.getEmail,
      "produk_branch" : widget.getLegalCode,
      "warehouse" : widget.getWarehouseKode
    }).timeout(Duration(seconds: 10),
        onTimeout: () {
          showsuccess("Connection Timeout");
          return;
        });
    Map data = jsonDecode(response.body);
    setState(() {
      if (data["message"].toString() == '0') {
        showsuccess("Produk tidak aktif");
        return false;
      } else if (data["message"].toString() == '1') {
        showsuccess("Mohon maaf stock habis");
        return false;
      } else if (data["message"].toString() == '2') {
        showsuccess("Mohon maaf stock tidak mencukupi");
        return false;
      }
    });
  }


  addKeranjangLain() async {
    final response = await http.post(applink+"api_model.php?act=add_keranjanglain",
        body: {
          "emailuser" : widget.getEmail,
          "produk_branch" : widget.getLegalCode,
          "produk_name" : _tambahanNama.text,
          "produk_harga" : _tambahanBiaya.text
        }).timeout(Duration(seconds: 10),
        onTimeout: () {
          showsuccess("Connection Timeout");
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
          "emailuser" : widget.getEmail,
          "produk_branch" : widget.getLegalCode
        }).timeout(Duration(seconds: 10),
        onTimeout: () {
          showsuccess("Connection Timeout");
          return;
        });
    Map data = jsonDecode(response.body);
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




  changeCustomer() {
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
                       Align(
                         alignment : Alignment.centerLeft,
                         child : DropdownButton(
                           itemHeight: null,
                           isExpanded: true,
                           hint: Text("Pilih Customer anda",style: TextStyle(
                               fontFamily: "VarelaRound", fontSize: 14
                           )),
                           value: selectedCust,
                           items: customerList.map((myitem){
                             return DropdownMenuItem(
                                 value: myitem['cust_no'],
                                 child:
                                 Expanded(
                                     child: Wrap(
                                         children: [
                                           Text(myitem['cust_nama'],style: GoogleFonts.nunito(fontWeight: FontWeight.bold,fontSize: 16,),
                                             overflow: TextOverflow.ellipsis,
                                             softWrap: false,),
                                         Padding(padding: const EdgeInsets.only(left: 5)),
                                         Text(myitem['cust_no'],style: GoogleFonts.nunito(fontSize: 13))
                                         ],
                                       )
                                 ),

                             );
                           }).toList(),
                           onChanged: (value) {
                             setState(() {
                               FocusScope.of(context).requestFocus(FocusNode());
                               selectedCust = value;
                             });
                           },
                         ),
                       )
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
                                  sortby = '1';
                                  _isVisible = false;
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
                                  _isVisible = false;
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
                                  _isVisible = false;
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
  void SelectedItem(BuildContext context, item) {
    switch (item) {
      case 0:
        hapus_trans();
        break;
      case 1:
        TambahBiayaAdd();
        break;

    }
  }

  @override
  Widget build(BuildContext context) {
     return WillPopScope(
       onWillPop: _onWillPop,
        child : Scaffold(
          appBar: new AppBar(
            elevation: 0.5,
            backgroundColor: Colors.white,
            leadingWidth: 38, // <-- Use this
            centerTitle: false,
            title: Text(
              "Jualan",
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
                  //_filterMe();
                  changeCustomer();
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 35,top : 16),
                  child: FaIcon(
                    FontAwesomeIcons.user,
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
                  padding: const EdgeInsets.only(right: 35,top : 16),
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
                  _filterMe();
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 22,top : 16),
                  child: FaIcon(
                    FontAwesomeIcons.list,
                    color: HexColor("#6b727c"),
                    size: 18,
                  ),
                ),
              ),


              Padding(
                padding : const EdgeInsets.only(right: 10),
                child :
                Theme(
                  data: Theme.of(context).copyWith(
                      textTheme: TextTheme().apply(bodyColor: Colors.white),
                      dividerColor: HexColor("#6b727c"),
                      iconTheme: IconThemeData(color: HexColor("#6b727c"),)),
                  child: PopupMenuButton<int>(
                    color: Colors.white,
                    padding: const EdgeInsets.only(top: 1),
                    itemBuilder: (context) => [
                      PopupMenuItem<int>(
                          value: 0,
                          child: Row(
                            children: [
                              FaIcon(FontAwesomeIcons.trashAlt,color: HexColor("#6b727c"),size: 16,
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Text("Clear Order", style : GoogleFonts.nunito(color: Colors.black))
                            ],
                          )),
                      PopupMenuItem<int>(
                          value: 0,
                          child: Row(
                            children: [
                              FaIcon(FontAwesomeIcons.plus,color: HexColor("#6b727c"),size: 16,
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Text("Tambah Biaya", style : GoogleFonts.nunito(color: Colors.black))
                            ],
                          )),
                      //PopupMenuDivider(),
                    ],
                    onSelected: (item) => SelectedItem(context, item),
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
                           // _isVisible = false;
                            //startSCreen();
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
                sortby != '' ?
                Padding(padding: const EdgeInsets.only(left: 20,top: 2,right: 15, bottom : 15),
                    child :
                    Align(
                        alignment: Alignment.centerLeft,
                        child :  FittedBox(
                            fit: BoxFit.none,
                            child :
                            RaisedButton(child :
                            Row(
                              children: [
                                Text(sortby == '1' ? 'Harga Terendah' : sortby == '2' ? 'Harga Tertinggi' : 'Produk Diskon', style: GoogleFonts.varelaRound(fontSize: 13),),
                                Padding(padding : const EdgeInsets.only(left  :10),
                                    child : FaIcon(FontAwesomeIcons.times,size: 12,))
                              ],
                            ),
                              elevation: 0,
                              onPressed: (){
                                setState(() {
                                  sortby = "";
                                  _isVisible = false;
                                  startSCreen();
                                });
                              },
                            ))
                    )

                )
                    :Container(),
          Visibility(
            visible: _isVisible,
                child :
                Expanded(
                  child: FutureBuilder(
                    future: getData(),
                    builder: (context, snapshot){
                      if (snapshot.data == null) {
                        return Center(
                            child: CircularProgressIndicator()
                        );
                      } else {
                        return snapshot.data == 0  || snapshot.data.length == 0 ?
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
                                      "Tidak ada data",
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
                                itemCount: snapshot.data == null ? 0 : snapshot.data.length,
                                padding: const EdgeInsets.only(top: 2,bottom: 80),
                                itemBuilder: (context, i)
                                    {
                                            return Column(
                                              children: [
                                                    InkWell(
                                                onTap: () {
                                                  snapshot.data[i]["j"].toString() == '0' ? ''
                                                      : snapshot.data[i]["j"].toString().substring(0,1) == '-' ? '' :
                                                  addKeranjang(snapshot.data[i]["i"].toString());
                                                  FocusScope.of(context).requestFocus(FocusNode());

                                                },
                                                onLongPress: (){
                                                  snapshot.data[i]["j"].toString() == '0' ? ''
                                                      : snapshot.data[i]["j"].toString().substring(0,1) == '-' ? '' :
                                                    setState(() {
                                                      valJumlahq = 1;
                                                      _transcomment.text = "";
                                                    });
                                                    FocusScope.of(context).requestFocus(FocusNode());
                                                    dialogAdd(snapshot.data[i]["a"], data[i]["i"].toString());
                                                    //myFocusNode.requestFocus();
                                                },
                                                      child :
                                                        Opacity(
                                                          opacity :
                                                          snapshot.data[i]["j"].toString() == '0' ? 0.5
                                                              : snapshot.data[i]["j"].toString().substring(0,1) == '-' ? 0.5 :1,
                                                          child :ListTile(
                                                            leading:
                                                            snapshot.data[i]["e"] != 0 ?
                                                            Badge(
                                                                badgeContent: Text(snapshot.data[i]["e"].toString(),
                                                                  style: TextStyle(color: Colors.white,fontSize: 12),),
                                                                child:  SizedBox(
                                                                    width: 60,
                                                                    height: 100,
                                                                    child: ClipRRect(
                                                                      borderRadius: BorderRadius.circular(6.0),
                                                                      child : CachedNetworkImage(
                                                                        fit: BoxFit.cover,
                                                                        imageUrl:
                                                                        snapshot.data[i]["d"] == '' ?
                                                                        applink+"photo/nomage.jpg"
                                                                            :
                                                                        applink+"photo/"+widget.getLegalCode+"/"+snapshot.data[i]["d"],
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
                                                                    snapshot.data[i]["d"] == '' ?
                                                                    applink+"photo/nomage.jpg"
                                                                        :
                                                                    applink+"photo/"+widget.getLegalCode+"/"+snapshot.data[i]["d"],
                                                                    progressIndicatorBuilder: (context, url,
                                                                        downloadProgress) =>
                                                                        CircularProgressIndicator(value:
                                                                        downloadProgress.progress),
                                                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                                                  ),
                                                                )),
                                                            title: Align(alignment: Alignment.centerLeft,
                                                              child: Text(snapshot.data[i]["a"],
                                                                  style: TextStyle(fontFamily: "VarelaRound",
                                                                      fontSize: 13,fontWeight: FontWeight.bold)),),
                                                            subtitle: Align(alignment: Alignment.centerLeft,
                                                                child:
                                                                snapshot.data[i]["e"] != 0 ?
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
                                                                              snapshot.data[i]["c"]), style: new TextStyle(
                                                                          decoration: TextDecoration.lineThrough,
                                                                          fontFamily: 'VarelaRound',fontSize: 12),),
                                                                      Padding(padding: const EdgeInsets.only(left: 5),child:
                                                                      Text("Rp "+
                                                                          NumberFormat.currency(
                                                                              locale: 'id', decimalDigits: 0, symbol: '').
                                                                          format(
                                                                              snapshot.data[i]["c"] - double.parse(snapshot.data[i]["f"])),
                                                                        style: new TextStyle(
                                                                            fontFamily: 'VarelaRound',fontSize: 12),),)
                                                                    ],
                                                                  ),
                                                                )
                                                                    :
                                                                Text("Rp "+
                                                                    NumberFormat.currency(
                                                                        locale: 'id', decimalDigits: 0, symbol: '').format(
                                                                        snapshot.data[i]["c"]), style: new TextStyle(
                                                                    fontFamily: 'VarelaRound',fontSize: 12),)
                                                            ),
                                                          )
                                                        )
                                                    ),
                                                Padding(padding: const EdgeInsets.only(top :5))
                                              ],
                                            );
                                    }
                                );

                      }
                    }

                  ),
                ))
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
                        itemCount: snapshot.data == null ? 0 : snapshot.data.length,
                        itemBuilder: (context, i) {
                          return  FittedBox(
                              child: Badge(
                                badgeContent: Text(
                                  snapshot.data[i]["a"].toString() == "null" ? "0" :
                                  snapshot.data[i]["a"].toString()
                                  ,style: TextStyle(color: Colors.white,fontSize: 14),),
                                position: BadgePosition(end: 0,top: 0),
                                child: FloatingActionButton(
                                  backgroundColor: HexColor(main_color),
                                  onPressed: () {
                                    snapshot.data[i]["a"].toString() == "null" ?
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
        )
     );
  }
}