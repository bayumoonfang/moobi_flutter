


import 'dart:async';
import 'dart:convert';
import 'dart:ui';


import 'package:cached_network_image/cached_network_image.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:moobi_flutter/Gudang/page_tambahprodukgudang.dart';
import 'package:moobi_flutter/Helper/api_link.dart';
import 'package:moobi_flutter/Helper/app_helper.dart';
import 'package:moobi_flutter/Helper/check_connection.dart';
import 'package:moobi_flutter/Helper/color_based.dart';
import 'package:moobi_flutter/Helper/page_route.dart';
import 'package:moobi_flutter/Helper/session.dart';
import 'package:moobi_flutter/Outlet/page_detailoutlet.dart';
import 'package:moobi_flutter/Outlet/page_outletinsert.dart';
import 'package:moobi_flutter/Outlet/page_outletmenuadd.dart';
import 'package:moobi_flutter/Produk/page_kategoriinsert.dart';
import 'package:moobi_flutter/Produk/page_metodebayarinsert.dart';
import 'package:moobi_flutter/page_home.dart';
import 'package:moobi_flutter/page_login.dart';

import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:unicorndial/unicorndial.dart';

import '../page_intoduction.dart';


class OutletMenuList extends StatefulWidget{
  final String getEmail;
  final String getLegalCode;
  final String getNamaUser;
  final String getidOutlet;
  final String gettipeMenu;
  const OutletMenuList(this.getEmail, this.getLegalCode, this.getNamaUser, this.getidOutlet, this.gettipeMenu);
  @override
  _OutletMenuList createState() => _OutletMenuList();
}


class _OutletMenuList extends State<OutletMenuList> {
  List data;
  bool _isvisible = true;


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


  _prepare() async {
    await _startingVariable();
  }


  @override
  void initState() {
    super.initState();
    _prepare();
  }


  showFlushBar(BuildContext context, String stringme) => Flushbar(
    // title:  "Hey Ninja",
    message:  stringme,
    shouldIconPulse: false,
    duration:  Duration(seconds: 5),
    backgroundColor: Colors.red,
    flushbarPosition: FlushbarPosition.BOTTOM ,
  )..show(context);


  showFlushBarsuccess(BuildContext context, String stringme) => Flushbar(
    // title:  "Hey Ninja",
    message:  stringme,
    shouldIconPulse: false,
    duration:  Duration(seconds: 5),
    backgroundColor: Colors.black,
    flushbarPosition: FlushbarPosition.BOTTOM ,
  )..show(context);


  final buangKeterangan = TextEditingController();
  final buangJumlah = TextEditingController();
  final tambahKeterangan = TextEditingController();
  final tambahJumlah = TextEditingController();
  final hargaVal = TextEditingController();


  void showerror(String txtError){
    showFlushBar(context, txtError);
    return;
  }

