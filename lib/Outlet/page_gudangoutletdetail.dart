




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
import 'package:moobi_flutter/Outlet/page_gudangoutletproduk.dart';
import 'package:moobi_flutter/Outlet/page_gudangoutletubahnama.dart';
import 'package:moobi_flutter/Outlet/page_riwayatmutasioutletgudang.dart';
import 'package:moobi_flutter/page_login.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

import '../page_intoduction.dart';


class GudangOutletDetail extends StatefulWidget {
  final String getEmail;
  final String getLegalCode;
  final String getLegalId;
  final String idGudang;
  final String kodeGudang;
  final String getNamaUser;
  final String getIdOulet;
  final String getNamaGudang;
  final String getDeskripsiGudang;
  const GudangOutletDetail(this.getEmail, this.getLegalCode, this.getLegalId, this.idGudang, this.kodeGudang, this.getNamaUser,
      this.getIdOulet, this.getNamaGudang, this.getDeskripsiGudang);

  /*final String idGudang;
  final String valNamaUser;
  final String valBranch;
  const GudangDetail(this.idGudang, this.valNamaUser, this.valBranch);*/
  @override
  _GudangOutletDetail createState() => _GudangOutletDetail();
}

class _GudangOutletDetail extends State<GudangOutletDetail> {
  List data;
  bool _isvisible = true;

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);}


  String getWarehouseNama = '...';
  String getWarehouseDeskripsi = '...';
  _warehouseDetail() async {
    final response = await http.get(
        applink+"api_model.php?act=warehouse_detail&id="+widget.idGudang+"&getserver="+serverCode.toString());
    Map data = jsonDecode(response.body);
    setState(() {
      getWarehouseNama = data["warehouse_nama"].toString();
      getWarehouseDeskripsi = data["warehouse_deskripsi"].toString();
    });

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
    await _warehouseDetail();
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




  String getWarehouseTrans = '0';
  _warehouseTrans() async {
    final response = await http.get(
        applink+"api_model.php?act=warehouse_trans&id="+widget.kodeGudang+"&idstore="+widget.getIdOulet+"&getserver="+serverCode.toString());
    Map data = jsonDecode(response.body);
    setState(() {
      getWarehouseTrans = data["a"].toString();
    });
  }



  Future<bool> _onWillPop() async {
    Navigator.pop(context);}


  _prepare() async {
    await _startingVariable();
    await _warehouseTrans();

  }



  FutureOr onGoBack(dynamic value) {
    _prepare();
    setState(() {

    });
  }



  @override
  void initState() {
    super.initState();
    _prepare();
  }



  doHapus() async {
    Navigator.pop(context);
    final response = await http.get(applink+"api_model.php?act=action_hapusgudang&"
        "id="+widget.idGudang
        +"&branch="+widget.getLegalCode+"&getserver="+serverCode.toString());
    Map data = jsonDecode(response.body);
    setState(() {
      if (data["message"].toString() == '1') {
        Navigator.pop(context);
      } else {
        //showerror("Product sudah ada di outlet ini, silahkan cari produk yang lain");
      }
    });
    //
  }



  alertHapus() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            //title: Text(),
            content: Container(
                width: double.infinity,
                height: 180,
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
                    Text("Apakah anda yakin menghapus gudang ini ? ",
                      style: TextStyle(fontFamily: 'VarelaRound', fontSize: 12),textAlign: TextAlign.center,),)),
                    Padding(padding: const EdgeInsets.only(top: 25), child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(child: OutlineButton(
                          onPressed: () {Navigator.pop(context);}, child: Text("Tidak"),)),
                        Expanded(child: OutlineButton(
                          borderSide: BorderSide(width: 1.0, color: Colors.redAccent),
                          onPressed: () {
                           doHapus();
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
            getWarehouseNama != 'Gudang Besar' && widget.kodeGudang != '99' ?
            InkWell(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                alertHapus();
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 30,top : 19),
                child: FaIcon(
                  FontAwesomeIcons.trashAlt,size: 18,
                ),
              ),
            )
                :
                Container()
          ],
        ),
        body: Container(
          child: Column(
            children: [
              Padding(padding: const EdgeInsets.only(left: 15,top: 20),
                child: Align(alignment: Alignment.centerLeft,child: Text(getWarehouseNama,style: TextStyle(
                    color: Colors.black, fontFamily: 'VarelaRound',fontWeight: FontWeight.bold,fontSize: 20)),),),
              Padding(padding: const EdgeInsets.only(left: 17,top: 5),
                child: Align(alignment: Alignment.centerLeft,
                  child:

                  Row(
                    children: [
                      Text(getWarehouseDeskripsi.toString(),style: TextStyle(
                          color: Colors.black, fontFamily: 'VarelaRound',fontSize: 12)),
                    /*  Padding(padding: const EdgeInsets.only(right: 10)),
                      Container(
                        height: 20,
                        child: RaisedButton(
                          onPressed: (){},
                          color: HexColor("#eaffee"),
                          elevation: 1,
                          child: Text(getOutletName,style: TextStyle(
                              color: HexColor("#00ac48"), fontFamily: 'VarelaRound',fontSize: 9)),
                        ),
                      )*/
                    ],
                  )
    /*  Padding(padding: const EdgeInsets.only(left: 1),
      child:             Row(
        children: [
          Text("(Gudang masih belum terpakai)",style: TextStyle(
              color: Colors.black, fontFamily: 'VarelaRound',fontSize: 12)),
        ],
      ),)*/


                ),),

              Padding(padding: const EdgeInsets.only(top: 20),
                  child: Container(
                    height: 8,
                    width: double.infinity,
                    color: HexColor("#f0f3f8"),
                  )),

              Column(
                children: [
                  widget.kodeGudang != '99' ?
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
                              Navigator.push(context, MaterialPageRoute(builder: (context) => RiwayatMutasiOutletGudang(widget.getEmail, widget.getLegalId, widget.kodeGudang, widget.getIdOulet )));

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
                      ))
                  : Container(),

                  widget.kodeGudang != '99' ?
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
                                  child:      Text(getWarehouseTrans == null ? "0" : getWarehouseTrans
                                      , style: TextStyle(
                                          fontFamily: 'VarelaRound',fontSize: 18,
                                          fontWeight: FontWeight.bold)),),)
                            ],
                          ),
                        ),
                      )
                  ) : Container()
                ],
              ),
              widget.kodeGudang != '99' ?
              Padding(padding: const EdgeInsets.only(top: 5,left: 25,right: 25),
                child: Divider(height: 5,),)
                : Container(),


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

              widget.kodeGudang != '99' ?
              Padding(padding: const EdgeInsets.only(top: 5,left: 9,right: 25),
                  child: InkWell(
                    child: ListTile(
                      onTap: (){
                        Navigator.push(context, ExitPage(page: GudangOutletProduk(widget.idGudang, widget.kodeGudang, widget.getEmail, widget.getLegalCode, widget.getNamaUser, widget.getIdOulet))).then(onGoBack);
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
              )
              :
              Opacity(
                opacity : 0.4,
                child : Padding(padding: const EdgeInsets.only(top: 5,left: 9,right: 25),
                    child: ListTile(
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
                  child:
                  getWarehouseNama != 'Gudang Besar' && widget.kodeGudang != '99' ?
                  InkWell(
                    onTap: (){
                      Navigator.push(context, ExitPage(page: GudangOutletUbahNama(
                          widget.getEmail, widget.getLegalCode,widget.idGudang, getWarehouseNama.toString(),
                          getWarehouseDeskripsi.toString()))).then(onGoBack);
                    },
                    child: ListTile(
                      title: Text("Ubah Gudang",style: TextStyle(
                          color: Colors.black, fontFamily: 'VarelaRound',fontSize: 15)),
                      trailing: FaIcon(FontAwesomeIcons.angleRight,color: HexColor(third_color),),
                    ),
                  )
                      :
                  Opacity(
                    opacity: 0.4,
                    child : ListTile(
                      title: Text("Ubah Gudang",style: TextStyle(
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