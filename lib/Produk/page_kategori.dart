


import 'dart:async';
import 'dart:convert';


import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:moobi_flutter/Helper/api_link.dart';
import 'package:moobi_flutter/Helper/app_helper.dart';
import 'package:moobi_flutter/Helper/check_connection.dart';
import 'package:moobi_flutter/Helper/page_route.dart';
import 'package:moobi_flutter/Helper/session.dart';
import 'package:moobi_flutter/Helper/setting_apps.dart';
import 'package:moobi_flutter/Produk/page_kategoriinsert.dart';
import 'package:moobi_flutter/page_home.dart';
import 'package:moobi_flutter/page_login.dart';

import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

import '../page_intoduction.dart';


class ProdukKategori extends StatefulWidget{
  final String getEmail;
  final String getLegalCode;

  const ProdukKategori(this.getEmail, this.getLegalCode);
  @override
  _ProdukKategoriState createState() => _ProdukKategoriState();
}


class _ProdukKategoriState extends State<ProdukKategori> {
  List data;
  bool _isvisible = true;

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);}

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
        Uri.encodeFull(applink+"api_model.php?act=getdata_kategori&"
            "branch="+widget.getLegalCode+
            "&filter="+filter+"&getserver="+serverCode.toString()),headers: {"Accept":"application/json"});
        return json.decode(response.body);
  }

  String getMessage = "...";
  _doHapus (String valueParse2) async {
    EasyLoading.show(status: easyloading_text);
    final response = await http.get(applink+"api_model.php?act=action_hapuskategori&id="+valueParse2.toString()+"&getserver="+serverCode.toString()
        +"&branch="+widget.getLegalCode);
    Map data = jsonDecode(response.body);
    setState(() {
      EasyLoading.dismiss();
      if (data["message"].toString() == '1') {
        showsuccess("Kategori berhasil dihapus");
        setState(() {
          getData();
        });
      } else {
        //showerror("Product sudah ada di outlet ini, silahkan cari produk yang lain");
      }
    });
  }

  _showDelete(String valueParse) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            //title: Text(),
            content: Container(
                width: double.infinity,
                height: 178,
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
                    Text("Apakah anda yakin menghapus data ini ? ",
                        style: TextStyle(fontFamily: 'VarelaRound', fontSize: 12)),)),
                    Padding(padding: const EdgeInsets.only(top: 25), child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(child: OutlineButton(
                          onPressed: () {Navigator.pop(context);}, child: Text("Tidak"),)),
                        Expanded(child: OutlineButton(
                          borderSide: BorderSide(width: 1.0, color: Colors.redAccent),
                          onPressed: () {
                            Navigator.pop(context);
                            _doHapus(valueParse);

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
              "Kategori ",
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
                          hintText: 'Cari Kategori...',
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
                              return snapshot.data == 0  || snapshot.data.length == 0 ?
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
                              ListView.builder(
                                itemCount: snapshot.data == null ? 0 : snapshot.data.length,
                                padding: const EdgeInsets.only(left: 10,right: 15),
                                itemBuilder: (context, i) {
                                  return Column(
                                    children: [
                                      ListTile(
                                        title: Text(snapshot.data[i]["b"].toString(), style: new TextStyle(
                                            fontFamily: 'VarelaRound', fontSize: 15),),
                                        trailing: InkWell(
                                          onTap: (){
                                            FocusScope.of(context).requestFocus(FocusNode());
                                            _showDelete(snapshot.data[i]["a"].toString());
                                          },
                                          child: FaIcon(FontAwesomeIcons.trash,size: 18,color: Colors.redAccent,),
                                        ),
                                      ),
                                      Padding(padding: const EdgeInsets.only(top: 0),child:
                                      Divider(height: 4,),)
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
                Navigator.push(context, ExitPage(page: ProdukKategoriInsert(widget.getEmail, widget.getLegalCode)));
              },
              child: FaIcon(FontAwesomeIcons.plus),
            ),
          )
      ),
    );

  }
}