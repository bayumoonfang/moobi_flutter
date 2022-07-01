


import 'dart:ui';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:moobi_flutter/Helper/app_helper.dart';
import 'package:moobi_flutter/Helper/check_connection.dart';
import 'package:moobi_flutter/Helper/color_based.dart';
import 'package:moobi_flutter/Helper/page_route.dart';
import 'package:moobi_flutter/Helper/session.dart';
import 'package:moobi_flutter/Helper/setting_apps.dart';
import 'package:moobi_flutter/page_login.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:moobi_flutter/helper/api_link.dart';
import 'dart:convert';
import 'dart:async';

import '../page_intoduction.dart';




class DetailRenewal extends StatefulWidget {
  final String Notrans;
  final String getEmail;
  const DetailRenewal(this.Notrans, this.getEmail);
  @override
  _DetailRenewal createState() => _DetailRenewal();
}


class _DetailRenewal extends State<DetailRenewal> {
  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }


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


  Future<bool> _onWillPop() async {
    Navigator.pop(context);
  }


  String getIsi = "...";
  String getAmount = "0";
  String getStatusInv = "...";
  String getBayarkeNama = "...";
  String getBayarkePemilik = "...";
  String getBayarkeNorek = "...";
  String getBayardariNama = "...";
  String getBayardariPemilik = "...";
  String getBayardariNorek = "...";
  String getBayarTgl = "...";
  String getBayarCreated = "...";
  String getDeskripsi = "...";
  String getTanggal = "2021-04-20 15:55:01";
  String getType = "...";
  //String getBayarkeNorek = "...";
  _getDetailInvoice() async {
    final response = await http.get(applink+"api_model.php?act=getdetail_notifikasitransaksi&id="+widget.Notrans.toString());
    Map data2 = jsonDecode(response.body);
    setState(() {
      getAmount = data2["b"].toString();
      getStatusInv = data2["e"].toString();
      getType = data2["a"].toString();
      getBayarkeNama =  data2["f"].toString();
      getBayarkePemilik =  data2["h"].toString();
      getBayarkeNorek =  data2["g"].toString();
      getBayardariNama =  data2["i"].toString();
      getBayardariPemilik = data2["j"].toString();
      getBayardariNorek =  data2["k"].toString();
      getBayarTgl = data2["d"].toString();
      getBayarCreated = data2["l"].toString();
      getDeskripsi = data2["c"].toString();
    });

  }






  _prepare() async {
    EasyLoading.show(status: easyloading_text);
    await _startingVariable();
    await _getDetailInvoice();
    EasyLoading.dismiss();
  }


  @override
  void initState() {
    super.initState();
    _prepare();
  }


  showFlushBarsuccess(BuildContext context, String stringme) => Flushbar(
    // title:  "Hey Ninja",
    message:  stringme,
    shouldIconPulse: false,
    duration:  Duration(seconds: 10),
    backgroundColor: Colors.black,
    flushbarPosition: FlushbarPosition.BOTTOM ,
  )..show(context);

  void showsuccess(String txtError){
    showFlushBarsuccess(context, txtError);
    return;
  }








  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          appBar: new AppBar(
            /* centerTitle: true,*/
            elevation: 0,
            backgroundColor: HexColor(main_color),
            /*title: Image.asset("assets/logo2.png",width: 100,),*/
            title: Text(
              "Renewal Detail",
              style: TextStyle(
                  color: Colors.white, fontFamily: 'VarelaRound', fontSize: 16),
            ),
            leading: Builder(
              builder: (context) => IconButton(
                  icon: new FaIcon(FontAwesomeIcons.times),
                  color: Colors.white,
                  onPressed: () => {
                    Navigator.pop(context)
                  }),
            ),
          ),
          body: Container(
              color: Colors.white,
              child:
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 120,
                    color: HexColor(main_color),
                    child: Padding(
                        padding: const EdgeInsets.only(top: 10,left: 20,right: 20),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceBetween,
                              children: [
                                Text(widget.Notrans,style: GoogleFonts.varelaRound(color:Colors.white,fontSize: 16),),
                                Text(getStatusInv,style: GoogleFonts.varelaRound(color:Colors.white,fontSize: 16),),
                              ],
                            ),
                            Padding(padding: const EdgeInsets.only(top:3),
                              child: Align(alignment: Alignment.centerLeft,child:
                              Text(getType,style: GoogleFonts.varelaRound(color:Colors.white,fontSize: 11),),),),
                            Padding(padding: const EdgeInsets.only(top:20),
                              child: Align(alignment: Alignment.centerLeft,child:
                              Text("Rp. "+
                                  NumberFormat.currency(
                                      locale: 'id', decimalDigits: 0, symbol: '').format(
                                      int.parse(getAmount.toString())),style: GoogleFonts.varelaRound(color:Colors.white,fontSize: 32,fontWeight: FontWeight.bold),),),)
                            /*Text( "Rp. "+
                NumberFormat.currency(
                    locale: 'id', decimalDigits: 0, symbol: '').format(
                    int.parse(getAmount.toString())),
                  style: TextStyle(fontFamily: "VarelaRound",
                  fontWeight: FontWeight.bold,
                  fontSize: 32,color: HexColor("#72bd00"))),
                    Text(getAmount.toString())*/
                          ],

                        )
                    ),
                  ),
                  Padding(padding: const EdgeInsets.only(top: 25,left: 20,right: 20),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(padding: const EdgeInsets.only(top:3),
                          child: Align(alignment: Alignment.centerLeft,child:
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(alignment: Alignment.centerLeft,child:
                              Text("Dibayar Dari :",style: GoogleFonts.varelaRound(color:Colors.black,fontSize: 12),textAlign: TextAlign.left,),),
                              Padding(padding : const EdgeInsetsDirectional.only(top:5),child :
                              Text(getBayardariNama,style: GoogleFonts.varelaRound(color:Colors.black,fontSize: 14,fontWeight: FontWeight.bold),),),
                              Padding(padding : const EdgeInsetsDirectional.only(top:5),child :
                              Text(getBayardariNorek,style: GoogleFonts.varelaRound(color:Colors.black,fontSize: 12),),),
                              Padding(padding : const EdgeInsetsDirectional.only(top:5),child :
                              Text("a.n "+getBayardariPemilik,style: GoogleFonts.varelaRound(color:Colors.black,fontSize: 11),),)
                            ],
                          )

                          ),),

                        Padding(padding: const EdgeInsets.only(top:3,left: 40),
                          child: Align(alignment: Alignment.centerLeft,child:
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(alignment: Alignment.centerLeft,child:
                              Text("Dibayar Ke :",style: GoogleFonts.varelaRound(color:Colors.black,fontSize: 12),textAlign: TextAlign.left,),),
                              Padding(padding : const EdgeInsetsDirectional.only(top:5),child :
                              Text(getBayarkeNama,style: GoogleFonts.varelaRound(color:Colors.black,fontSize: 14,fontWeight: FontWeight.bold),),),
                              Padding(padding : const EdgeInsetsDirectional.only(top:5),child :
                              Text(getBayarkeNorek,style: GoogleFonts.varelaRound(color:Colors.black,fontSize: 12),),),
                              Padding(padding : const EdgeInsetsDirectional.only(top:5),child :
                              Text("a.n "+getBayarkePemilik,style: GoogleFonts.varelaRound(color:Colors.black,fontSize: 11),),)
                            ],
                          )

                          ),),

                      ],
                    ),),
                  Padding(padding:const EdgeInsets.only(top :25,left: 20,right: 20),
                    child: Divider(height: 5,),),
                  Padding(padding:const EdgeInsets.only(top :25,left: 20,right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Tanggal Transaksi",style: GoogleFonts.varelaRound(color:Colors.black,fontSize: 13),textAlign: TextAlign.left,),
                        Text(getBayarTgl,style: GoogleFonts.varelaRound(color:Colors.black,fontSize: 13),textAlign: TextAlign.left,),
                      ],
                    ),),
                  Padding(padding:const EdgeInsets.only(top :10,left: 20,right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Deskripsi",style: GoogleFonts.varelaRound(color:Colors.black,fontSize: 13),textAlign: TextAlign.left,),
                        Text(getDeskripsi,style: GoogleFonts.varelaRound(color:Colors.black,fontSize: 13),textAlign: TextAlign.left,),
                      ],
                    ),)
                ],
              )
          ),
      ),
    );

  }
}