


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:moobi_flutter/Helper/api_link.dart';
import 'package:moobi_flutter/Helper/check_connection.dart';
import 'package:moobi_flutter/Helper/page_route.dart';
import 'dart:async';
import 'dart:convert';

import 'package:moobi_flutter/Helper/session.dart';
import 'package:moobi_flutter/page_login.dart';
import 'package:toast/toast.dart';


class ProdukInsert extends StatefulWidget {
    @override
    _ProdukInsertState createState() => _ProdukInsertState();
}

class _ProdukInsertState extends State<ProdukInsert> {
  String selectedValue;
  List itemList = List();
  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }

  String getEmail = '...';
  _session() async {
    int value = await Session.getValue();
    getEmail = await Session.getEmail();
    if (value != 1) {
      Navigator.pushReplacement(context, ExitPage(page: Login()));
    }
  }
  _connect() async {
    Checkconnection().check().then((internet){
      if (internet != null && internet) {} else {
        showToast("Koneksi terputus..", gravity: Toast.CENTER,
            duration: Toast.LENGTH_LONG);
      }
    });
  }

  String getBranchVal = '';
  _getBranch() async {
    final response = await http.get(
        applink+"api_model.php?act=userdetail&id="+getEmail.toString());
    Map data = jsonDecode(response.body);
    setState(() {
      getBranchVal = data["c"].toString();
    });
  }



  _prepare() async {
    await _connect();
    await _session();
    await _getBranch();
  }

  @override
  void initState(){
    super.initState();
    _prepare();
    getAllItem();
  }


  Future getAllItem() async {
    //var url = applink+"api_model.php?act=getdata_unit&id="+getBranchVal;
    var response = await http.get(
        Uri.encodeFull(applink+"api_model.php?act=getdata_unit&id="+getBranchVal));
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        itemList = jsonData;
      });
    }
    print(itemList);
  }




  Future<bool> _onWillPop() async {
    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
          appBar: new AppBar(
            backgroundColor: HexColor("#602d98"),
            leading: Builder(
              builder: (context) => IconButton(
                icon: new Icon(Icons.arrow_back),
                color: Colors.white,
                onPressed: () {
                  _onWillPop();
                }
              ),
            ),
            title: Text(
              "Input Produk Baru",
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
                child: TextFormField(
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                    style: TextStyle(fontFamily: "VarelaRound", color: Colors.black),
                    decoration: InputDecoration(
                    labelText: 'Nama Produk',
                    labelStyle: TextStyle(
                      height: 3.0,fontWeight: FontWeight.bold,fontFamily: "VarelaRound",fontSize: 18
                    ),
                    hintText: 'Contoh : Nasi Goreng, Es Jeruk',
                    hintStyle: TextStyle(height:4,fontFamily: "VarelaRound", color: HexColor("#c4c4c4")),
                    contentPadding: EdgeInsets.only(bottom: 1),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: HexColor("#DDDDDD")),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: HexColor("#8c8989")),
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: HexColor("#DDDDDD")),
                    ),
                  ),
                )
              ),

              Padding(padding: const EdgeInsets.only(left: 15,top: 10,right: 15),
                  child: Column(
                    children: [
                        Align(alignment: Alignment.centerLeft,child: Padding(
                          padding: const EdgeInsets.only(left: 0,top: 15),
                          child: Text("Satuan",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "VarelaRound",
                              fontSize: 14),),
                        ),),
                       Padding(
                         padding: const EdgeInsets.only(top:10),
                         child: DropdownButton(
                           isExpanded: true,
                           hint: Text("Pilih Satuan"),
                           value: selectedValue,
                           items: itemList.map((myitem){
                             return DropdownMenuItem(
                               value: myitem['DATA'],
                                 child: Text(myitem['DATA']+" ("+myitem['DESCRIPTION']+")")
                             );
                           }).toList(),
                           onChanged: (value) {
                             setState(() {
                                selectedValue = value;
                             });
                           },
                         ),
                       )
                    ],
                  )
              ),


            ],
          ),
        ),
      ),
    );
  }
}