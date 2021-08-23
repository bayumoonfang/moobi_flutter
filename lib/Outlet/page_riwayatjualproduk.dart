



import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:moobi_flutter/Helper/api_link.dart';
import 'package:moobi_flutter/Helper/color_based.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;


class RiwayatJualProduk extends StatefulWidget{
  final String idOutlet;
  const RiwayatJualProduk(this.idOutlet);
  @override
  _RiwayatJualProduk createState() => _RiwayatJualProduk();
}


class _RiwayatJualProduk extends State<RiwayatJualProduk> {

  List getDatas = new List();
  bool _isVisible = false;
  ScrollController _scrollController = new ScrollController();
  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }

  String limit = "30";
  int temp_limit;

  startLoading() async {
    Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {
        getDataProduk();
      });
    });
  }


  @override
  void initState() {
    super.initState();
    getDataProduk();
    _scrollController.addListener(() {
      //print(applink+"api_model.php?act=getdata_outletjualproduk&id="+widget.idOutlet+"&limit="+limit+"&filter="+filter);
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
        setState(() {
          temp_limit = int.parse(limit) + 5;
          limit = temp_limit.toString();
          _isVisible = true;
          startLoading();
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  var refreshKey = GlobalKey<RefreshIndicatorState>();
  Future refreshData() async {
    getDatas.clear();
    refreshKey.currentState?.show();
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      getDataProduk();
    });
    return null;
  }


  String filter = "";
  getDataProduk() async {
    http.Response response = await http.get(
        Uri.parse(applink+"api_model.php?act=getdata_outletjualproduk&id="+widget.idOutlet+"&limit="+limit+"&filter="+filter),
        headers: {
          "Accept":"application/json",
          "Content-Type": "application/json"}
    );
    if(response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        getDatas = jsonData;
        _isVisible = false;
      });
    }
    //print(applink+"api_model.php?act=getdata_outletjualproduk&id="+widget.idOutlet+"&limit="+limit+"&filter="+filter);
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
                "Riwayat Penjualan Produk Outlet",
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
            body: Container(
              child: Column(
                children: [
                  Padding(padding: const EdgeInsets.only(left: 15,top: 10,right: 15),
                      child: Container(
                        height: 50,
                        child: TextFormField(
                          enableInteractiveSelection: false,
                          onChanged: (text) {
                            setState(() {
                               filter = text;
                               print(applink+"api_model.php?act=getdata_outletjualproduk&id="+widget.idOutlet+"&limit="+limit+"&filter="+filter);

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
                        ListView.builder(
                        itemCount: getDatas.length,
                        controller: _scrollController,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              ListTile(
                                  title: Column(
                                    children: [
                                      Align(alignment: Alignment.centerLeft, child: Text(
                                        getDatas[index]["i"],
                                        overflow: TextOverflow.ellipsis,
                                        //getDatas[index]["l"]+" "+getDatas[index]["m"]+" "+getDatas[index]["j"],
                                        style: TextStyle(
                                            fontFamily: 'VarelaRound',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13),),),
                                      Padding(padding: const EdgeInsets.only(top: 7),
                                          child: Align(alignment: Alignment.centerLeft, child:
                                          Opacity(
                                              opacity: 0.7,
                                              child: Text("#"+getDatas[index]["l"]+" "+getDatas[index]["m"]+" "+getDatas[index]["j"]+" - "+getDatas[index]["e"],
                                                style: TextStyle(
                                                    fontFamily: 'VarelaRound',
                                                    fontSize: 12),))
                                            ,))
                                    ],
                                  ),
                                  trailing:
                                  getDatas[index]["d"].toString().substring(0,1) == '-' ?
                                  Container(
                                    height: 22,
                                    child: RaisedButton(
                                      onPressed: (){},
                                      color: HexColor("#fe5c83"),
                                      elevation: 0,
                                      child: Text(getDatas[index]["d"].toString(),style: TextStyle(
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
                                      child: Text(getDatas[index]["d"].toString(),style: TextStyle(
                                          color: HexColor("#f9fffd"), fontFamily: 'Nunito',fontSize: 12,fontWeight: FontWeight.bold)),
                                    ),
                                  )
                              ),
                              Divider(height: 5,)
                            ],
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ));
  }
}