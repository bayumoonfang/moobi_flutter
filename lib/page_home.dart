



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
    getUsername = await Session.getUsername();
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
              backgroundColor: Colors.white,
              elevation: 2,
              leading: Builder(
                builder: (context) => IconButton(
                  icon: new Icon(Icons.menu),
                  color: Colors.black,
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
              title: new Text(
                "Moobi : Point Of Sale",
                style: new TextStyle(
                    fontFamily: 'VarelaRound', fontSize: 16, color: HexColor("#063761"),fontWeight: FontWeight.bold),
              ),
            ),
            drawer: Drawer(
              child: ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                      color: HexColor("#063761"),
                    ),
                    accountName: new Text(getNama.toString(),
                        style: TextStyle(fontSize: 18)),
                    accountEmail: new Text(getStorename.toString()),
                    currentAccountPicture: new CircleAvatar(
                      radius: 150,
                      backgroundColor: Colors.transparent,
                      backgroundImage: AssetImage("assets/mira-ico.png"),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.exit_to_app,
                    ),
                    title:
                    Text('Logout', style: TextStyle(fontFamily: 'VarelaRound', fontSize: 18)),
                    onTap: () {
                      signOut();
                    },
                  )
                ],
              ),
            ),
            body: Container(
              color: Colors.white,
              height: double.infinity,
              width: double.infinity,
              child:
              Padding(
                padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
                child :
                    Column(
                      children: [
                        ListTile(
                            leading: FaIcon(FontAwesomeIcons.shoppingBasket,size: 20,color: Colors.black,),
                            title: Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                children: [
                                 Align(alignment: Alignment.centerLeft,child: Opacity(opacity: 0.7, child:
                                 Text("Penjualan", style: TextStyle(fontFamily: 'VarelaRound',
                                     fontSize: 13),textAlign: TextAlign.left,),),),
                                  Align(alignment: Alignment.centerLeft,child:Text("Nov-2020", style: TextStyle(fontFamily: 'VarelaRound',
                                      fontSize: 14, fontWeight: FontWeight.bold),textAlign: TextAlign.left,),),
                                ],
                              ),
                            ),
                          trailing: Text("20.000", style: TextStyle(fontFamily: 'VarelaRound',
                              fontSize: 14, fontWeight: FontWeight.bold)),
                        ),
                        Divider(height: 5,),
                        Wrap (
                          spacing: 8,
                          children: [
                            InkWell(
                              child :
                              Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child :
                                  Card(
                                      elevation: 1,
                                      child:
                                      Padding(
                                        padding: const EdgeInsets.all(18),
                                        child:
                                        Column(
                                          children: [
                                            FaIcon(FontAwesomeIcons.cubes,size: 36,),
                                            Padding(padding: const EdgeInsets.only(top:15),),
                                            Opacity(opacity: 0.9,child: Text("Produk Saya",style: TextStyle(fontFamily: "VarelaRound",fontSize: 13),),)
                                          ],
                                        ),
                                      )
                                  )
                              ), onTap: (){
                              Navigator.push(context, ExitPage(page: Produk()));
                            },),

                            InkWell(
                              child :
                              Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child :
                                  Card(
                                      elevation: 1,
                                      child:
                                      Padding(
                                        padding: const EdgeInsets.only(left: 33,top: 18,bottom: 18,right: 33),
                                        child:
                                        Column(
                                          children: [
                                            FaIcon(FontAwesomeIcons.listAlt,size: 36,),
                                            Padding(padding: const EdgeInsets.only(top:15),),
                                            Opacity(opacity: 0.9,child: Text("Kategori",style: TextStyle(fontFamily: "VarelaRound",fontSize: 13),),)
                                          ],
                                        ),
                                      )
                                  )
                              ), onTap: (){},),

                            InkWell(
                              child :
                              Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child :
                                  Card(
                                      elevation: 1,
                                      child:
                                      Padding(
                                        padding: const EdgeInsets.only(left: 35,top: 18,bottom: 18,right: 35),
                                        child:
                                        Column(
                                          children: [
                                            FaIcon(FontAwesomeIcons.box,size: 36,),
                                            Padding(padding: const EdgeInsets.only(top:15),),
                                            Opacity(opacity: 0.9,child: Text("Stock",style: TextStyle(fontFamily: "VarelaRound",fontSize: 13),),)
                                          ],
                                        ),
                                      )
                                  )
                              ), onTap: (){},),

                            InkWell(
                              child :
                              Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child :
                                  Card(
                                      elevation: 1,
                                      child:
                                      Padding(
                                        padding: const EdgeInsets.only(left: 33,top: 18,bottom: 18,right: 33),
                                        child:
                                        Column(
                                          children: [
                                            FaIcon(FontAwesomeIcons.store,size: 36,),
                                            Padding(padding: const EdgeInsets.only(top:15),),
                                            Opacity(opacity: 0.9,child: Text("Outlet",style: TextStyle(fontFamily: "VarelaRound",fontSize: 13),),)
                                          ],
                                        ),
                                      )
                                  )
                              ), onTap: (){},),

                            InkWell(
                              child :
                              Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child :
                                  Card(
                                      elevation: 1,
                                      child:
                                      Padding(
                                        padding: const EdgeInsets.only(left: 30,top: 18,bottom: 18,right: 30),
                                        child:
                                        Column(
                                          children: [
                                            FaIcon(FontAwesomeIcons.users,size: 36,),
                                            Padding(padding: const EdgeInsets.only(top:15),),
                                            Opacity(opacity: 0.9,child: Text("Customer",style: TextStyle(fontFamily: "VarelaRound",fontSize: 13),),)
                                          ],
                                        ),
                                      )
                                  )
                              ), onTap: (){},),



                          ],
                        )
                      ],
                    )

           /*   Column(
                children: [
                  InkWell(
                  child :
                      ListTile(
                            leading: FaIcon(FontAwesomeIcons.cubes,color: HexColor("#063761"),),
                            title: Text("Product Management",style: TextStyle(fontFamily: 'VarelaRound',),)
                      ),onTap: (){

                      },
                  ),
                  Divider(height: 5,),
                  InkWell(
                    child :
                    ListTile(
                        leading: FaIcon(FontAwesomeIcons.list,color: HexColor("#063761"),),
                        title: Text("Product Category",style: TextStyle(fontFamily: 'VarelaRound',),)
                    ),onTap: (){

                  },
                  ),
                  Divider(height: 5,),
                  InkWell(
                    child :
                    ListTile(
                        leading: FaIcon(FontAwesomeIcons.boxes,color: HexColor("#063761"),),
                        title: Text("Stock Management",style: TextStyle(fontFamily: 'VarelaRound',),)
                    ),onTap: (){

                  },
                  ),
                  Divider(height: 5,),
                  InkWell(
                    child :
                    ListTile(
                        leading: FaIcon(FontAwesomeIcons.users,color: HexColor("#063761"),),
                        title: Text("Customer",style: TextStyle(fontFamily: 'VarelaRound',),)
                    ),onTap: (){

                  },
                  ),
                  Divider(height: 5,),
                ],
              )*/


              ),
            ),
            bottomSheet: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded (
                    child :
                    Container(
                        height: 50,
                        child :
                        RaisedButton(
                            color: HexColor("#063761"),
                            child: Text(
                              "Mulai Jualan",
                              style: TextStyle(
                                  fontFamily: 'VarelaRound',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                              ),
                            ),
                            onPressed: () {
                              //_daftar();
                            }
                        ))
                ),
              ]
          ),
          ),
      );

  }
}