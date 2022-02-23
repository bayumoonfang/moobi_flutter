

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:moobi_flutter/Gudang/page_gudangdetail.dart';
import 'package:moobi_flutter/Gudang/page_gudanginsert.dart';
import 'package:moobi_flutter/Helper/app_helper.dart';
import 'package:moobi_flutter/helper/api_link.dart';

import 'package:moobi_flutter/helper/check_connection.dart';
import 'package:moobi_flutter/helper/page_route.dart';
import 'package:moobi_flutter/helper/session.dart';

import 'package:moobi_flutter/page_home.dart';
import 'package:moobi_flutter/page_login.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:responsive_container/responsive_container.dart';
import 'package:toast/toast.dart';

import '../page_intoduction.dart';


class Gudang extends StatefulWidget{
  final String getEmail;
  final String getLegalCode;
  final String getLegalId;
  const Gudang(this.getEmail, this.getLegalCode, this.getLegalId);
  @override
  _GudangState createState() => _GudangState();
}


class _GudangState extends State<Gudang> {
  List data;
  String getFilter = '';
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


  String filter = "";
  Future<List> getData() async {
    http.Response response = await http.get(
        Uri.encodeFull(applink+"api_model.php?act=getdata_gudang&id="+widget.getLegalCode+"&filter="+filter.toString()),
        headers: {"Accept":"application/json"}
    );
     return json.decode(response.body);

  }




  FutureOr onGoBack(dynamic value) {
    getData();
    setState(() {});
  }

  _doHapus (String valueParse2) {
    Navigator.pop(context);
    http.get(applink+"api_model.php?act=action_hapusgudang&id="+valueParse2.toString()
        +"&branch="+widget.getLegalCode);
    //showToast("Gudang berhasil dihapus", gravity: Toast.BOTTOM,duration: Toast.LENGTH_LONG);
    getData();
    setState(() {});
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
              "Gudang Saya",
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
                          hintText: 'Cari Outlet...',
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
                            padding: const EdgeInsets.only(left: 10,right: 15),
                            itemBuilder: (context, i) {
                              return Column(
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      FocusScope.of(context).requestFocus(FocusNode());
                                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => GudangDetail(widget.getEmail, widget.getLegalCode, widget.getLegalId, snapshot.data[i]["c"].toString())));
                      //Navigator.push(context, ExitPage(page: GudangDetail(snapshot.data[i]["c"].toString())));*/
                                    },
                                    child: ListTile(
                                        leading:
                                        Padding(padding: const EdgeInsets.only(top: 5),
                                          child: FaIcon(FontAwesomeIcons.warehouse,color: HexColor("#602d98"),),),
                                        title: Text(snapshot.data[i]["a"], style: TextStyle(fontFamily: 'VarelaRound')),
                                        subtitle: Text(snapshot.data[i]["b"], style: TextStyle(fontFamily: 'VarelaRound',fontSize: 13)),
                                        trailing:
                                        snapshot.data[i]["a"] != 'Gudang Besar' ?
                                        Padding(
                                          padding: const EdgeInsets.only(right: 10),
                                          child: InkWell(
                                            onTap: (){
                                              FocusScope.of(context).requestFocus(FocusNode());
                                              _showDelete(snapshot.data[i]["c"].toString());
                                            },
                                            child: FaIcon(FontAwesomeIcons.trash,size: 18,color: Colors.redAccent,),
                                          ),
                                        )
                                            :
                                        Padding(padding: const EdgeInsets.only(right: 5),)
                                    ),
                                  ),
                                  Padding(padding: const EdgeInsets.only(top: 2,  left: 15,right: 15),
                                    child: Divider(height: 4,),)
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => GudangInsert(widget.getEmail, widget.getLegalCode,widget.getLegalId))).then(onGoBack);
                  // Navigator.push(context, ExitPage(page: OutletInsert()));
                },
                child: FaIcon(FontAwesomeIcons.plus),
              ),
            )
        ),
    );

  }


}