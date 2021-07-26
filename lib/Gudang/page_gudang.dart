

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
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


class Gudang extends StatefulWidget{
  @override
  _GudangState createState() => _GudangState();
}


class _GudangState extends State<Gudang> {
  List data;
  String getFilter = '';
  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }


  String getEmail = "...";
  _startingVariable() async {
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      showToast("Koneksi terputus..", gravity: Toast.CENTER,duration:
      Toast.LENGTH_LONG);}});
    await AppHelper().getSession().then((value){if(value[0] != 1) {
      Navigator.pushReplacement(context, ExitPage(page: Login()));}else{setState(() {getEmail = value[1];});}});
  }




  String filter = "";
  Future<List> getData() async {
    http.Response response = await http.get(
        Uri.encodeFull(applink+"api_model.php?act=getdata_gudang&id="+getEmail+"&filter="+filter.toString()),
        headers: {"Accept":"application/json"}
    );
     return json.decode(response.body);

  }

  _prepare() async {
    await _startingVariable();
  }

  @override
  void initState() {
    super.initState();
    _prepare();
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
                onPressed: () => Navigator.push(context, EnterPage(page: Home())),
              ),
            ),
            title: Text(
              "Gudang Saya",
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
                          hintText: 'Cari Gudang...',
                        ),
                      ),
                    )
                ),
                Padding(padding: const EdgeInsets.only(top: 10),),
                Expanded(child: _dataField())
              ],
            ),
          ),

          floatingActionButton:
          Padding(
            padding: const EdgeInsets.only(right : 10),
            child: FloatingActionButton(
              onPressed: (){},
              child: FaIcon(FontAwesomeIcons.plus),
            ),
          )
        //floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Widget _dataField() {
    return FutureBuilder(
      future : getData(),
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
          new ListView.builder(
            itemCount: snapshot.data == null ? 0 : snapshot.data.length,
            padding: const EdgeInsets.only(top: 2,bottom: 80,left: 5,right: 5),
            itemBuilder: (context, i) {
              return Column(
                children: <Widget>[
                  InkWell(
                    onTap: () {

                    },
                    child: ListTile(
                        leading:
                        Padding(padding: const EdgeInsets.only(top: 5),
                        child: FaIcon(FontAwesomeIcons.warehouse,color: HexColor("#602d98"),),),
                        title: Text(snapshot.data[i]["a"]),
                        subtitle: Text(snapshot.data[i]["b"]),

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
    );
  }


}