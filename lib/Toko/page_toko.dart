


import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:moobi_flutter/helper/api_link.dart';
import 'package:moobi_flutter/helper/page_route.dart';
import 'package:moobi_flutter/helper/session.dart';
import 'package:moobi_flutter/page_login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class Toko extends StatefulWidget {
  @override
  _TokoState createState() => _TokoState();
}


class _TokoState extends State<Toko> {
  Future<bool> _onWillPop() async {
    Navigator.pop(context);
  }

  String getEmail = "...";
  _session() async {
    int value = await Session.getValue();
    getEmail = await Session.getEmail();
    if (value != 1) {
      Navigator.pushReplacement(context, ExitPage(page: Login()));
    }
  }


  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", null);
      preferences.setString("username", null);
      preferences.setString("email", null);
      preferences.commit();
      Navigator.pushReplacement(context, ExitPage(page: Login()));
    });
  }

  String getStorename = "...";
  String getStoreAddress = "...";
  String getIDToko = "...";
  String getPhoneToko = "...";
  String getCityToko = "...";
  String getStatusToko = '...';
  _userDetail() async {
    final response = await http.get(
        applink+"api_model.php?act=userdetail&id="+getEmail.toString());
    Map data = jsonDecode(response.body);
    setState(() {
      getStorename = data["b"].toString();
      getStoreAddress = data["e"].toString();
      getIDToko = data["f"].toString();
      getPhoneToko = data["h"].toString();
      getCityToko = data["g"].toString();
      getStatusToko = data["i"].toString();
    });
  }

  loadData() async {
    await _session();
    await _userDetail();
  }


  @override
  void initState() {
    super.initState();
    loadData();
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: new AppBar(
          backgroundColor: HexColor("#602d98"),
          title: Text(
            "Detail Toko",
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
          height: double.infinity,
          width: double.infinity,
          child:
          SingleChildScrollView(
              child:
              Column(
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(padding: const EdgeInsets.only(top: 35,left: 15),
                          child: Text("Toko", style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold)))),

                  Padding(padding: const EdgeInsets.only(top: 20),
                    child: ListTile(
                      leading: Opacity(
                        opacity: 0.7,
                        child: CircleAvatar(
                          radius: 30,
                          child: FaIcon(FontAwesomeIcons.store),
                        ),
                      ),
                      title: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(getStorename.toString(),style: TextStyle(fontFamily: 'VarelaRound',)),),
                      subtitle: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(getStoreAddress.toString(),style: TextStyle(fontFamily: 'VarelaRound')),),
                    ),
                  ),

                  Padding(padding: const EdgeInsets.only(top :15),
                    child: Container(
                      height: 10,
                      width: double.infinity,
                      color: HexColor("#f4f4f4"),
                    ),),


                  Padding(padding: const EdgeInsets.only(top: 20,left: 25),
                    child: Column(
                      children: [
                        Align(alignment: Alignment.centerLeft,child: Text("Informasi",style: TextStyle(
                            color: Colors.black, fontFamily: 'VarelaRound',fontSize: 16,
                            fontWeight: FontWeight.bold)),),
                        Padding(padding: const EdgeInsets.only(top: 10,right: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .spaceBetween,
                            children: [
                              Text(
                                "ID Toko",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: 'VarelaRound',
                                    fontSize: 14),
                              ),
                              Text(getIDToko.toString(),
                                  style: TextStyle(
                                      fontFamily: 'VarelaRound',
                                      fontSize: 14)),
                            ],
                          ),),

                        Padding(padding: const EdgeInsets.only(top: 10,right: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .spaceBetween,
                            children: [
                              Text(
                                "Kota",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: 'VarelaRound',
                                    fontSize: 14),
                              ),
                              Text(getCityToko.toString(),
                                  style: TextStyle(
                                      fontFamily: 'VarelaRound',
                                      fontSize: 14)),
                            ],
                          ),),

                        Padding(padding: const EdgeInsets.only(top: 10,right: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .spaceBetween,
                            children: [
                              Text(
                                "Telpon Toko",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: 'VarelaRound',
                                    fontSize: 14),
                              ),
                              Text(getPhoneToko.toString(),
                                  style: TextStyle(
                                      fontFamily: 'VarelaRound',
                                      fontSize: 14)),
                            ],
                          ),),
                        Padding(padding: const EdgeInsets.only(top: 10,right: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .spaceBetween,
                            children: [
                              Text(
                                "Status Toko",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: 'VarelaRound',
                                    fontSize: 14),
                              ),
                              Text(getStatusToko.toString(),
                                  style: TextStyle(
                                      fontFamily: 'VarelaRound',
                                      fontSize: 14)),
                            ],
                          ),),

                      ],
                    ),),

                  Padding(padding: const EdgeInsets.only(top :20),
                    child: Container(
                      height: 10,
                      width: double.infinity,
                      color: HexColor("#f4f4f4"),
                    ),),


                  Padding(padding: const EdgeInsets.only(top: 20,left: 25,right: 25),
                    child: Column(
                      children: [
                        Align(alignment: Alignment.centerLeft,child: Text("Toko Saya",style: TextStyle(
                            color: Colors.black, fontFamily: 'VarelaRound',fontSize: 16,
                            fontWeight: FontWeight.bold)),),

                        Padding(padding: const EdgeInsets.only(top: 10),
                            child: InkWell(
                              child: ListTile(
                                onTap: (){},
                                leading: FaIcon(FontAwesomeIcons.edit,color: HexColor("#594d75"),),
                                title: Text("Ubah Keterangan Toko",style: TextStyle(
                                    color: Colors.black, fontFamily: 'VarelaRound',fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                                trailing: FaIcon(FontAwesomeIcons.angleRight,color: HexColor("#594d75"),),
                              ),
                            )
                        ),
                        Padding(padding: const EdgeInsets.only(top: 5),
                          child: Divider(height: 3,),),


                      ],
                    ),),


                ],
              )),
        ),
      ),

    );
  }
}