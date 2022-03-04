


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
import 'package:moobi_flutter/Outlet/page_tambahprodukoutlet.dart';
import 'package:moobi_flutter/Outlet/page_tambahserviceoutlet.dart';
import 'package:moobi_flutter/Produk/page_kategoriinsert.dart';
import 'package:moobi_flutter/Setting/page_metodebayarinsert.dart';
import 'package:moobi_flutter/page_home.dart';
import 'package:moobi_flutter/page_login.dart';

import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

import '../page_intoduction.dart';


class OutletService extends StatefulWidget{
  final String getEmail;
  final String getLegalCode;
  final String getNamaUser;
  final String getidOutlet;
  const OutletService(this.getEmail, this.getLegalCode, this.getNamaUser, this.getidOutlet);
  @override
  _OutletService createState() => _OutletService();
}


class _OutletService extends State<OutletService> {
  List data;
  bool _isvisible = true;


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
    Navigator.pop(context);}



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
            "&filtermedude=Service"
            "&filter="+filter),
        headers: {"Accept":"application/json"});
    return json.decode(response.body);
  }




  String getMessage = "...";
  _doHapus (String valueParse2) {
    http.get(applink+"api_model.php?act=action_hapusoutletproduk&id="+valueParse2.toString()
        +"&branch="+widget.getLegalCode);
    setState(() {
      getData();
    });
  }





  FutureOr onGoBack(dynamic value) {
    getData();
    setState(() {});
  }


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
                    Text("Apakah anda yakin menonaktifkan jasa '"+valueParse2+"'  di outlet ini ? ",
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




  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          appBar: new AppBar(
            backgroundColor: HexColor("#602d98"),
            title: Text(
              "Daftar jasa dalam outlet",
              style: TextStyle(
                  color: Colors.white, fontFamily: 'VarelaRound', fontSize: 16),
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
                          hintText: 'Cari Jasa...',
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
                            padding: const EdgeInsets.only(top: 2,bottom: 80,left: 5,right: 5),
                            itemBuilder: (context, i) {
                              return Column(
                                children: [

                                 InkWell(
                                   onTap: () {
                                     FocusScope.of(context).requestFocus(FocusNode());
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
                                                 Padding(padding: const EdgeInsets.only(top: 10,right: 25,left: 15),
                                                   child: Row(
                                                     mainAxisAlignment: MainAxisAlignment
                                                         .spaceBetween,
                                                     children: [
                                                       Text("Category", style: GoogleFonts.varelaRound(
                                                           fontSize: 14, fontWeight: FontWeight.bold)
                                                       ),
                                                   Text(snapshot.data[i]["i"], style: GoogleFonts.varelaRound(
                                                       fontSize: 14),textAlign: TextAlign.right,)
                                                     ],
                                                   ),),
                                                 Padding(padding: const EdgeInsets.only(top: 10,right: 15,left: 15),
                                                   child: Row(
                                                     mainAxisAlignment: MainAxisAlignment
                                                         .spaceBetween,
                                                     children: [
                                                       Text("Date Created", style: GoogleFonts.varelaRound(
                                                           fontSize: 14, fontWeight: FontWeight.bold)
                                                       ),
                                                       Text(snapshot.data[i]["j"], style: GoogleFonts.varelaRound(
                                                           fontSize: 14),textAlign: TextAlign.right,)
                                                     ],
                                                   ),),

                                                 Padding(
                                                   padding: const EdgeInsets.only(left: 15,right: 15,top: 10),
                                                   child : Divider(height:5)
                                                 ),


                                               ],
                                             )
                                           );
                                         });
                                   },
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
                                               style: GoogleFonts.varelaRound(fontSize: 12))
                                       ),
                                     ),
                                     subtitle: Align(
                                       alignment: Alignment.centerLeft,
                                       child: Column(
                                         children: [
                                           Align(
                                             alignment: Alignment.centerLeft,
                                             child: Padding(padding: const EdgeInsets.only(top:2), child :
                                             Text(snapshot.data[i]["b"].toString(),
                                                 style: GoogleFonts.varelaRound(fontSize: 14,fontWeight: FontWeight.bold,
                                                     color: Colors.black))),
                                           ),
                                           Align(
                                             alignment: Alignment.centerLeft,
                                             child: Padding(padding: const EdgeInsets.only(top:2), child :
                                            Row(
                                              children: [
                                                Text("Rp "+
                                                    NumberFormat.currency(
                                                        locale: 'id', decimalDigits: 0, symbol: '').
                                                    format(
                                                        snapshot.data[i]["e"]), style: GoogleFonts.varelaRound(fontSize: 13,color:Colors.black),),

                                              ],
                                            )

                                             ),
                                           )
                                         ],
                                       ),
                                     ),
                                     trailing: InkWell(
                                       child: Padding(
                                         padding: const EdgeInsets.only(right: 10),
                                         child: FaIcon(FontAwesomeIcons.times,size: 20,color: Colors.redAccent,),
                                       ),
                                       onTap: (){
                                         FocusScope.of(context).requestFocus(FocusNode());
                                         _showDelete(snapshot.data[i]["g"].toString(), snapshot.data[i]["b"].toString());
                                       },
                                     ),
                                   )
                                 ),


                                  Container(
                                    width: double.infinity,
                                    height: 8,
                                    child :Divider(
                                      height: 5,
                                    ),
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
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(right : 10),
            child: FloatingActionButton(
              onPressed: (){
                FocusScope.of(context).requestFocus(FocusNode());
               Navigator.push(context, MaterialPageRoute(builder: (context) => TambahSerivceOutlet(widget.getidOutlet, widget.getEmail,  widget.getLegalCode, widget.getNamaUser)));

              },
              child: FaIcon(FontAwesomeIcons.plus),
            ),
          ),
      ),
    );

  }
}