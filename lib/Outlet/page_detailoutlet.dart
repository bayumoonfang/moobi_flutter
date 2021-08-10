

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:moobi_flutter/Helper/api_link.dart';
import 'package:moobi_flutter/Helper/app_helper.dart';
import 'package:moobi_flutter/Helper/color_based.dart';
import 'package:moobi_flutter/Helper/page_route.dart';
import 'package:moobi_flutter/page_login.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;


class DetailOutlet extends StatefulWidget {
  final String idOutlet;
  const DetailOutlet(this.idOutlet);
  @override
  _DetailOutlet createState() => _DetailOutlet();
}

class _DetailOutlet extends State<DetailOutlet> {
  List data;
  bool _isvisible = true;

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);}

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

  String getOutletName = "...";
  String getOutletAddress = "...";
  String getOutletCity = "...";
  String getOutletPhone = "...";
  String getOutletStatus = "...";
  String getOutletWarehouse = '...';
  String getLegalNama = '...';
  String getStoreCode = '...';
  String getStoreID = '...';
  String getStoreWarehouse = '...';
  String getStoreDefault = '...';
  _outletDetail() async {
    final response = await http.get(
        applink+"api_model.php?act=outletdetail&id="+widget.idOutlet);
    Map data = jsonDecode(response.body);
    setState(() {
      getOutletName = data["a"].toString();
      getOutletAddress = data["b"].toString();
      getOutletCity = data["c"].toString();
      getOutletPhone = data["d"].toString();
      getOutletStatus = data["f"].toString();
      getOutletWarehouse = data["g"].toString();
      getLegalNama = data["h"].toString();
      getStoreCode = data["e"].toString();
      getStoreID = data["i"].toString();
      getStoreWarehouse = data["j"].toString();
      getStoreDefault = data["k"].toString();
    });
  }

  String getStoreSales = '0';
  _outletSalesTotal() async {
    final response = await http.get(
        applink+"api_model.php?act=outletsalestotal&id="+getStoreCode);
    Map data = jsonDecode(response.body);
    setState(() {
      getStoreSales = data["a"].toString();
    });
  }


  String getStoreSalesProduct = '0';
  _outletSalesProduct() async {
    final response = await http.get(
        applink+"api_model.php?act=outletsalesproduct&id="+getStoreID);
    Map data = jsonDecode(response.body);
    setState(() {
      getStoreSalesProduct = data["a"].toString();
    });
  }



  Future<bool> _onWillPop() async {
    Navigator.pop(context);}


  _prepare() async {
    await _startingVariable();
    await _outletDetail();
    await _outletSalesTotal();
    await _outletSalesProduct();
  }

  @override
  void initState() {
    super.initState();
    _prepare();
  }


  void _gantiStatusToko() {
    var url = applink+"api_model.php?act=action_changestatustoko";
    http.post(url,
        body: {
          "id": getStoreID
        });
    showToast("Status Toko berhasil dirubah", gravity: Toast.BOTTOM,
        duration: Toast.LENGTH_LONG);
    setState(() {
      _outletDetail();
    });
  }

  var client = http.Client();
  Future<dynamic> getDataStatusDefault() async {
    http.Response response = await client.get(
        Uri.parse(applink+"api_model.php?act=getdata_storestatusdefault&id="
            +widget.idOutlet),
        headers: {
          "Accept":"application/json",
          "Content-Type": "application/json"}
    );
    return json.decode(response.body);
  }


  Future<dynamic> getDataStatusToko() async {
    http.Response response = await client.get(
        Uri.parse(applink+"api_model.php?act=getdata_storestatus&id="
            +widget.idOutlet),
        headers: {
          "Accept":"application/json",
          "Content-Type": "application/json"}
    );
    return json.decode(response.body);
  }

  void _gantiStatusDefault() {
    var url = applink+"api_model.php?act=action_changestatusdefaulttoko";
    http.post(url,
        body: {
          "id": getStoreID
        });
    showToast("Status Toko berhasil dirubah", gravity: Toast.BOTTOM,
        duration: Toast.LENGTH_LONG);
    setState(() {
      getDataStatusDefault();
    });
  }

  void _gantiStatus() {
    var url = applink+"api_model.php?act=action_changestatustoko";
    http.post(url,
        body: {
          "id": getStoreID
        });
    showToast("Status Toko berhasil dirubah", gravity: Toast.BOTTOM,
        duration: Toast.LENGTH_LONG);
    setState(() {
      getDataStatusToko();
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
            "Detail Store",
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
              child: Align(alignment: Alignment.centerLeft,child:
              Row(
                children: [
                  Text(getOutletName,style: TextStyle(
                      color: Colors.black, fontFamily: 'VarelaRound',fontWeight: FontWeight.bold,fontSize: 20)),
                ],)
                ,),),
              Padding(padding: const EdgeInsets.only(left: 15,top: 5),
                child: Align(alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Text("Owned By",style: TextStyle(
                          color: Colors.black, fontFamily: 'VarelaRound',fontSize: 12)),
                      Padding(padding: const EdgeInsets.only(right: 10)),
                      Container(
                        height: 20,
                        child: RaisedButton(
                          onPressed: (){},
                          color: HexColor("#eaffee"),
                          elevation: 1,
                          child: Text(getLegalNama,style: TextStyle(
                              color: HexColor("#00ac48"), fontFamily: 'VarelaRound',fontSize: 9)),
                        ),
                      )
                    ],
                  ),

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
                        "SALES TOKO",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontFamily: 'VarelaRound',
                            color: HexColor("#73767d"),
                            fontWeight: FontWeight.bold,
                            fontSize: 13),
                      ),
                      Text("Lihat Riwayat",
                          style: TextStyle(
                              fontFamily: 'VarelaRound',
                              color: HexColor("#02ac0e"),
                              fontWeight: FontWeight.bold,
                              fontSize: 13)),

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
                                child: Text("Sales Total", style: TextStyle(color: HexColor("#72757a"),
                                  fontFamily: 'VarelaRound',fontSize: 11,)),),
                              Padding(padding: const EdgeInsets.only(top:5),
                                child: Align(alignment: Alignment.centerLeft,
                                  child:      Text("Rp. " +
                                      NumberFormat.currency(
                                          locale: 'id', decimalDigits: 0, symbol: '').
                                      format(
                                          int.parse(getStoreSales))
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



              Column(
                children: [
                  Padding(padding: const EdgeInsets.only(left: 25,right: 25,top: 20),
                      child :
                      Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceBetween,
                        children: [
                          Text(
                            "PENJUALAN PRODUK",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontFamily: 'VarelaRound',
                                color: HexColor("#73767d"),
                                fontWeight: FontWeight.bold,
                                fontSize: 13),
                          ),
                          Text("Lihat Riwayat",
                              style: TextStyle(
                                  fontFamily: 'VarelaRound',
                                  color: HexColor("#02ac0e"),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13)),

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
                                child: Text("Produk Terjual", style: TextStyle(color: HexColor("#72757a"),
                                  fontFamily: 'VarelaRound',fontSize: 11,)),),
                              Padding(padding: const EdgeInsets.only(top:5),
                                child: Align(alignment: Alignment.centerLeft,
                                  child:      Text(getStoreSalesProduct.substring(1)
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


              Padding(padding: const EdgeInsets.only(top: 10,left: 25,right: 25),
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

              Padding(padding: const EdgeInsets.only(top: 10,left: 9,right: 25),
                  child: InkWell(
                    child: ListTile(
                      onTap: (){
                        //Navigator.pushReplacement(context, ExitPage(page: ProfileUbahNama()));
                      },
                      title: Column(
                        children: [
                          Align(alignment: Alignment.centerLeft,
                            child: Text("Gudang Default", style: TextStyle(color: HexColor("#72757a"),
                                fontFamily: 'VarelaRound',fontSize: 11,)),),
                          Padding(padding: const EdgeInsets.only(top:5),
                            child: Align(alignment: Alignment.centerLeft,
                              child: Text(getStoreWarehouse, style: TextStyle(
                                fontFamily: 'VarelaRound',
                                fontSize: 15,)),),)
                        ],
                      ),
                      trailing: FaIcon(FontAwesomeIcons.angleRight,color: HexColor(third_color),size: 23,),
                    ),
                  )
              ),
              Padding(padding: const EdgeInsets.only(top: 5,left: 25,right: 25),
                child: Divider(height: 3,),),

              Padding(padding: const EdgeInsets.only(top: 5,left: 9,right: 25),
                  child: InkWell(
                    child: ListTile(
                      onTap: (){
                        //Navigator.pushReplacement(context, ExitPage(page: ProfileUbahNama()));
                      },
                      title: Text("Ubah Keterangan Toko",style: TextStyle(
                          color: Colors.black, fontFamily: 'VarelaRound',fontSize: 15)),
                      trailing: FaIcon(FontAwesomeIcons.angleRight,color: HexColor(third_color),),
                    ),
                  )
              ),

              Padding(padding: const EdgeInsets.only(top: 5,left: 25,right: 25),
                child: Divider(height: 3,),),


              Padding(padding: const EdgeInsets.only(left: 9,right: 25),
                child: ListTile(
                    onTap: (){
                      //Navigator.pushReplacement(context, ExitPage(page: ProfileUbahNama()));
                    },
                    title: Padding(padding: const EdgeInsets.only(top: 10),
                      child: Column(
                        children: [
                            Align(alignment: Alignment.centerLeft,child:
                            Text("Toko Default", style: TextStyle(
                              fontFamily: 'VarelaRound',fontSize: 15,)),),
                            Padding(padding: const EdgeInsets.only(top: 5),
                            child:    Align(alignment: Alignment.centerLeft,child:
                            Text("Dengan pengaturan ini , anda akan otomatis memakai toko ini untuk berjualan",
                                style: TextStyle(fontFamily: 'VarelaRound',fontSize: 13,color: HexColor("#72757a"),)),),)
                        ],
                      ),),
                    trailing:
                    Container(
                        alignment: Alignment.centerRight,
                        width: 50,
                        child:
                        FutureBuilder(
                          future: getDataStatusDefault(),
                          builder: (context, snapshot) {
                            return ListView.builder(
                              itemCount: snapshot.data == null ? 0 : snapshot.data.length,
                              itemBuilder: (context, i) {
                               return InkWell(
                                    onTap: () {
                                      _gantiStatusDefault();
                                    },
                                    child:
                                    snapshot.data[i]["a"] == 'Yes' ?
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
                                );
                              },
                            );
                          },
                        )

                    )
                ),
              ),
              Padding(padding: const EdgeInsets.only(top: 5,left: 25,right: 25),
                child: Divider(height: 3,),),



              Padding(padding: const EdgeInsets.only(left: 9,right: 25),
                  child: ListTile(
                      onTap: (){
                        //Navigator.pushReplacement(context, ExitPage(page: ProfileUbahNama()));
                      },
                      title: Padding(padding: const EdgeInsets.only(top: 10),
                        child: Column(
                          children: [
                            Align(alignment: Alignment.centerLeft,child:
                            Text("Status Toko", style: TextStyle(
                              fontFamily: 'VarelaRound',fontSize: 15,)),),
                            Padding(padding: const EdgeInsets.only(top: 5),
                              child:    Align(alignment: Alignment.centerLeft,child:
                              Text("Toko tidak bisa digunakan untuk berjualan jika anda menonaktifkan toko ini",
                                  style: TextStyle(fontFamily: 'VarelaRound',fontSize: 13,color: HexColor("#72757a"),)),),)
                          ],
                        ),),
                      trailing:
                      Container(
                          alignment: Alignment.centerRight,
                          width: 50,
                          child:
                          FutureBuilder(
                            future: getDataStatusToko(),
                            builder: (context, snapshot) {
                              return ListView.builder(
                                itemCount: snapshot.data == null ? 0 : snapshot.data.length,
                                itemBuilder: (context, i) {
                                  return InkWell(
                                      onTap: () {
                                        _gantiStatus();
                                      },
                                      child:
                                      snapshot.data[i]["a"] == 'Aktif' ?
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
                                  );
                                },
                              );
                            },
                          )
                      )
                    ),
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