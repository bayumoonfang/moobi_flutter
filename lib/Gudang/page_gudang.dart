


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:moobi_flutter/helper/api_link.dart';
import 'package:moobi_flutter/helper/page_route.dart';
import 'package:moobi_flutter/helper/session.dart';
import 'package:moobi_flutter/page_login.dart';
import 'package:responsive_container/responsive_container.dart';


class Gudang extends StatefulWidget{
  @override
  GudangState createState() => new GudangState();
}

class GudangState extends State<Gudang> {
  List data;

  String getEmail = "...";
  _session() async {
    int value = await Session.getValue();
    getEmail = await Session.getEmail();
    if (value != 1) {
      Navigator.pushReplacement(context, ExitPage(page: Login()));
    }
  }

  loadData() async {
    await _session();
  }


  @override
  void initState() {
    super.initState();
    loadData();
  }



  Future<List> getData() async {
    http.Response response = await http.get(
        Uri.encodeFull(applink+"api_script.php?act=getdata_gudang&id="+getEmail.toString()),
        headers: {"Accept":"application/json"}
    );
    setState((){
      data = json.decode(response.body);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: new AppBar(
          backgroundColor: HexColor("#602d98"),
          title: Text(
            "Gudang",
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
        body: ResponsiveContainer(
          widthPercent: 100,
          heightPercent: 20,
          child: Column(
            children: [
              Padding(padding: const EdgeInsets.only(left: 15,top: 10,right: 15),
                child: TextFormField(
                  //controller: _namatoko,
                  style: TextStyle(fontFamily: "VarelaRound",fontSize: 15),
                  decoration: new InputDecoration(
                    filled: true,
                    fillColor: HexColor("#DDDDDD"),
                    contentPadding: const EdgeInsets.only(top: 1,left: 10,bottom: 1),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: HexColor("#DDDDDD"), width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: HexColor("#DDDDDD"), width: 1.0),
                    ),
                    hintText: 'Pencarian',
                    prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 20,top:14,right: 10),
                        child: Opacity(
                          opacity: 0.8,
                          child: FaIcon(FontAwesomeIcons.search,color: Colors.black,size: 14,),
                        )
                    ),
                  ),
                ),
              ),


            ],
          ),
        )
      ),
    );

  }
}