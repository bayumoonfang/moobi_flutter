


import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:moobi_flutter/Helper/api_link.dart';
import 'package:moobi_flutter/Helper/color_based.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:toast/toast.dart';


class RiwayatTransaksiOutlet extends StatefulWidget {
  final String idOutlet;
  const RiwayatTransaksiOutlet(this.idOutlet);
  @override
  _RiwayatTransaksiOutlet createState() => _RiwayatTransaksiOutlet();
}

class  ProdukData {

}

class _RiwayatTransaksiOutlet extends State<RiwayatTransaksiOutlet> {

  List data;
  bool _isVisible = false;
  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }

  String limit = "30";
  int temp_limit;
  String hariTransaksi = "Transaksi Hari Ini";
  bool pemasukan = false;
  bool pengeluaran = false;
  String pemasukan_filter = "";
  String pengeluaran_filter = "";
  String tglFrom = "";


  @override
  void initState() {
    super.initState();
    getDataProduk();
  }

  @override
  void dispose() {
    super.dispose();
  }


  String filter = "";
  getDataProduk() async {
    http.Response response = await http.get(
        Uri.parse(applink+"api_model.php?act=getdata_outlettransaksi&id="+widget.idOutlet+"&filter="+filter+"&hariTransaksi="+hariTransaksi+"&pemasukan_filter="+pemasukan_filter+"&pengeluaran_filter="+pengeluaran_filter),
        headers: {
          "Accept":"application/json",
          "Content-Type": "application/json"}
    );
    return json.decode(response.body);
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
          backgroundColor: HexColor(main_color),
          title: Text(
            "Riwayat Transaksi Outlet",
            style: TextStyle(
                color: Colors.white, fontFamily: 'VarelaRound', fontSize: 16),
          ),
          leading: Builder(
            builder: (context) => IconButton(
                icon: new FaIcon(FontAwesomeIcons.times,size: 20,),
                color: Colors.white,
                onPressed: () => {
                  //Navigator.pushReplacement(context, EnterPage(page: DetailOutlet(widget.idOutlet)))
                  Navigator.pop(context)
                }),
          ),
        ),
        body : Container(
            child:
            Column(
              children: [
                Padding(
                    padding: const EdgeInsets.only(left: 15,right: 15,top: 10),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                              height: 28,
                              child :
                              OutlinedButton(
                                child: Text(hariTransaksi,style: TextStyle(color: HexColor(main_color)),),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: HexColor(main_color), width: 1),
                                ),
                                onPressed: (){

                                },
                              )
                          ),
                          Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Container(
                                  height: 28,
                                  child :
                                  OutlinedButton(
                                    child: Text("Pemasukan",style: TextStyle(color: Colors.black),),
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(color: HexColor("#DDDDDD"), width: 1),
                                    ),
                                    onPressed: (){

                                    },
                                  )
                              )
                          ),
                          Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Container(
                                  height: 28,
                                  child :
                                  OutlinedButton(
                                    child: Text("Pengeluaran",style: TextStyle(color: Colors.black),),
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(color: HexColor("#DDDDDD"), width: 1),
                                    ),
                                    onPressed: (){

                                    },
                                  )
                              )
                          )
                        ],
                      ),
                    )
                ),
                Padding(padding: const EdgeInsets.only(left: 15,top: 10,right: 15),
                    child: Container(
                      height: 50,
                      child: TextFormField(
                        enableInteractiveSelection: false,
                        onChanged: (text) {
                          setState(() {
                            filter = text;
                            getDataProduk();
                          });
                        },
                        style: TextStyle(fontFamily: "VarelaRound",fontSize: 14),
                        decoration: new InputDecoration(
                          contentPadding: const EdgeInsets.all(10),
                          fillColor: HexColor("#f4f4f4"),
                          filled: true,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Icon(Icons.search,size: 18,color: HexColor("#6c767f"),),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white, width: 1.0,),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: HexColor("#f4f4f4"), width: 1.0),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          hintText: 'Cari Transaksi...',
                        ),
                      ),
                    )
                ),
                Padding(padding: const EdgeInsets.only(top: 10),),
                Expanded(
                    child:
                    FutureBuilder(
                        future : getDataProduk(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState != ConnectionState.done) {
                            return Center(
                                child :CircularProgressIndicator()
                            );
                          } else {
                            return snapshot.data == 0 ?
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
                                      ListTile(
                                          title: Column(
                                            children: [
                                              Align(alignment: Alignment.centerLeft, child: Text(
                                                snapshot.data[i]["i"]+" "+snapshot.data[i]["j"]+" "+snapshot.data[i]["f"],
                                                style: TextStyle(
                                                    fontFamily: 'VarelaRound',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13),),),
                                              Padding(padding: const EdgeInsets.only(top: 7),
                                                  child: Align(alignment: Alignment.centerLeft, child:
                                                  Opacity(
                                                      opacity: 0.7,
                                                      child: Text("#"+snapshot.data[i]["b"]+" - "+snapshot.data[i]["c"],
                                                        style: TextStyle(
                                                            fontFamily: 'VarelaRound',
                                                            fontSize: 12),))
                                                    ,))
                                            ],
                                          ),
                                          trailing:
                                          snapshot.data[i]["k"].toString().substring(0,1) == '-' ?
                                          Container(
                                            height: 22,
                                            child: RaisedButton(
                                              onPressed: (){},
                                              color: HexColor("#fe5c83"),
                                              elevation: 0,
                                              child: Text(NumberFormat.currency(
                                                  locale: 'id', decimalDigits: 0, symbol: '').format(
                                                  snapshot.data[i]["k"]),style: TextStyle(
                                                  color: HexColor("#f9fffd"), fontFamily: 'Nunito',fontSize: 12,fontWeight: FontWeight.bold)),
                                            ),
                                          )
                                              :
                                          Container(
                                            height: 22,
                                            child: RaisedButton(
                                              onPressed: (){},
                                              color: HexColor("#00aa5b"),
                                              elevation: 0,
                                              child: Text(NumberFormat.currency(
                                                  locale: 'id', decimalDigits: 0, symbol: '').format(
                                                  snapshot.data[i]["k"]),style: TextStyle(
                                                  color: HexColor("#f9fffd"), fontFamily: 'Nunito',fontSize: 12,fontWeight: FontWeight.bold)),
                                            ),
                                          )
                                      ),
                                      Divider(height: 5,)
                                    ],
                                  );
                                });


                          }

                        }

                    )
                )
              ],
            )
        ),
        bottomSheet: Visibility(
          visible: _isVisible,
          child: Container(
            width: double.infinity,
            height: 60,
            color: Colors.white,
            child: Center(
              child: SizedBox(
                child: CircularProgressIndicator(),
                height: 30.0,
                width: 30.0,
              ),
            ),
          ),
        ),
      ),
    );
  }





}