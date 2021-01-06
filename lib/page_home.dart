



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:moobi_flutter/helper/check_connection.dart';
import 'package:moobi_flutter/helper/page_route.dart';
import 'package:moobi_flutter/helper/session.dart';
import 'package:moobi_flutter/page_login.dart';
import 'package:moobi_flutter/page_produk.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}


class _HomeState extends State<Home> {
  String getUsername, getEmail = "";
  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }

  int backPressCounter = 0;
  int backPressTotal = 2;
  Future<bool> _onWillPop() async {
    if (backPressCounter < 2) {
      showToast("Tap back 2x , untuk keluar aplikasi", gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      backPressCounter++;
      Future.delayed(Duration(seconds: 1, milliseconds: 300), () {
        backPressCounter--;
      });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  _session() async {
    int value = await Session.getValue();
    getEmail = await Session.getEmail();
    //getUsername = await Session.getUsername();
    if (value != 1) {
      Navigator.push(context, ExitPage(page: Login()));
    }
  }
  _connect() async {
    Checkconnection().check().then((internet){
      if (internet != null && internet) {
        // Internet Present Case
      } else {
        showToast("Koneksi terputus..", gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      }
    });
  }


  String getNama,
      getStorename = '';
  _userDetail() async {
    final response = await http.get(
        "https://duakata-dev.com/moobi/m-moobi/api_model.php?act=userdetail&id="+getUsername.toString());
    Map data = jsonDecode(response.body);
    setState(() {
      getNama = data["a"].toString();
      getStorename = data["b"].toString();
    });
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", null);
      preferences.setString("username", null);
      preferences.setString("email", null);
      preferences.commit();
      Navigator.push(context, ExitPage(page: Login()));
    });
  }

  void _loaddata() async {
    await  _connect();
    await _session();
    await _userDetail();
  }


  @override
  void initState() {
    super.initState();
    _loaddata();
  }




  @override
  Widget build(BuildContext context) {
      return WillPopScope(
        onWillPop: _onWillPop,
          child: Scaffold(
            //backgroundColor: Colors.white,
            appBar: new AppBar(
              backgroundColor: HexColor("#602d98"),
              automaticallyImplyLeading: false,
              actions: [
                Padding(padding: const EdgeInsets.only(top: 19,right: 35), child :
                FaIcon(FontAwesomeIcons.search, size: 18,)),
                Padding(padding: const EdgeInsets.only(top: 19,right: 25), child :
                InkWell(
                  child : FaIcon(FontAwesomeIcons.heart, size: 18,),
                  onTap: () {
                    signOut();
                  },
                )
                ),
              ],
              title:
              Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child:   Text("Moobie", style: TextStyle(color: Colors.white,
                      fontFamily: 'VarelaRound', fontSize: 24,
                      fontWeight: FontWeight.bold),)
              ),
              elevation: 0.5,
              centerTitle: false,
            ),
            body:
                Stack(
                  children: [
                    ClipPath(
                      clipper: MyClipper(),
                      child: Container(
                          width: double.infinity,
                          height: 220,
                          color:  HexColor("#602d98"),
                          child: Stack(
                            children: [
                              Column(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.only(left: 28,top: 15),
                                      child:  Align(
                                        alignment: Alignment.bottomLeft,
                                        child:  Text("Toko Abadi Jaya", style: TextStyle(color: Colors.white,
                                            fontFamily: 'VarelaRound', fontSize: 12,
                                            fontWeight: FontWeight.bold),textAlign: TextAlign.left,),
                                      )
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(left: 28,top: 5),
                                      child:  Align(
                                        alignment: Alignment.bottomLeft,
                                        child:  Text("Rp. 26.800.000", style: TextStyle(color: Colors.white,
                                            fontFamily: 'VarelaRound', fontSize: 22,
                                            fontWeight: FontWeight.bold),textAlign: TextAlign.left,),
                                      )
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(left: 28,top: 5),
                                      child:  Align(
                                          alignment: Alignment.bottomLeft,
                                          child:  Opacity(
                                            opacity: 0.7,
                                            child: Text("December 2021", style: TextStyle(color: Colors.white,
                                                fontFamily: 'VarelaRound', fontSize: 11,
                                                fontWeight: FontWeight.bold),textAlign: TextAlign.left,),
                                          )
                                      )
                                  ),
                                ],
                              )
                            ],
                          )
                      ),
                    ),
                      Padding(
                        padding: const EdgeInsets.only(top: 105,left: 25,right: 25),
                        child:
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 4,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        height: 80,
                        width: double.infinity,
                        child:
                            Expanded(
                              child:
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15,left: 15,right: 15),
                                    child:
                                    Wrap(
                                      alignment: WrapAlignment.center,
                                      spacing: 50,
                                      children: [
                                        Column(
                                          children: [
                                            FaIcon(FontAwesomeIcons.user),
                                            Padding(padding: const EdgeInsets.only(top:8),
                                            child: Text("Profile", style: TextStyle(fontFamily: 'VarelaRound',fontSize: 12)),)
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            FaIcon(FontAwesomeIcons.store),
                                            Padding(padding: const EdgeInsets.only(top:8),
                                              child: Text("Toko Saya", style: TextStyle(fontFamily: 'VarelaRound',fontSize: 12)),)
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            FaIcon(FontAwesomeIcons.warehouse),
                                            Padding(padding: const EdgeInsets.only(top:8),
                                              child: Text("Gudang", style: TextStyle(fontFamily: 'VarelaRound',fontSize: 12)),)
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                            )
                      ),)

                  ],
                )

          ),
      );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height-100);
    path.quadraticBezierTo(size.width/2, size.height, size.width, size.height-100);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return null;
  }
}