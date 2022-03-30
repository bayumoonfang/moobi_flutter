


import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:moobi_flutter/Helper/app_helper.dart';
import 'package:moobi_flutter/Helper/color_based.dart';
import 'package:moobi_flutter/Helper/setting_apps.dart';
import 'package:moobi_flutter/Produk/page_produkdetailimage.dart';
import 'package:moobi_flutter/Produk/page_produkedit.dart';
import 'package:moobi_flutter/helper/api_link.dart';
import 'package:moobi_flutter/helper/check_connection.dart';
import 'package:moobi_flutter/helper/page_route.dart';
import 'package:moobi_flutter/helper/session.dart';
import 'package:moobi_flutter/page_login.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

import '../page_intoduction.dart';


class ProdukDetail extends StatefulWidget {
  final String getEmail;
  final String getLegalCode;
  final String getItemNumber;
  final String getNamaUser;
  final String getTipe;

  const ProdukDetail(this.getEmail,this.getLegalCode,this.getItemNumber, this.getNamaUser, this.getTipe);
  @override
  _ProdukDetailState createState() => _ProdukDetailState();
}


class _ProdukDetailState extends State<ProdukDetail>  {
  List data;
  List data2;
  List data3;
  File galleryFile;
  String Base64;
  final _produksetdiskon = TextEditingController();

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);}

  //=============================================================================
  String serverName = '';
  String serverCode = '';
  _startingVariable() async {
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      showToast("Koneksi terputus..", gravity: Toast.CENTER,duration:
      Toast.LENGTH_LONG);}});
    await AppHelper().getSession().then((value){
      setState(() {serverName = value[11];serverCode = value[12];});});
    await AppHelper().cekServer(widget.getEmail).then((value){
      if(value[0] == '0') {Navigator.pushReplacement(context, ExitPage(page: Introduction()));}});
    await AppHelper().cekLegalUser(widget.getEmail.toString(), serverCode.toString()).then((value){
      if(value[0] == '0') {Navigator.pushReplacement(context, ExitPage(page: Introduction()));}});
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

  String getCountJual = '0';
  String getSatuan = "...";
  _getCountTerjual() async {
    final response = await http.get(applink+"api_model.php?act=count_terjual&itemn="+widget.getItemNumber+"&branch="
        +widget.getLegalCode+"&getserver="+serverCode.toString());
    Map data = jsonDecode(response.body);
    setState(() {
      getCountJual = data["a"].toString();
    });
  }



  String getName = '...';
  String getPhoto = '...';
  String getItemNumb = '0';
  String getKategori = "...";
  String getStatusProduk = "...";
  String getDateCreated = "...";
  String getTipe = "...";
  _getDetail() async {
    final response = await http.get(applink+"api_model.php?act=item_detail&id="+widget.getItemNumber+"&getserver="+serverCode.toString());
    Map data = jsonDecode(response.body);
    setState(() {
      getName = data["a"].toString();
      getPhoto = data["g"].toString();
      getItemNumb = data["l"].toString();
      getKategori = data["i"].toString();
      getStatusProduk = data["f"].toString();
      getDateCreated = data["h"].toString();
      getSatuan = data["c"].toString();
      getTipe = data["e"].toString();
    });
  }



  void _nonaktifproduk() async {
    EasyLoading.show(status: easyloading_text);
    final response = await http.post(applink+"api_model.php?act=action_nonaktifproduk", body: {
      "id": widget.getItemNumber,
      "branch" : widget.getLegalCode,
      "getserver" : serverCode
    });
    Map data = jsonDecode(response.body);
    setState(() {
      EasyLoading.dismiss();
      if (data["message"].toString() == '1') {
        showsuccess("Status produk berhasil dirubah");
        setState(() {
          _getDetail();
        });
        return false;
      } else {
        showsuccess("Status gagal dirubah");
        return false;
      }
    });
  }

  _prepare() async {
    await _startingVariable();
    await _getCountTerjual();
    await _getDetail();
    EasyLoading.dismiss();
  }


  void doHapusImage() async {
    EasyLoading.show(status: easyloading_text);
    var url = applink+"api_model.php?act=hapus_photoproduk";
    final response = await http.post(url,
        body: {
          "produk_id" : widget.getItemNumber,
          "produk_branch" : widget.getLegalCode,
          "getserver" : serverCode
        });
    Map data = jsonDecode(response.body);
    setState(() {
      if (data["message"].toString() == '1') {
        EasyLoading.dismiss();
        showsuccess("Photo produk berhasil dihapus..");
        setState(() {
          _getDetail();
          Navigator.pop(context);
        });

        return false;
      }
    });

  }

  FutureOr onGoBack(dynamic value) {
    setState(() {
      _getDetail();
    });
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
    EasyLoading.show(status: easyloading_text);
    final response = await http.post(applink+"api_model.php?act=hapus_produk", body: {
        "produk_id" : widget.getItemNumber,
      "produk_branch" : widget.getLegalCode,
      "nama_user" : widget.getNamaUser,
      "getserver" : serverCode
      });
    Map data = jsonDecode(response.body);
    setState(() {
      if (data["message"].toString() == '1') {
        EasyLoading.dismiss();
        Navigator.pop(context);
        return false;
      }
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
    EasyLoading.show(status: easyloading_text);
    galleryFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    String fileName = galleryFile.path.split('/').last;
    Base64 = base64Encode((galleryFile.readAsBytesSync()));
    final response = await http.post(applink+"api_model.php?act=edit_produkphoto", body: {
      "produk_image": Base64,
      "produk_id": widget.getItemNumber,
      "produk_branch" : widget.getLegalCode,
      "getserver" : serverCode
    });
    Map data = jsonDecode(response.body);
    setState(() {
      EasyLoading.dismiss();
      if (data["message"].toString() == '1') {
        showsuccess("Photo produk berhasil dirubah.. ");
        setState(() {
          _getDetail();
        });
        return false;
      }
    });
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
                            Padding(padding: const EdgeInsets.only(top:5,bottom: 15,left: 4,right: 4)),
                            InkWell(
                              onTap: (){
                                alertHapusImage();
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
                            Padding(padding: const EdgeInsets.only(top:5,bottom: 15,left: 4,right: 4)),
                            InkWell(
                              child: Align(alignment: Alignment.centerLeft,
                                child:   Opacity(
                                  opacity: 0.4,
                                  child :  Text(
                                    "Hapus Photo",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontFamily: 'VarelaRound',
                                        fontSize: 15),
                                  )
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
                  icon: new FaIcon(FontAwesomeIcons.times,color: Colors.white,size: 18,),
                  color: Colors.white,
                  onPressed: () => {
                    Navigator.pop(context)
                  }),
            ),
            actions: [
              Padding(padding: const EdgeInsets.only(top: 18,right: 35),child:
              InkWell(
                onTap: (){alertHapus();},
                child: FaIcon(FontAwesomeIcons.trashAlt,color: Colors.white,size: 18,),
              ),),
            ],
            title: Text(
              "Detail "+widget.getTipe,
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
                      leading:  CircleAvatar(
                          radius: 30,
                          backgroundColor: HexColor("#602d98"),
                          child: CircleAvatar(
                            child : InkWell(
                              onLongPress: (){_imgDialog();},
                              onTap: (){
                                getPhoto.toString() != '' ?
                                    Navigator.push(context, ExitPage(page: ProdukDetailImage(getPhoto.toString(), widget.getLegalCode.toString())))
                                :
                               "";

                                },
                            ),
                            backgroundColor: Colors.white,
                            radius: 27,
                            backgroundImage:
                            getPhoto == '' ?
                            CachedNetworkImageProvider(applink+"photo/nomage.jpg")
                                :
                            CachedNetworkImageProvider(applink+"photo/"+widget.getLegalCode+"/"+getPhoto.toString(),
                            ),
                          ),
                        ),
                      title: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(getName.toString(),style: TextStyle(
                            fontFamily: 'VarelaRound', fontSize: 18,
                            fontWeight: FontWeight.bold)),),
                    )
                    ),
                  Padding(padding: const EdgeInsets.only(left: 15,right: 15,top: 10),
                    child: Divider(height: 3,),),
                  Padding(padding: const EdgeInsets.only(left: 15,right: 15),
                    child: ListTile(
                        title: Opacity(
                          opacity: 0.6,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(widget.getTipe+" Terjual",style: TextStyle(fontWeight: FontWeight.bold
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
                        Align(alignment: Alignment.centerLeft,child: Text("Informasi "+widget.getTipe,style: TextStyle(
                            color: Colors.black, fontFamily: 'VarelaRound',fontSize: 15,
                            fontWeight: FontWeight.bold)),),

                        Padding(padding: const EdgeInsets.only(top: 10,right: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .spaceBetween,
                            children: [
                              Text(
                                "Item Number",
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
                                "Tipe",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: 'VarelaRound',
                                    fontSize: 13),
                              ),
                              Text(getTipe.toString(),
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
                          EasyLoading.show(status: easyloading_text);
                          Navigator.push(context, ExitPage(page: ProdukEdit(widget.getEmail, widget.getLegalCode,widget.getItemNumber, widget.getNamaUser))).then(onGoBack);
                        },
                        color:
                        //HexColor("#622df7")
                         HexColor(main_color),
                        shape: RoundedRectangleBorder(side: BorderSide(
                            color: Colors.black,
                            width: 0.1,
                            style: BorderStyle.solid
                        ),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        child: Text("Edit Produk",style: TextStyle(
                            color: Colors.white, fontFamily: 'VarelaRound')),
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