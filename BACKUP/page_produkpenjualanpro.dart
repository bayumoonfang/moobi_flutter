




import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:moobi_flutter/Helper/app_helper.dart';
import 'package:moobi_flutter/helper/api_link.dart';
import 'package:moobi_flutter/helper/check_connection.dart';
import 'package:moobi_flutter/helper/page_route.dart';
import 'package:moobi_flutter/helper/session.dart';
import 'package:moobi_flutter/page_login.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ProdukPenjualan extends StatefulWidget{
  final String idProduk;
  const ProdukPenjualan(this.idProduk);
  @override
  _ProdukPenjualanState createState() => _ProdukPenjualanState();
}

class _ProdukPenjualanState extends State<ProdukPenjualan> {
  List data;

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }

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




  _prepare() async {
    await _startingVariable();

  }


  @override
  void initState() {
    super.initState();
    _prepare();
  }

  String filter = "";
  Future<List> getData() async {
    http.Response response = await http.get(
        Uri.encodeFull(applink+"api_model.php?act=getdata_produkpenjualan&item="+widget.idProduk.toString()+""
            "&branch="+getBranch.toString()+"&filter="+filter.toString()
          //+"&filter="+filter +"&sort="+sortby
        ),
        headers: {"Accept":"application/json"}
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
        appBar: AppBar(
          backgroundColor: HexColor("#602d98"),
          leading: Builder(
            builder: (context) => IconButton(
              icon: new Icon(Icons.arrow_back),
              color: Colors.white,
              onPressed: () => Navigator.pop(context),
            ),
          ),
          title: Text(
            "Transaksi Produk",
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'VarelaRound',
                fontSize: 16),
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
                        hintText: 'Cari Transaksi Penjualan...',
                      ),
                    ),
                  )
              ),

                  Padding(padding: const EdgeInsets.only(top: 10),),
                    Expanded(
                    child: FutureBuilder(
                        future: getData(),
                        builder: (context, snapshot) {
                          if (snapshot.data == null) {
                            return Center(
                                child: CircularProgressIndicator()
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
                                          "Silahkan lakukan input data atau cari dengan keyword lain",
                                          style: new TextStyle(
                                              fontFamily: 'VarelaRound', fontSize: 12),
                                        ),
                                      ],
                                    )))
                                :
                                ListView.builder(
                                  itemCount: snapshot.data == null ? 0 : snapshot.data.length,
                                  padding: const EdgeInsets.only(left: 5,right: 5),
                                  itemBuilder: (context, i) {
                                    return Column(
                                      children: [
                                        Padding(padding: const EdgeInsets.only(top: 5)),
                                        ListTile(
                                          title: Padding(
                                            padding: const EdgeInsets.only(top: 0),
                                            child: Row(
                                              children: [
                                                Opacity(opacity: 0.7,child: Align(alignment: Alignment.centerLeft,
                                                  child: Text(snapshot.data[i]["f"].toString() + " - "+ new DateFormat.MMM().format(DateTime.parse(snapshot.data[i]["c"])) +
                                                      " - "+snapshot.data[i]["d"].toString(),style: TextStyle(
                                                      fontFamily: 'VarelaRound', fontSize: 12,fontWeight: FontWeight.bold),),),),
                                                Padding(padding: const EdgeInsets.only(left: 5),child:
                                                FaIcon(FontAwesomeIcons.circle,size: 6,color: Colors.black,),),
                                                Padding(padding: const EdgeInsets.only(left: 5),
                                                  child: Opacity(
                                                    opacity: 0.4,
                                                    child:Align(alignment: Alignment.centerLeft,
                                                      child: Text("Jumlah : "+snapshot.data[i]["i"].toString(),style: TextStyle(
                                                          fontFamily: 'VarelaRound', fontSize: 12),),),
                                                  ),)
                                              ],
                                            )
                                          ),
                                          subtitle:         Padding(
                                            padding: const EdgeInsets.only(top: 5),
                                            child: Align(alignment: Alignment.centerLeft,
                                              child: Text("Nomor transaksi : "+snapshot.data[i]["b"].toString(),style: TextStyle(
                                                  fontFamily: 'VarelaRound', fontSize: 14,color: Colors.black),),),
                                          ),
                                          trailing: Text(
                                            "Rp "+
                                                NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: '').format(snapshot.data[i]["a"]),
                                              style :
                                              snapshot.data[i]["a"].toString().substring(0,1) == '-' ?
                                              TextStyle(
                                                  fontFamily: 'VarelaRound', fontSize: 14,
                                                  color: HexColor("#fb3464"))
                                                  :
                                              TextStyle(
                                                  fontFamily: 'VarelaRound', fontSize: 14,
                                                  color: HexColor("#41b548"),fontWeight: FontWeight.bold),

                                          ),
                                        ),
                                        Padding(padding: const EdgeInsets.only(top: 5),child:
                                        Divider(height: 4,),)
                                      ],
                                    );
                                  },
                                );

                          }
                        },
                      )
                  )
            ],
          ),
        ),
      ),
    );

  }


}