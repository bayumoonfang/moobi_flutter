



import 'dart:async';
import 'dart:convert';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:moobi_flutter/Helper/api_link.dart';
import 'package:moobi_flutter/Helper/app_helper.dart';
import 'package:moobi_flutter/Helper/color_based.dart';
import 'package:moobi_flutter/Helper/page_route.dart';
import 'package:moobi_flutter/Jualan/page_jualan.dart';
import 'package:moobi_flutter/Jualan/page_jualanubahstore.dart';
import 'package:moobi_flutter/Jualan/page_jualanubahwarehouse.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import '../page_intoduction.dart';
import '../page_login.dart';

class JualanHome extends StatefulWidget{
  final String getEmail;
  final String getLegalCode;
  final String getLegalId;
  final String getNamaUser;
  const JualanHome(this.getEmail, this.getLegalCode, this.getLegalId, this.getNamaUser);

  @override
  _JualanHome createState() => _JualanHome();
}


class _JualanHome extends State<JualanHome>{

  String selectedValue = "Product";
  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
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

  String getNamaToko = "...";
  String getWarehouse = "...";
  String getStoreId = "...";
  String getWarehouseId = "...";
  String getWarehouseKode = "...";
  _tokoDefault() async {
    final response = await http.get(
        applink+"api_model.php?act=getsetting_salesdefault&username="+widget.getEmail+"&branch="+widget.getLegalCode);
    Map data = jsonDecode(response.body);
    setState(() {
      getNamaToko = data["store_nama"].toString();
      getWarehouse = data["warehouse_name"].toString();
      getStoreId = data["store_id"].toString();
      getWarehouseId = data["warehouse_id"].toString();
      getWarehouseKode = data["warehouse_kode"].toString();
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
    await _tokoDefault();


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

  Future<bool> _onWillPop() async {
    Navigator.pop(context);}



  _prepare() async {
    await _startingVariable();
  }

  @override
  void initState() {
    super.initState();
    _prepare();
  }


  FutureOr onGoBack(dynamic value) {
    _prepare();
    setState(() {});
  }

  List<DropdownMenuItem<String>> get dropdownItems{
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Transaksi Produk", style : GoogleFonts.varelaRound(fontWeight: FontWeight.bold)),value: "Product"),
      DropdownMenuItem(child: Text("Transaksi Jasa", style : GoogleFonts.varelaRound(fontWeight: FontWeight.bold)),value: "Service")
    ];
    return menuItems;
  }

  @override
  Widget build(BuildContext context) {
      return WillPopScope(
          child: Scaffold(
            appBar: new AppBar(
              backgroundColor: HexColor("#602d98"),
              title: Text(
                "Mulai Jualan",
                style: TextStyle(
                    color: Colors.white, fontFamily: 'VarelaRound', fontSize: 16),
              ),
              leading: Builder(
                builder: (context) => IconButton(
                    icon: new Icon(Icons.arrow_back),
                    color: Colors.white,
                    onPressed: () => {
                      Navigator.pop(context)
                    }),
              ),
            ),
            body: Container(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                children: [
                  Padding(padding: const EdgeInsets.only(top:35,left: 25,right: 25),
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween,
                      children: [
                        Text(
                          "PENGATURAN",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontFamily: 'VarelaRound',
                              color: HexColor("#73767d"),
                              fontWeight: FontWeight.bold,
                              fontSize: 13),
                        ),
                      ],
                    ),),

                  Padding(padding: const EdgeInsets.only(top: 25,left: 9,right: 25),
                      child: InkWell(
                        child: ListTile(
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => JualanUbahStore(widget.getEmail,widget.getLegalCode,getWarehouseId.toString()))).then(onGoBack);
                            },
                          title: Column(
                            children: [
                              Align(alignment: Alignment.centerLeft,
                                child: Text("Toko yang digunakan", style: TextStyle(color: HexColor("#72757a"),
                                  fontFamily: 'VarelaRound',fontSize: 11,)),),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  padding: const EdgeInsets.only(top:5 ),
                                  height: 25,
                                  child: Align(alignment: Alignment.centerLeft,
                                      child: Text(getNamaToko, style: TextStyle(
                                        fontFamily: 'VarelaRound',
                                        fontSize: 15,fontWeight: FontWeight.bold)))
                                ),
                              )
                            ],
                          ),
                          trailing: FaIcon(FontAwesomeIcons.angleRight,color: HexColor(third_color),size: 23,),
                        ),
                      )
                  ),
                  Padding(padding: const EdgeInsets.only(top: 5,left: 25,right: 25),
                    child: Divider(height: 3,),),

                  Padding(padding: const EdgeInsets.only(top: 15,left: 9,right: 25),
                      child: InkWell(
                        child: ListTile(
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => JualanUbahWarehouse(widget.getEmail,widget.getLegalCode, getStoreId.toString()))).then(onGoBack);
                          },
                          title: Column(
                            children: [
                              Align(alignment: Alignment.centerLeft,
                                child: Text("Gudang yang digunakan", style: TextStyle(color: HexColor("#72757a"),
                                  fontFamily: 'VarelaRound',fontSize: 11,)),),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                    padding: const EdgeInsets.only(top:5 ),
                                    height: 25,
                                    child: Align(alignment: Alignment.centerLeft,
                                        child: Text(getWarehouse, style: TextStyle(
                                            fontFamily: 'VarelaRound',
                                            fontSize: 15,fontWeight: FontWeight.bold)))
                                ),
                              )
                            ],
                          ),
                          trailing: FaIcon(FontAwesomeIcons.angleRight,color: HexColor(third_color),size: 23,),
                        ),
                      )
                  ),


                  Padding(padding: const EdgeInsets.only(top: 5,left: 25,right: 25),
                    child: Divider(height: 3,),),

                  Padding(padding: const EdgeInsets.only(top: 15,left: 9,right: 25),
                    child : ListTile(
                          title: Column(
                            children: [
                              Align(alignment: Alignment.centerLeft,
                                child: Text("Sales Origine", style: TextStyle(color: HexColor("#72757a"),
                                  fontFamily: 'VarelaRound',fontSize: 11,)),),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                    padding: const EdgeInsets.only(top:5 ),
                                    height: 55,
                                    child: Align(alignment: Alignment.centerLeft,
                                        child: DropdownButton(
                                          isExpanded: false,
                                          value: selectedValue,
                                          items: dropdownItems,
                                          onChanged: (value) {
                                            setState(() {
                                              FocusScope.of(context).requestFocus(FocusNode());
                                              selectedValue = value;
                                            });
                                          },
                                        ),

                                    )
                                ),
                              )
                            ],
                          ),
                          //trailing: FaIcon(FontAwesomeIcons.angleRight,color: HexColor(third_color),size: 23,),
                        ),
                      )




                ],
              ),
            ),
            bottomNavigationBar: Container(
              width: double.infinity,
              height: 50,
              child:
              getNamaToko == '...' || getWarehouse == '...' ?
              RaisedButton(
                  color: HexColor(main_color),
                  child :Text("Lanjut Jualan",style: GoogleFonts.varelaRound(color:Colors.black),),
              )
              :
                RaisedButton(
                color: HexColor(main_color),
                child :Text("Lanjut Jualan",style: GoogleFonts.varelaRound(color:Colors.white),),
                onPressed: (){
                  Navigator.push(context, ExitPage(page: Jualan(widget.getEmail,widget.getLegalCode, widget.getLegalId,
                      getStoreId, getWarehouseKode, widget.getNamaUser, getWarehouseId, selectedValue )));
                },
              ),
            ),
          ),
          onWillPop: _onWillPop
      );
  }
}