


import 'dart:convert';

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
class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}


class _ProfileState extends State<Profile> {
  Future<bool> _onWillPop() async {
    Navigator.pop(context);
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


  String getEmail = "...";
  _session() async {
    int value = await Session.getValue();
    getEmail = await Session.getEmail();
    if (value != 1) {
      Navigator.pushReplacement(context, ExitPage(page: Login()));
    }
  }



  String getNama = "...";
  String getUsername = "...";
  String getRole = "...";
  String getUserId = "...";
  String getRegisterDate = "...";

  _userDetail() async {
    final response = await http.get(
        applink+"api_model.php?act=userdetail&id="+getEmail.toString());
    Map data = jsonDecode(response.body);
    setState(() {
      getNama = data["j"].toString();
      getUsername = data["k"].toString();
      getRole = data["l"].toString();
      getUserId = data["m"].toString();
      getRegisterDate = data["n"].toString();
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
                "Profile Saya",
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
                        child: Text("Profile", style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold)))),

                    Padding(padding: const EdgeInsets.only(top: 20),
                        child: ListTile(
                                leading: Opacity(
                                  opacity: 0.7,
                                  child: CircleAvatar(
                                    radius: 30,
                                    child: Image.asset("assets/userimg2.png"),
                                  ),
                                ),
                          title: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(getNama.toString(),style: TextStyle(fontFamily: 'VarelaRound',)),),
                          subtitle: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(getEmail.toString(),style: TextStyle(fontFamily: 'VarelaRound')),),
                        ),
                    ),
                    Padding(padding: const EdgeInsets.only(left: 15,right: 15,top: 10),
                    child: Divider(height: 3,),),
                    Padding(padding: const EdgeInsets.only(left: 15,right: 15),
                      child: ListTile(
                        leading: Opacity(
                          opacity: 0.6,
                          child: FaIcon(FontAwesomeIcons.checkDouble),
                        ),
                          title: Opacity(
                            opacity: 0.6,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text("MOOBIE "+getRole.toString(),style: TextStyle(fontWeight: FontWeight.bold
                                  , fontFamily: 'VarelaRound')),),
                          ),
                        trailing: Container(
                          height: 30,
                          child: RaisedButton(
                            onPressed: (){

                            },
                            color: HexColor("#602d98"),
                            shape: RoundedRectangleBorder(side: BorderSide(
                                color: Colors.black,
                                width: 0.1,
                                style: BorderStyle.solid
                            ),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            child: Text("Upgrade",style: TextStyle(
                                  color: Colors.white, fontFamily: 'VarelaRound',fontSize: 13)),
                          ),
                        )
                      ),),
                    Padding(padding: const EdgeInsets.only(top :0),
                    child: Container(
                      height: 10,
                      width: double.infinity,
                      color: HexColor("#f4f4f4"),
                    ),),


                    Padding(padding: const EdgeInsets.only(top: 20,left: 25),
                    child: Column(
                      children: [
                        Align(alignment: Alignment.centerLeft,child: Text("MOOBIE ID",style: TextStyle(
                            color: Colors.black, fontFamily: 'VarelaRound',fontSize: 16,
                            fontWeight: FontWeight.bold)),),
                        Padding(padding: const EdgeInsets.only(top: 10,right: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .spaceBetween,
                            children: [
                              Text(
                                "User ID",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: 'VarelaRound',
                                    fontSize: 14),
                              ),
                              Text(getUserId.toString(),
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
                                "Register Date",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: 'VarelaRound',
                                    fontSize: 14),
                              ),
                              Text(getRegisterDate.toString(),
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
                          Align(alignment: Alignment.centerLeft,child: Text("Akun Saya",style: TextStyle(
                              color: Colors.black, fontFamily: 'VarelaRound',fontSize: 16,
                              fontWeight: FontWeight.bold)),),

                          Padding(padding: const EdgeInsets.only(top: 10),
                            child: InkWell(
                              child: ListTile(
                                onTap: (){},
                                leading: FaIcon(FontAwesomeIcons.user,color: HexColor("#594d75"),),
                                title: Text("Ubah Profile",style: TextStyle(
                                    color: Colors.black, fontFamily: 'VarelaRound',fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                                trailing: FaIcon(FontAwesomeIcons.angleRight,color: HexColor("#594d75"),),
                              ),
                            )
                          ),
                          Padding(padding: const EdgeInsets.only(top: 5),
                          child: Divider(height: 3,),),
                          Padding(padding: const EdgeInsets.only(top: 10),
                              child: InkWell(
                                child: ListTile(
                                  onTap: (){},
                                  leading: FaIcon(FontAwesomeIcons.lock,color: HexColor("#594d75"),),
                                  title: Text("Ubah Sandi Akun",style: TextStyle(
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

                    Container(
                      color: HexColor("#f4f4f4"),
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                            Padding(padding: const EdgeInsets.only(left: 25),child:   Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Version 2.1"),),),
                            Container(
                              padding: const EdgeInsets.only(top:20,left: 25,right: 25),
                              child: Container(
                                width: double.infinity,
                                height: 40,
                                child: RaisedButton(
                                  onPressed: (){
                                    signOut();
                                  },
                                  color: HexColor("#602d98"),
                                  shape: RoundedRectangleBorder(side: BorderSide(
                                      color: Colors.black,
                                      width: 0.1,
                                      style: BorderStyle.solid
                                  ),
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                  child: Text("LogOut",style: TextStyle(
                                      color: Colors.white, fontFamily: 'VarelaRound')),
                                ),
                              ),
                            )
                          ],
                        )
                      ),
                    )

                  ],
                )),
              ),
            ),

        );
  }
}