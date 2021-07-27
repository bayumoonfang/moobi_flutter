


import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:moobi_flutter/Helper/app_helper.dart';
import 'package:moobi_flutter/Produk/page_produkdetailimage.dart';
import 'package:moobi_flutter/Produk/page_produkpenjualanpro.dart';
import 'package:moobi_flutter/Produk/page_produkstok.dart';
import 'package:moobi_flutter/Produk/page_produktransaksipro.dart';
import 'package:moobi_flutter/Produk/page_produkedit.dart';
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
  List data2;
  List data3;
  File galleryFile;
  String Base64;
  final _produksetdiskon = TextEditingController();
  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }

  bool isVisible = false;


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

  String getCountJual = '0';
  String getSatuan = "...";
  _getCountTerjual() async {
    final response = await http.get(applink+"api_model.php?act=count_terjual&itemn="+widget.idItem+"&branch="+getBranch);
    Map data = jsonDecode(response.body);
    setState(() {
      getCountJual = data["a"].toString();
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
      getSatuan = data["c"].toString();
    });
  }



  void _nonaktifproduk() {
    var url = applink+"api_model.php?act=action_nonaktifproduk";
    http.post(url,
        body: {
          "id": widget.idItem
        });
    showToast("Status produk berhasil dirubah", gravity: Toast.BOTTOM,
        duration: Toast.LENGTH_LONG);
    setState(() {
       _getDetail();
    });
  }

  _prepare() async {
    await _startingVariable();
    await _getCountTerjual();
    await _getDetail();
  }


  void doHapusImage() {
    var url = applink+"api_model.php?act=hapus_photoproduk";
    http.post(url,
        body: {
          "produk_id" : widget.idItem
        });
    showToast("Photo produk berhasil dihapus.. Silahkan refresh halaman ini", gravity: Toast.BOTTOM, duration: Toast.LENGTH_LONG);
    setState(() {
      _getDetail();
    });
    return;
  }




  alertHapusImage() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            //title: Text(),
            content: Container(
                width: double.infinity,
                height: 178,
                child: Column(
                  children: [
                    Align(alignment: Alignment.center, child:
                    Text("Konfirmasi", style: TextStyle(fontFamily: 'VarelaRound', fontSize: 20,
                        fontWeight: FontWeight.bold)),),
                    Padding(padding: const EdgeInsets.only(top: 15), child:
                    Align(alignment: Alignment.center, child: FaIcon(FontAwesomeIcons.trash,
                      color: Colors.redAccent,size: 35,)),),
                    Padding(padding: const EdgeInsets.only(top: 15), child:
                    Align(alignment: Alignment.center, child:
                    Text("Apakah anda yakin menghapus gambar ini ? ",
                        style: TextStyle(fontFamily: 'VarelaRound', fontSize: 12)),)),
                    Padding(padding: const EdgeInsets.only(top: 25), child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(child: OutlineButton(
                          onPressed: () {Navigator.pop(context);}, child: Text("Tidak"),)),
                        Expanded(child: OutlineButton(
                          borderSide: BorderSide(width: 1.0, color: Colors.redAccent),
                          onPressed: () {
                            doHapusImage();
                            Navigator.pop(context);
                          }, child: Text("Hapus", style: TextStyle(color: Colors.red),),)),
                      ],),)
                  ],
                )
            ),
          );
        });

  }




  alertHapus() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            //title: Text(),
            content: Container(
                width: double.infinity,
                height: 178,
                child: Column(
                  children: [
                    Align(alignment: Alignment.center, child:
                    Text("Konfirmasi", style: TextStyle(fontFamily: 'VarelaRound', fontSize: 20,
                        fontWeight: FontWeight.bold)),),
                    Padding(padding: const EdgeInsets.only(top: 15), child:
                    Align(alignment: Alignment.center, child: FaIcon(FontAwesomeIcons.trash,
                      color: Colors.redAccent,size: 35,)),),
                    Padding(padding: const EdgeInsets.only(top: 15), child:
                    Align(alignment: Alignment.center, child:
                    Text("Apakah anda yakin menghapus data ini ? ",
                        style: TextStyle(fontFamily: 'VarelaRound', fontSize: 12)),)),
                    Padding(padding: const EdgeInsets.only(top: 25), child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(child: OutlineButton(
                          onPressed: () {Navigator.pop(context);}, child: Text("Tidak"),)),
                        Expanded(child: OutlineButton(
                          borderSide: BorderSide(width: 1.0, color: Colors.redAccent),
                          onPressed: () {
                            doHapus();
                            Navigator.pop(context);
                          }, child: Text("Hapus", style: TextStyle(color: Colors.red),),)),
                      ],),)
                  ],
                )
            ),
          );
        });

  }


  doHapus() async {
      http.post(applink+"api_model.php?act=hapus_produk", body: {
        "produk_id" : widget.idItem
      });
      Navigator.pop(context);
      return false;
  }


  doSimpandiskon() async {
    if (_produksetdiskon.text == '') {
      showToast("Diskon tidak boleh kosong", gravity: Toast.BOTTOM,
          duration: Toast.LENGTH_LONG);
      return false;
    } else {
      final response = await http.post(applink+"api_model.php?act=set_diskonproduk", body: {
        "diskon_val": _produksetdiskon.text,
        "produk_id" : widget.idItem
      });
      Map dataqq = jsonDecode(response.body);
      setState(() {
        if (dataqq['message'] == '0') {
          showToast("Diskon tidak boleh kurang dari 0", gravity: Toast.BOTTOM,
              duration: Toast.LENGTH_LONG);
          return false;
        } else {
          setState(() {
            _getDetail();
          });
          Navigator.pop(context);
          showToast("Diskon berhasil dirubah", gravity: Toast.BOTTOM,
              duration: Toast.LENGTH_LONG);
          return false;
        }
      });
    }
  }

  dialogDiskon() {
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
                    Text("Setting", style: TextStyle(fontFamily: 'VarelaRound', fontSize: 20,
                        fontWeight: FontWeight.bold)),),
                    Padding(padding: const EdgeInsets.only(top: 15), child:
                    Align(alignment: Alignment.center, child:
                    Text("Masukkan diskon untuk produk ini ",
                        style: TextStyle(fontFamily: 'VarelaRound', fontSize: 12))
                    ),),
                    Padding(padding: const EdgeInsets.only(top: 15), child:
                    Align(alignment: Alignment.center, child:
                    TextFormField(
                        controller: _produksetdiskon,
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
                            doSimpandiskon();
                            //Navigator.pop(context);
                          }, child: Text("Simpan", style: TextStyle(color: Colors.red),),)),
                      ],),)
                  ],
                )
            ),
          );
        });


  }



  @override
  void initState() {
    super.initState();
    _prepare();
  }

  Future<bool> _onWillPop() async {
    Navigator.pop(context);
  }

  imageSelectorGallery() async {
    galleryFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    String fileName = galleryFile.path.split('/').last;
    Base64 = base64Encode((galleryFile.readAsBytesSync()));
    http.post(applink+"api_model.php?act=edit_produkphoto", body: {
      "produk_image": Base64,
      "produk_id": widget.idItem
    });
    showToast("Photo produk berhasil dirubah.. Silahkan refresh halaman ini", gravity: Toast.BOTTOM, duration: Toast.LENGTH_LONG);
    return false;
  }

  void _imgDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content:
              Container(
                  height: 120,
                  child:
                  SingleChildScrollView(
                    child :
                    Column(
                      children: [
                        getPhoto != '' ?
                        Column(
                          children: [
                            InkWell(
                              onTap: (){
                                Navigator.push(context, ExitPage(page: ProdukDetailImage(getPhoto.toString(), getBranch.toString())));
                              },
                              child: Align(alignment: Alignment.centerLeft,
                                child:    Text(
                                  "Lihat Photo",
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
                                alertHapusImage();
                                Navigator.pop(context);
                              },
                              child: Align(alignment: Alignment.centerLeft,
                                child:    Text(
                                  "Hapus Photo",
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
                                    FocusScope.of(context).requestFocus(FocusNode());
                                    imageSelectorGallery();
                                    Navigator.pop(context);
                                  });
                                },
                              child: Align(alignment: Alignment.centerLeft,
                                child:    Text(
                                  "Ganti Photo",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontFamily: 'VarelaRound',
                                      fontSize: 15),
                                ),),
                            )
                          ],
                        )
                        :
                            Column(
                              children: [
                                Align(alignment: Alignment.centerLeft,
                                  child:    Text(
                                    "Hapus Photo",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontFamily: 'VarelaRound',
                                        color: Colors.grey,
                                        fontSize: 15),
                                  ),),
                                Padding(padding: const EdgeInsets.only(top:15,bottom: 15,left: 4,right: 4),
                                  child: Divider(height: 5,),),
                                Align(alignment: Alignment.centerLeft,
                                  child:    Text(
                                    "Lihat Photo",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontFamily: 'VarelaRound',
                                        color: Colors.grey,
                                        fontSize: 15),
                                  ),),
                                Padding(padding: const EdgeInsets.only(top:15,bottom: 15,left: 4,right: 4),
                                  child: Divider(height: 5,),),
                                InkWell(
                                  onTap: (){
                                    setState(() {
                                      FocusScope.of(context).requestFocus(FocusNode());
                                      imageSelectorGallery();
                                      Navigator.pop(context);
                                    });
                                  },
                                  child: Align(alignment: Alignment.centerLeft,
                                    child:    Text(
                                      "Ganti Photo",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontFamily: 'VarelaRound',
                                          fontSize: 15),
                                    ),),
                                ),
                              ],
                            )
                      ],
                    ),
                  ))
          );
        });
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
              Padding(padding: const EdgeInsets.only(top: 18,right: 45),child:
              InkWell(
                onTap: (){alertHapus();},
                child: FaIcon(FontAwesomeIcons.trashAlt,color: Colors.white,size: 18,),
              ),),
              Padding(padding: const EdgeInsets.only(top: 20,right: 30),child:
              InkWell(
                onTap: (){dialogDiskon();},
                child: FaIcon(FontAwesomeIcons.percent,color: Colors.white,size: 16,),
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
                        onLongPress: (){_imgDialog();},
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
                            CachedNetworkImageProvider(applink+"photo/"+getBranch+"/"+getPhoto,
                            ),
                          ),
                        ),
                      ),
                      title: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(getName.toString(),style: TextStyle(
                            fontFamily: 'VarelaRound', fontSize: 18,
                            fontWeight: FontWeight.bold)),),
                      subtitle:
                      Container (
                        height: 30,
                        width: 100,
                        child :
                        getDiscount != '0' ?
                                      Row(
                                        children: [
                                          Text("Rp "+
                                              NumberFormat.currency(
                                                  locale: 'id', decimalDigits: 0, symbol: '').format(
                                                  double.parse(getHarga.toString())), style: new TextStyle(
                                              decoration: TextDecoration.lineThrough,
                                              fontFamily: 'VarelaRound',fontSize: 13),),
                                          Padding(padding: const EdgeInsets.only(left: 5),child:
                                          Text("Rp "+
                                              NumberFormat.currency(
                                                  locale: 'id', decimalDigits: 0, symbol: '').format(
                                                  double.parse(getHarga.toString())- double.parse(getDiscountVal.toString())), style: new TextStyle(
                                              fontFamily: 'VarelaRound',fontSize: 13, color: Colors.black,
                                              fontWeight: FontWeight.bold),),)
                                        ],
                                      )
                                          :
                                      Padding (
                                      padding : const EdgeInsets.only(top: 5)
                              ,child :Text("Rp "+
                              NumberFormat.currency(
                                  locale: 'id', decimalDigits: 0, symbol: '').format(
                                  double.parse(getHarga.toString())), style: new TextStyle(
                              fontFamily: 'VarelaRound',fontSize: 13,fontWeight: FontWeight.bold),)
                          )))
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
                        trailing: Container(
                          width: 90,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                    Text(getCountJual.toString() == "null" ? "0" : getCountJual.toString()
                                        ,style: TextStyle(fontWeight: FontWeight.bold
                                        , fontFamily: 'VarelaRound',fontSize: 22)),
                                    Padding(padding: const EdgeInsets.only(left:5),child:
                                    Text(getSatuan.toString(),style: TextStyle(fontWeight: FontWeight.bold
                                        , fontFamily: 'VarelaRound',fontSize: 12)),
                                )
                              ],
                            ),
                          )
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
                                  Container (
                                    width: 50,
                                    height: 13,
                                    child :
                                    Align(alignment: Alignment.centerRight,
                                        child: Text(getDiscount.toString()+" %",
                                            style: TextStyle(
                                                fontFamily: 'VarelaRound',
                                                fontSize: 14)
                                        ))
                                  ),
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


                  Padding(padding: const EdgeInsets.only(top: 10,left: 10,right: 25),
                    child: Column(
                      children: [

                        Padding(padding: const EdgeInsets.only(top: 5),
                            child: InkWell(
                              child: ListTile(
                                onTap: (){
                                  Navigator.push(context, ExitPage(page: ProdukStok(getItemNumb.toString(),
                                      getName.toString())));
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
                                onTap: (){
                                  Navigator.push(context, ExitPage(page: ProdukTransaksi(getItemNumb.toString())));
                                },
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
                                onTap: (){
                                  Navigator.push(context, ExitPage(page: ProdukPenjualan(getItemNumb.toString())));
                                },
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
                                     child:
                                     getStatusProduk == 'Aktif' ?
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
                                      ))
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
                          Navigator.pushReplacement(context, ExitPage(page: ProdukEdit(widget.idItem)));
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