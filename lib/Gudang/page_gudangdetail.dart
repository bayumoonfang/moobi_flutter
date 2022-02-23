




import 'dart:async';
import 'dart:convert';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:moobi_flutter/Gudang/page_gudangproduk.dart';
import 'package:moobi_flutter/Gudang/page_gudangubahnama.dart';
import 'package:moobi_flutter/Gudang/page_riwayatmutasi.dart';
import 'package:moobi_flutter/Helper/api_link.dart';
import 'package:moobi_flutter/Helper/app_helper.dart';
import 'package:moobi_flutter/Helper/color_based.dart';
import 'package:moobi_flutter/Helper/page_route.dart';
import 'package:moobi_flutter/page_login.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

import '../page_intoduction.dart';


class GudangDetail extends StatefulWidget {
  final String getEmail;
  final String getLegalCode;
  final String getLegalId;
  final String idGudang;
  const GudangDetail(this.getEmail, this.getLegalCode, this.getLegalId, this.idGudang);

  /*final String idGudang;
  final String valNamaUser;
  final String valBranch;
  const GudangDetail(this.idGudang, this.valNamaUser, this.valBranch);*/
  @override
  _GudangDetail createState() => _GudangDetail();
}

class _GudangDetail extends State<GudangDetail> {
  List data;
  bool _isvisible = true;

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);}

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



  String getWarehouseName = "...";
  String getOutletName = "...";
  String getCodeWarehouse = "...";
  String getOutletCode = "...";

  _outletDetail() async {
    final response = await http.get(
        applink+"api_model.php?act=gudangdetail&id="+widget.idGudang);
    Map data = jsonDecode(response.body);
    setState(() {
      getWarehouseName = data["a"].toString();
      getOutletName = data["b"].toString();
      getCodeWarehouse = data["c"].toString();
      getOutletCode = data["d"].toString();
    });
  }


  String getWarehouseTrans = '0';
  _warehouseTrans() async {
    final response = await http.get(
        applink+"api_model.php?act=warehouse_trans&id="+widget.idGudang);
    Map data = jsonDecode(response.body);
    setState(() {
      getWarehouseTrans = data["a"].toString();
    });
  }




  Future<bool> _onWillPop() async {
    Navigator.pop(context);}


  _prepare() async {
    await _startingVariable();
    await _outletDetail();
    await _warehouseTrans();
  }



  FutureOr onGoBack(dynamic value) {
    _outletDetail();
    setState(() {});
  }



  @override
  void initState() {
    super.initState();
    _prepare();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: new AppBar(
          backgroundColor: HexColor(main_color),
          title: Text(
            "Detail Gudang",
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
          actions: [
            InkWell(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                //alertSimpan();
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 30,top : 19),
                child: FaIcon(
                  FontAwesomeIcons.trashAlt,size: 18,
                ),
              ),
            )
          ],
        ),
        body: Container(
          child: Column(
            children: [
              Padding(padding: const EdgeInsets.only(left: 15,top: 20),
                child: Align(alignment: Alignment.centerLeft,child: Text(getWarehouseName,style: TextStyle(
                    color: Colors.black, fontFamily: 'VarelaRound',fontWeight: FontWeight.bold,fontSize: 20)),),),
              Padding(padding: const EdgeInsets.only(left: 15,top: 5),
                child: Align(alignment: Alignment.centerLeft,
                  child:
                  getOutletName.toString() != 'null' ?
                  Row(
                    children: [
                      Text("Used In",style: TextStyle(
                          color: Colors.black, fontFamily: 'VarelaRound',fontSize: 12)),
                      Padding(padding: const EdgeInsets.only(right: 10)),
                      Container(
                        height: 20,
                        child: RaisedButton(
                          onPressed: (){},
                          color: HexColor("#eaffee"),
                          elevation: 1,
                          child: Text(getOutletName,style: TextStyle(
                              color: HexColor("#00ac48"), fontFamily: 'VarelaRound',fontSize: 9)),
                        ),
                      )
                    ],
                  ) :
      Padding(padding: const EdgeInsets.only(left: 1),
      child:             Row(
        children: [
          Text("(Gudang masih belum terpakai)",style: TextStyle(
              color: Colors.black, fontFamily: 'VarelaRound',fontSize: 12)),
        ],
      ),)


                ),),

              Padding(padding: const EdgeInsets.only(top: 20),
                  child: Container(
                    height: 8,
                    width: double.infinity,
                    color: HexColor("#f0f3f8"),
                  )),

              Column(
                children: [
                  Padding(padding: const EdgeInsets.only(left: 25,right: 25,top: 20),
                      child :
                      Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceBetween,
                        children: [
                          Text(
                            "MUTASI PRODUK",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontFamily: 'VarelaRound',
                                color: HexColor("#73767d"),
                                fontWeight: FontWeight.bold,
                                fontSize: 13),
                          ),
                          InkWell(
                            onTap:() {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => RiwayatMutasi(widget.idGudang)));

                              //Navigator.push(context, ExitPage(page: RiwayatTransaksiOutlet(widget.idOutlet)));
                             // Navigator.push(context, MaterialPageRoute(builder: (context) => RiwayatTransaksiOutlet(widget.idOutlet)));
                            },
                            child :
                            Text("Lihat Riwayat",
                                style: TextStyle(
                                    fontFamily: 'VarelaRound',
                                    color: HexColor("#02ac0e"),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13)),
                          )
                        ],
                      )),

                  Padding(padding: const EdgeInsets.only(top: 10,left: 9),
                      child: InkWell(
                        child: ListTile(
                          onTap: (){
                            //Navigator.pushReplacement(context, ExitPage(page: ProfileUbahNama()));
                          },
                          title: Column(
                            children: [
                              Align(alignment: Alignment.centerLeft,
                                child: Text("Total", style: TextStyle(color: HexColor("#72757a"),
                                  fontFamily: 'VarelaRound',fontSize: 11,)),),
                              Padding(padding: const EdgeInsets.only(top:5),
                                child: Align(alignment: Alignment.centerLeft,
                                  child:      Text(getWarehouseTrans
                                      , style: TextStyle(
                                          fontFamily: 'VarelaRound',fontSize: 18,
                                          fontWeight: FontWeight.bold)),),)
                            ],
                          ),
                        ),
                      )
                  ),
                ],
              ),

              Padding(padding: const EdgeInsets.only(top: 5,left: 25,right: 25),
                child: Divider(height: 5,),),

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

              Padding(padding: const EdgeInsets.only(top: 5,left: 9,right: 25),
                  child: InkWell(
                    child: ListTile(
                      onTap: (){
                        //Navigator.push(context, ExitPage(page: GudangProduk(widget.idGudang, getCodeWarehouse )));
                        //Navigator.push(context, MaterialPageRoute(builder: (context) => GudangProduk(widget.idGudang, getCodeWarehouse, widget.valNamaUser, widget.valBranch)));
                      },
                      title: Padding(padding: const EdgeInsets.only(top: 10),
                        child: Column(
                          children: [
                            Align(alignment: Alignment.centerLeft,child:
                            Text("Daftar Produk", style: TextStyle(
                              fontFamily: 'VarelaRound',fontSize: 15,)),),
                            Padding(padding: const EdgeInsets.only(top: 5),
                              child: Align(alignment: Alignment.centerLeft,child:
                              Text("Atur produk yang masuk dalam gudang",
                                  style: TextStyle(fontFamily: 'VarelaRound',fontSize: 13,color: HexColor("#72757a"),)),),)
                          ],
                        ),),
                      trailing: FaIcon(FontAwesomeIcons.angleRight,color: HexColor(third_color),),
                    ),
                  )
              ),


              Padding(padding: const EdgeInsets.only(top: 5,left: 25,right: 25),
                child: Divider(height: 3,),),


              Padding(padding: const EdgeInsets.only(top: 5,left: 9,right: 25),
                  child: InkWell(
                    child: ListTile(
                      onTap: (){
                        Navigator.push(context, ExitPage(page: GudangUbahNama(widget.idGudang, getWarehouseName.toString()))).then(onGoBack);
                      },
                      title: Text("Ubah Nama Gudang",style: TextStyle(
                          color: Colors.black, fontFamily: 'VarelaRound',fontSize: 15)),
                      trailing: FaIcon(FontAwesomeIcons.angleRight,color: HexColor(third_color),),
                    ),
                  )
              ),

              Padding(padding: const EdgeInsets.only(top: 5,left: 25,right: 25),
                child: Divider(height: 3,),),

            ],
          ),
        ),
      ),
    );
  }
}