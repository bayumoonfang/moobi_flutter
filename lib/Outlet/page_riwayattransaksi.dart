


import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:moobi_flutter/Helper/api_link.dart';
import 'package:moobi_flutter/Helper/color_based.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';


class RiwayatTransaksiOutlet extends StatefulWidget {
  final String idOutlet;
  const RiwayatTransaksiOutlet(this.idOutlet);
  @override
  _RiwayatTransaksiOutlet createState() => _RiwayatTransaksiOutlet();
}

class  ProdukData {

}

class _RiwayatTransaksiOutlet extends State<RiwayatTransaksiOutlet> {

  List<String> getDatas = new List();
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    fetchFive();
  }

  @override
  void dispose() {
   // _scrollController.dispose();
    super.dispose();
  }

  
  @override
  Widget build(BuildContext context) {

    return WillPopScope(
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
                icon: new Icon(Icons.arrow_back),
                color: Colors.white,
                onPressed: () => {
                  //Navigator.pushReplacement(context, EnterPage(page: DetailOutlet(widget.idOutlet)))
                  Navigator.pop(context)
                }),
          ),
        ),
          body :ListView.builder(
            itemCount: getDatas.length,
            controller: _scrollController,
            itemBuilder: (BuildContext context, int index) {
                  return Text("ss");
            },
          )
      ),
    );
  }


  String filter = "Semua";
  String filterq = "";
  getDataProduk() async {
    http.Response response = await http.get(
        Uri.parse(applink+"api_model.php?act=getdata_produk_jual&id=NH4Z"
            "&filter="+filter+"&filterq="+filterq),
        headers: {
          "Accept":"application/json",
          "Content-Type": "application/json"}
    );
    setState(() {
      getDatas.add(json.decode(response.body)['b']);
    });
  }



  fetchFive() {
    for (int i = 0; i < 5; i++) {
      getDataProduk();
    }
  }

}