  void showsuccess(String txtError){
    showFlushBarsuccess(context, txtError);
    return;
  }

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);}



  Future<bool> _onWillPop() async {
    if(isDialOpen.value){
      isDialOpen.value = false;
      return false;
    }else{
      return true;
    }
    Navigator.pop(context);

  }



  startSCreen() async {
    var duration = const Duration(seconds: 1);
    return Timer(duration, () {
      setState(() {
        _isvisible = true;
      });
    });
  }


  String filter = "";
  String sortby = '0';
  Future<List> getData() async {
    http.Response response = await http.get(
        Uri.encodeFull(applink+"api_model.php?act=getdata_produkoutlet&"
            "legalcode="+widget.getLegalCode+
            "&store_id="+widget.getidOutlet+
            "&filtermedude="+widget.gettipeMenu+
            "&filter="+filter+"&getserver="+serverCode.toString()),
        headers: {"Accept":"application/json"});
    return json.decode(response.body);
  }




  String getMessage = "...";
  _doHapus (String valueParse2) async {
    final response = await http.get(applink+"api_model.php?act=action_hapusoutletproduk&id="+valueParse2.toString()
        +"&branch="+widget.getLegalCode+"&getserver="+serverCode.toString());
    Map data = jsonDecode(response.body);
    setState(() {
      if (data["message"].toString() == '1') {

        setState(() {
          getData();
        });
      } else {
        showerror("Gagal");
      }
    });
  }


  String valStatus = "false";
  _gantiStatus (String valueParse2) async {
    final response = await http.get(applink+"api_model.php?act=action_gantistatusprice&id="+valueParse2.toString()
        +"&branch="+widget.getLegalCode+"&getserver="+serverCode.toString());
    Map data = jsonDecode(response.body);
    setState(() {
      if (data["message"].toString() == '1') {

        setState(() {
          getData();
          showsuccess("Status produk di outlet berhasil diubah");
        });
      } else {
        showerror("Gagal");
      }
    });
  }



  FutureOr onGoBack(dynamic value) {
    getData();
    setState(() {});
  }

  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  _showDelete(String valueParse, String valueParse2) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            //title: Text(),
            content: Container(
                width: double.infinity,
                height: 205,
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
                    Text("Apakah anda yakin menghapus produk  '"+valueParse2+"'  di outlet ini ? ",
                      style: TextStyle(fontFamily: 'VarelaRound', fontSize: 12),textAlign: TextAlign.center,),)),
                    Padding(padding: const EdgeInsets.only(top: 25), child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(child: OutlineButton(
                          onPressed: () {Navigator.pop(context);}, child: Text("Tidak"),)),
                        Expanded(child: OutlineButton(
                          borderSide: BorderSide(width: 1.0, color: Colors.redAccent),
                          onPressed: () {
                           _doHapus(valueParse);
                            Navigator.pop(context);
                          }, child: Text("Hapus", style: TextStyle(color: Colors.red),),)),
                      ],),)
                  ],
                )
            ),
          );
        });
  }

  _doEditHarga (String valueParse, String valueParse2) async {
    Navigator.pop(context);
    if (hargaVal.text == "") {
      showerror("Harga tidak boleh kosong");
    }
    final response = await http.post(applink+"api_model.php?act=action_gantihargaoutlet",
        body: {
          "idPrice": valueParse.toString(),
          "addHarga" : hargaVal.text,
          "getserver" : serverCode},
        headers: {"Accept":"application/json"});
    Map data = jsonDecode(response.body);
    setState(() {
      if (data["message"].toString() == '1') {
        showsuccess("Harga "+valueParse2+" berhasil diganti");
      } else {
        showerror("Gagal");
      }
    });
  }

  _editpriceDialog(String valueParse,  String valueParse2) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            //title: Text(),
            content: Container(
                width: double.infinity,
                height: 200,
                child: Column(
                  children: [
                    Align(alignment: Alignment.center, child:
                    Text("Edit Harga", style: TextStyle(fontFamily: 'VarelaRound', fontSize: 20,
                        fontWeight: FontWeight.bold)),),
                    Padding(padding: const EdgeInsets.only(top: 15), child:
                    Align(alignment: Alignment.center, child:
                    Text("Edit Harga "+valueParse2,
                      style: TextStyle(fontFamily: 'VarelaRound', fontSize: 12),textAlign: TextAlign.center,),)),
                    Padding(padding: const EdgeInsets.only(top: 15), child:
                    Align(alignment: Alignment.center, child:
                    Container(
                      child : TextFormField(
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                            fontFamily: 'VarelaRound', fontSize: 14),
                        controller: hargaVal,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left:15,top:5,bottom:5,right: 15),
                          hintText: "Harga Jual",
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                              color: HexColor("#602d98"),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                              color: HexColor("#dbd0ea"),
                              width: 1.0,
                            ),
                          ),

                        ),
                      ),
                    )
                    )),
                    Padding(padding: const EdgeInsets.only(top: 25), child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(child: OutlineButton(
                          onPressed: () {Navigator.pop(context);}, child: Text("Tutup"),))
                        , Expanded(child: RaisedButton(
                          color: HexColor(main_color),
                          onPressed: () {
                            _doEditHarga(valueParse, valueParse2);
                          }, child: Text("Post", style: TextStyle(color: Colors.white),),)),
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
      onWillPop: _onWillPop,
      child: Scaffold(
          appBar: new AppBar(
            backgroundColor: HexColor("#602d98"),
            title: Text(
              "Daftar Produk "+widget.gettipeMenu,
              style: GoogleFonts.varelaRound(fontSize: 15),
            ),
            leading: Builder(
              builder: (context) => IconButton(
                  icon: new FaIcon(FontAwesomeIcons.times,size: 20,),
                  color: Colors.white,
                  onPressed: () => {
                    Navigator.pop(context)
                  }),
            ),
          ),
          body: Container(
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
                          hintText: 'Cari Produk '+widget.gettipeMenu+'...',
                        ),
                      ),
                    )
                ),
                Padding(padding: const EdgeInsets.only(top: 10),),
                Expanded(
                    child: FutureBuilder(
                      future: getData(),
                      builder: (context, snapshot){
                        if (snapshot.data == null) {
                          return Center(
                              child: CircularProgressIndicator()
                          );
                        } else {
                          return snapshot.data == 0 || snapshot.data.length == 0 ?
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
                            padding: const EdgeInsets.only(top: 10,bottom: 80,left: 5,right: 5),
                            itemBuilder: (context, i) {
                              return Column(
                                children: [
                                 InkWell(
                                   onTap: () {
                                    /* FocusScope.of(context).requestFocus(FocusNode());
                                     _editpriceDialog(snapshot.data[i]["g"].toString(), snapshot.data[i]["b"].toString());
                                     setState(() {
                                       hargaVal.text = snapshot.data[i]["e"].toString();
                                     });*/
                                     showModalBottomSheet(
                                         shape: RoundedRectangleBorder(
                                           borderRadius: BorderRadius.only(
                                               topLeft: Radius.circular(15),
                                               topRight: Radius.circular(15),
                                           ),
                                         ),
                                         context: context,
                                         builder: (context) {
                                           return Padding(
                                             padding: const EdgeInsets.only(left: 5,right: 15,top: 15),
                                             child :  Column(
                                               mainAxisSize: MainAxisSize.min,
                                               children: <Widget>[
                                                 Padding(padding: const EdgeInsets.only(top: 5,right: 25,left: 15),
                                                 child : Align(
                                                   alignment : Alignment.centerLeft,
                                                   child : Text(snapshot.data[i]["b"].toString(), style : GoogleFonts.varelaRound(fontSize: 18,
                                                       fontWeight: FontWeight.bold))
                                                 )
                                                 ),
                                                 Padding(padding: const EdgeInsets.only(top: 15,right: 25,left: 15),
                                                     child: InkWell(
                                                       child: ListTile(
                                                         dense: true,
                                                         minLeadingWidth: 20,
                                                         horizontalTitleGap: 15,
                                                         contentPadding: EdgeInsets.all(1),
                                                         onTap: (){
                                                           //Navigator.push(context, ExitPage(page: ProfileUbahNama(widget.getEmail, val_namauser.toString(), widget.getUserId))).then(onGoBack);
                                                         },
                                                         leading: FaIcon(FontAwesomeIcons.tags,color: HexColor("#73767d"),size: 18,),
                                                         title: Text("Ubah Harga",style: TextStyle(
                                                             color: Colors.black, fontFamily: 'VarelaRound',fontSize: 13)),
                                                           trailing: Opacity(
                                                             opacity : 0.5,
                                                             child : FaIcon(FontAwesomeIcons.angleRight,color: HexColor(third_color),),
                                                           )
                                                       ),
                                                     )
                                                 ),
                                                  Padding(padding: const EdgeInsets.only(top: 2,right: 15,left: 15),
                                                  child : Divider(height: 3,)),
                                                 Padding(padding: const EdgeInsets.only(top: 5,right: 25,left: 15),
                                                   child: InkWell(
                                                         child: ListTile(
                                                           dense: true,
                                                           minLeadingWidth: 20,
                                                           horizontalTitleGap: 20,
                                                           contentPadding: EdgeInsets.all(1),
                                                           onTap: (){
                                                             //Navigator.push(context, ExitPage(page: ProfileUbahNama(widget.getEmail, val_namauser.toString(), widget.getUserId))).then(onGoBack);
                                                           },
                                                           leading: FaIcon(FontAwesomeIcons.trash,color: HexColor("#73767d"),size: 18,),
                                                           title: Text("Hapus Produk dari Outlet",style: TextStyle(
                                                               color: Colors.black, fontFamily: 'VarelaRound',fontSize: 13)),
                                                         ),
                                                       )
                                                   ),
                                                 Padding(padding: const EdgeInsets.only(top: 2,right: 15,left: 15),
                                                     child : Divider(height: 3,)),


                                               ],
                                             )
                                           );
                                         });
                                   },
                                   child : Opacity(
                                     opacity : snapshot.data[i]["d"].toString() == 'Aktif' ? 1 : 0.4,
                                     child : ListTile(
                                         leading: SizedBox(
                                             width: 45,
                                             height: 45,
                                             child: ClipRRect(
                                               borderRadius: BorderRadius.circular(6.0),
                                               child : CachedNetworkImage(
                                                 fit: BoxFit.cover,
                                                 imageUrl:
                                                 snapshot.data[i]["c"] == '' ?
                                                 applink+"photo/nomage.jpg"
                                                     :
                                                 applink+"photo/"+snapshot.data[i]["f"]+"/"+snapshot.data[i]["c"],
                                                 progressIndicatorBuilder: (context, url,
                                                     downloadProgress) =>
                                                     CircularProgressIndicator(value:
                                                     downloadProgress.progress),
                                                 errorWidget: (context, url, error) =>
                                                     Icon(Icons.error),
                                               ),
                                             )),
                                       title: Align(alignment: Alignment.centerLeft,
                                         child: Opacity(
                                             opacity: 0.8,
                                             child : Text("#"+snapshot.data[i]["a"],
                                                 style: GoogleFonts.varelaRound(fontSize: 11))
                                         ),
                                       ),
                                         subtitle: Align(
                                           alignment: Alignment.centerLeft,
                                           child: Column(
                                             children: [
                                               Align(
                                                 alignment: Alignment.centerLeft,
                                                 child: Padding(padding: const EdgeInsets.only(top:1), child :
                                                 Text(snapshot.data[i]["b"].toString(),
                                                     style: GoogleFonts.varelaRound(fontSize: 13,fontWeight: FontWeight.bold,
                                                         color: Colors.black))),
                                               ),
                                               Align(
                                                 alignment: Alignment.centerLeft,
                                                 child: Padding(padding: const EdgeInsets.only(top:2), child :
                                                 Row(
                                                   children: [
                                                     Opacity(
                                                       opacity : 0.8,
                                                       child : Text(snapshot.data[i]["i"], style: GoogleFonts.varelaRound(fontSize: 12,color:Colors.black),),
                                                     )
                                                   ],
                                                 )

                                                 ),
                                               )
                                             ],
                                           ),
                                         ),
                                         trailing: Text("Rp "+
                                             NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: '').
                                             format(snapshot.data[i]["e"]), style: GoogleFonts.varelaRound(fontSize: 13,color:Colors.black),),
                                     )
                                   )
                                 ),


                                  Container(
                                    width: double.infinity,
                                    height: 18,
                                    padding: const EdgeInsets.only(left:15,right:15),
                                  )
                                ],
                              );
                            },
                          );
                        }
                      },
                    )
                ),
              ],
            ),
          ),
          floatingActionButton: UnicornDialer(
              backgroundColor: Color.fromRGBO(255, 255, 255, 0.6),
              parentButtonBackground: HexColor("#2196f3"),
              orientation: UnicornOrientation.VERTICAL,
              parentButton: Icon(Icons.add),
              //finalButtonIcon: Icon(Icons.edit),
              childButtons: [
                UnicornButton(
                   // hasLabel: true,
                   // labelText: "Tambahkan Produk",
                   // labelFontSize: 12,
                    currentButton: FloatingActionButton(
                        onPressed: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          Navigator.push(context, MaterialPageRoute(builder: (context) => OutletMenuAdd(widget.getidOutlet, widget.getEmail,  widget.getLegalCode, widget.getNamaUser, widget.gettipeMenu)));
                        },
                        //heroTag: "airplane",
                        backgroundColor: HexColor(main_color),
                        mini: true,
                        child: FaIcon(FontAwesomeIcons.plus,size: 20,),)),
               UnicornButton(
                   //hasLabel: true,
                   //labelText: "Copy dari outlet",
                    currentButton: FloatingActionButton(
                        backgroundColor: HexColor(main_color),
                        mini: true,
                        child: FaIcon(FontAwesomeIcons.copy,size: 20,),))
              ]),
      ),
    );

  }
}