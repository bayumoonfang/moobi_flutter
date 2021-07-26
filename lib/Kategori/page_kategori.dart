


import 'dart:async';
import 'dart:convert';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:moobi_flutter/Helper/api_link.dart';
import 'package:moobi_flutter/Helper/check_connection.dart';
import 'package:moobi_flutter/Helper/page_route.dart';
import 'package:moobi_flutter/Helper/session.dart';
import 'package:moobi_flutter/page_home.dart';
import 'package:moobi_flutter/page_login.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;


class Kategori extends StatefulWidget{
  @override
  _KategoriState createState() => _KategoriState();
}


class _KategoriState extends State<Kategori> {
  List data;
  bool _isvisible = true;

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);}


  _connect() async {
  Checkconnection().check().then((internet){
    if (internet != null && internet) {} else {
      showToast("Koneksi terputus..", gravity: Toast.CENTER,duration: Toast.LENGTH_LONG);}});}


  String getEmail = '...';
  _session() async {
    int value = await Session.getValue();
    getEmail = await Session.getEmail();
    if (value != 1) {Navigator.pushReplacement(context, ExitPage(page: Login()));}}


  String getBranchVal = '';
  _getBranch() async {
    final response = await http.get(applink+"api_model.php?act=userdetail&id="+getEmail.toString());
    Map data = jsonDecode(response.body);
    setState(() {getBranchVal = data["c"].toString();});}

  Future<bool> _onWillPop() async {
    Navigator.pushReplacement(context, EnterPage(page: Home()));}


  _prepare() async {
    await _connect();
    await _session();
    await _getBranch();
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
            "branch="+getBranchVal+
            "&filter="+filter),headers: {"Accept":"application/json"});
    setState((){
      data = json.decode(response.body);
    });
  }

  String getMessage = "...";
  _doHapus (String valueParse2) async {
    final response = await http.get(applink+"api_model.php?act=action_hapuskategori&id="+valueParse2.toString()
    +"&branch="+getBranchVal);
    Map data = jsonDecode(response.body);
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
                            Navigator.pop(context);
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
                          _isvisible = false;
                          startSCreen();
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
              Visibility(
                  visible: _isvisible,
                  child :
                  Expanded(
                      child: FutureBuilder(
                        future: getData(),
                        builder: (context, snapshot){
                          if (data == null) {
                            return Center(
                                child: Image.asset(
                                  "assets/loadingq.gif",
                                  width: 110.0,
                                )
                            );
                          } else {
                            return data == 0 ?
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
                                          "Data tidak ditemukan",
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
                                  itemCount: data == null ? 0 : data.length,
                                  padding: const EdgeInsets.only(left: 10,right: 15),
                                  itemBuilder: (context, i) {
                                      return Column(
                                        children: [
                                          ListTile(
                                            title: Text(data[i]["b"].toString(), style: new TextStyle(
                                                  fontFamily: 'VarelaRound', fontSize: 15),),
                                            trailing: InkWell(
                                              onTap: (){
                                                _showDelete(data[i]["a"].toString());
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
                  )
              ),

            ],
          ),
        ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(right : 10),
            child: FloatingActionButton(
              onPressed: (){

              },
              child: FaIcon(FontAwesomeIcons.plus),
            ),
          )
      ),
    );

  }
}