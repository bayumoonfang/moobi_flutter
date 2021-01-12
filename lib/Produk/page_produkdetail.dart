


import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:moobi_flutter/Produk/page_produkdetailimage.dart';
import 'package:moobi_flutter/Produk/page_produkstok.dart';
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
  List data;
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

  String getBranch = "...";
  _getBranch() async {
    final response = await http.get(applink+"api_model.php?act=userdetail&id="+getEmail.toString());
    Map data = jsonDecode(response.body);
    setState(() {
      getBranch = data["c"].toString();
    });
  }

  String getCountJual = '0';
  String getSatuan = "...";
  _getCountTerjual() async {
    final response = await http.get(applink+"api_model.php?act=count_terjual&itemn="+widget.idItem+"&branch="+getBranch.toString());
    Map data = jsonDecode(response.body);
    setState(() {
      getCountJual = data["a"].toString();
      getSatuan = data["b"].toString();
    });
  }



  String getName = '...';
  String getPhoto = '...';
  String getDiscount = '0';
  String getDiscountVal = '0';
  String getHarga = '0';
  String getItemNumb = '0';
  String getKategori = "...";
  String getStatusProduk = "...";
  String getDateCreated = "...";
  _getDetail() async {
    final response = await http.get(applink+"api_model.php?act=item_detail&id="+widget.idItem);
    Map data = jsonDecode(response.body);
    setState(() {
      getName = data["a"].toString();
      getPhoto = data["g"].toString();
      getDiscount = data["b"].toString();
      getDiscountVal = data["k"].toString();
      getHarga = data["d"].toString();
      getItemNumb = data["l"].toString();
      getKategori = data["i"].toString();
      getStatusProduk = data["f"].toString();
      getDateCreated = data["h"].toString();
    });
  }


  Future<List> getData() async {
    http.Response response = await http.get(
        Uri.encodeFull(applink+"api_model.php?act=getdata_statusproduk&id="+widget.idItem),
        headers: {"Accept":"application/json"}
    );
    setState((){
      data = json.decode(response.body);
    });
  }

  void _nonaktifproduk() {
    var url = applink+"api_model.php?act=action_nonaktifproduk";
    http.post(url,
        body: {
          "id": widget.idItem
        });
  }




  _prepare() async {
    await _connect();
    await _session();
    await _getBranch();
    await _getCountTerjual();
    await _getDetail();
  }


  @override
  void initState() {
    super.initState();
    _prepare();
  }

  Future<bool> _onWillPop() async {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
      return WillPopScope(
        onWillPop: _onWillPop,
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
                      leading:  InkWell(
                        onTap: () {
                          Navigator.push(context, ExitPage(page: ProdukDetailImage(getPhoto.toString())));
                        },
                        child: CircleAvatar(
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
                                , fontFamily: 'VarelaRound',fontSize: 13)),),
                        ),
                        trailing: Text(getCountJual.toString()+" "+getSatuan.toString(),style: TextStyle(fontWeight: FontWeight.bold
                            , fontFamily: 'VarelaRound',fontSize: 15))
                    ),),
                  Padding(padding: const EdgeInsets.only(top :0),
                    child: Container(
                      height: 10,
                      width: double.infinity,
                      color: HexColor("#f4f4f4"),
                    ),),

                  Padding(padding: const EdgeInsets.only(top: 20,left: 25),
                    child: Column(
                      children: [
                        Align(alignment: Alignment.centerLeft,child: Text("Informasi Produk",style: TextStyle(
                            color: Colors.black, fontFamily: 'VarelaRound',fontSize: 15,
                            fontWeight: FontWeight.bold)),),
                        Padding(padding: const EdgeInsets.only(top: 10,right: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .spaceBetween,
                            children: [
                              Text(
                                "ID Produk",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: 'VarelaRound',
                                    fontSize: 13),
                              ),
                              Text(getItemNumb.toString(),
                                  style: TextStyle(
                                      fontFamily: 'VarelaRound',
                                      fontSize: 14)),
                            ],
                          ),),

                        Padding(padding: const EdgeInsets.only(top: 10,right: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .spaceBetween,
                            children: [
                              Text(
                                "Diskon",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: 'VarelaRound',
                                    fontSize: 13),
                              ),
                              Text(getDiscount.toString()+"%",
                                  style: TextStyle(
                                      fontFamily: 'VarelaRound',
                                      fontSize: 14)),
                            ],
                          ),),

                        Padding(padding: const EdgeInsets.only(top: 10,right: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .spaceBetween,
                            children: [
                              Text(
                                "Satuan",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: 'VarelaRound',
                                    fontSize: 13),
                              ),
                              Text(getSatuan.toString() == null ? "..." : getSatuan.toString(),
                                  style: TextStyle(
                                      fontFamily: 'VarelaRound',
                                      fontSize: 14)),
                            ],
                          ),),

                        Padding(padding: const EdgeInsets.only(top: 10,right: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .spaceBetween,
                            children: [
                              Text(
                                "Kategori",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: 'VarelaRound',
                                    fontSize: 13),
                              ),
                              Text(getKategori.toString(),
                                  style: TextStyle(
                                      fontFamily: 'VarelaRound',
                                      fontSize: 14)),
                            ],
                          ),),


                        Padding(padding: const EdgeInsets.only(top: 10,right: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .spaceBetween,
                            children: [
                              Text(
                                "Dibuat Pada",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: 'VarelaRound',
                                    fontSize: 13),
                              ),
                              Text(getDateCreated.toString(),
                                  style: TextStyle(
                                      fontFamily: 'VarelaRound',
                                      fontSize: 14)),
                            ],
                          ),),

                      ],
                    ),),



                  Padding(padding: const EdgeInsets.only(top :20),
                    child: Container(
                      height: 10,
                      width: double.infinity,
                      color: HexColor("#f4f4f4"),
                    ),),


                  Padding(padding: const EdgeInsets.only(top: 20,left: 10,right: 25),
                    child: Column(
                      children: [

                        Padding(padding: const EdgeInsets.only(top: 5),
                            child: InkWell(
                              child: ListTile(
                                onTap: (){
                                  Navigator.push(context, ExitPage(page: ProdukStok(getItemNumb.toString())));
                                },
                                title: Text("Stok Produk",style: TextStyle(
                                    color: Colors.black, fontFamily: 'VarelaRound',fontSize: 15,
                                    fontWeight: FontWeight.bold)),
                                trailing: FaIcon(FontAwesomeIcons.angleRight,color: HexColor("#594d75"),size: 15,),
                              ),
                            )
                        ),
                        Padding(padding: const EdgeInsets.only(top: 0,left: 15),
                          child: Divider(height: 3,),),
                        Padding(padding: const EdgeInsets.only(top: 5),
                            child: InkWell(
                              child: ListTile(
                                onTap: (){},
                                title: Text("Transaksi Produk",style: TextStyle(
                                    color: Colors.black, fontFamily: 'VarelaRound',fontSize: 15,
                                    fontWeight: FontWeight.bold)),
                                trailing: FaIcon(FontAwesomeIcons.angleRight,color: HexColor("#594d75"),size: 15,),
                              ),
                            )
                        ),

                        Padding(padding: const EdgeInsets.only(top: 0,left: 15),
                          child: Divider(height: 3,),),
                        Padding(padding: const EdgeInsets.only(top: 5),
                            child: InkWell(
                              child: ListTile(
                                onTap: (){},
                                title: Text("Transaksi Penjualan",style: TextStyle(
                                    color: Colors.black, fontFamily: 'VarelaRound',fontSize: 15,
                                    fontWeight: FontWeight.bold)),
                                trailing: FaIcon(FontAwesomeIcons.angleRight,color: HexColor("#594d75"),size: 15,),
                              ),
                            )
                        ),


                        Padding(padding: const EdgeInsets.only(top: 0,left: 15),
                          child: Divider(height: 3,),),

                        Padding(padding: const EdgeInsets.only(top: 5),
                            child: InkWell(
                              child: ListTile(
                                onTap: (){
                                  _nonaktifproduk();
                                },
                                title: Text("Status",style: TextStyle(
                                    color: Colors.black, fontFamily: 'VarelaRound',fontSize: 15,
                                    fontWeight: FontWeight.bold)),
                                  subtitle: Opacity(
                                      opacity: 0.6,
                                      child: Padding(
                                          padding: const EdgeInsets.only(top: 5),
                                          child: Text("Jika statusnya tidak aktif, anda tidak bisa menjual barang ini",style: TextStyle(
                                              color: Colors.black, fontFamily: 'VarelaRound',fontSize: 13),
                                          )
                                      )
                                  ),
                                trailing:
                                   Container(
                                     alignment: Alignment.centerRight,
                                     width: 50,
                                     child: FutureBuilder(
                                       future: getData(),
                                       builder: (context, snapshot) {
                                         if (data == null) {
                                            return Container(
                                              width: 10,
                                              height: 10
                                            );
                                         } else {
                                           return ListView.builder(
                                             itemCount: 1,
                                             itemBuilder: (context, i) {
                                               return data[i]["a"] == 'Aktif' ?
                                                 Padding(padding: const EdgeInsets.only(top: 10),child:
                                                 Align(
                                                   alignment: Alignment
                                                       .centerRight,
                                                   child: FaIcon(
                                                     FontAwesomeIcons.toggleOn,
                                                     size: 30,
                                                     color: HexColor("#02ac0e"),),
                                                 ),)
                                                   :
                                               Padding(padding: const EdgeInsets.only(top: 10),child:
                                               Align(
                                                 alignment: Alignment
                                                     .centerRight,
                                                 child: FaIcon(
                                                   FontAwesomeIcons.toggleOff,
                                                   size: 30,),
                                               ));
                                             },
                                           );
                                         }
                                       },
                                     ),
                                   )
                              ),
                            )
                        ),

                      ],
                    ),),

                  Container(
                    padding: const EdgeInsets.only(top:30,left: 55,right: 55,bottom: 50),
                    child: Container(
                      width: double.infinity,
                      height: 40,
                      child: RaisedButton(
                        elevation: 0,
                        onPressed: (){
                          //signOut();
                        },
                        color: HexColor("#dbd0ea"),
                        shape: RoundedRectangleBorder(side: BorderSide(
                            color: Colors.black,
                            width: 0.1,
                            style: BorderStyle.solid
                        ),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        child: Opacity(
                          opacity: 0.7,
                          child: Text("Edit Produk",style: TextStyle(
                              color: Colors.black, fontFamily: 'VarelaRound')),
                        )
                      ),
                    ),
                  )


                ],
              ),
            ),
          ),
        ),
      );

  }
}