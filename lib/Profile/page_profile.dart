


import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:moobi_flutter/Helper/app_helper.dart';
import 'package:moobi_flutter/Helper/check_connection.dart';
import 'package:moobi_flutter/Helper/color_based.dart';
import 'package:moobi_flutter/Profile/page_profile_changename.dart';
import 'package:moobi_flutter/Profile/page_subscibe.dart';
import 'package:moobi_flutter/Profile/page_ubahsandi.dart';
import 'package:moobi_flutter/helper/api_link.dart';
import 'package:moobi_flutter/helper/page_route.dart';
import 'package:moobi_flutter/helper/session.dart';
import 'package:moobi_flutter/page_login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:toast/toast.dart';
class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}


class _ProfileState extends State<Profile> {
  GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
  Future<bool> _onWillPop() async {
    Navigator.pop(context);
  }
  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }

  String getEmail = "...";
  String getRole = "...";
  String getUserId = "...";
  String getRegisterDate = "...";
  String getNama = "...";
  _startingVariable() async {
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      showToast("Koneksi terputus..", gravity: Toast.CENTER,duration:
      Toast.LENGTH_LONG);}});
    await AppHelper().getSession().then((value){if(value[0] != 1) {
      Navigator.pushReplacement(context, ExitPage(page: Login()));}else{setState(() {getEmail = value[1];});}});
    await AppHelper().getDetailUser(getEmail.toString()).then((value){
      setState(() {
          getRole = value[5];
          getUserId = value[6];
          getRegisterDate = value[7];
          getNama = value[4];
      });
    });
  }

  signOut() async {
    await googleSignIn.signOut();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", null);
      preferences.setString("username", null);
      preferences.setString("email", null);
      preferences.setString("role", null);
      preferences.setString("level", null);
      preferences.commit();
      Navigator.pushReplacement(context, ExitPage(page: Login()));
    });
  }


  loadData() async {
    await _startingVariable();
  }


  @override
  void initState() {
    super.initState();
    loadData();
  }



  FutureOr onGoBack(dynamic value) {
     AppHelper().getDetailUser(getEmail.toString()).then((value){
      setState(() {
        getRole = value[5];
        getUserId = value[6];
        getRegisterDate = value[7];
        getNama = value[4];
      });
    });
    setState(() {});
  }



  @override
  Widget build(BuildContext context) {
        return WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(
            appBar: new AppBar(
              backgroundColor: HexColor(main_color),
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
                          child: FaIcon(FontAwesomeIcons.checkDouble,size: 20,),
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
                          child:

                          getRole.toString() == 'Trial' ?
                          RaisedButton(
                            onPressed: (){
                              Navigator.push(context, ExitPage(page: Subscribe()));
                            },
                            color: HexColor(main_color),
                            shape: RoundedRectangleBorder(side: BorderSide(
                                color: Colors.black,
                                width: 0.1,
                                style: BorderStyle.solid
                            ),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            child: Text("Subscribe",style: TextStyle(
                                  color: Colors.white, fontFamily: 'VarelaRound',fontSize: 13)),
                          )

                          : getRole.toString() == 'Classic' ?
                          RaisedButton(
                            onPressed: (){

                            },
                            color: HexColor(main_color),
                            shape: RoundedRectangleBorder(side: BorderSide(
                                color: Colors.black,
                                width: 0.1,
                                style: BorderStyle.solid
                            ),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            child: Text("Upgrade",style: TextStyle(
                                color: Colors.white, fontFamily: 'VarelaRound',fontSize: 13)),
                          )
                              :
                          RaisedButton(
                            color: HexColor(main_color),
                            shape: RoundedRectangleBorder(side: BorderSide(
                                color: Colors.black,
                                width: 0.1,
                                style: BorderStyle.solid
                            ),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            child: Text("Subscribed",style: TextStyle(
                                color: Colors.white, fontFamily: 'VarelaRound',fontSize: 13)),
                          )

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
                                onTap: (){
                                  Navigator.push(context, ExitPage(page: ProfileUbahNama())).then(onGoBack);
                                },
                                leading: FaIcon(FontAwesomeIcons.user,color: HexColor(third_color),),
                                title: Text("Ubah Nama",style: TextStyle(
                                    color: Colors.black, fontFamily: 'VarelaRound',fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                                trailing: FaIcon(FontAwesomeIcons.angleRight,color: HexColor(third_color),),
                              ),
                            )
                          ),
                          Padding(padding: const EdgeInsets.only(top: 5),
                          child: Divider(height: 3,),),
                          Padding(padding: const EdgeInsets.only(top: 10),
                              child: InkWell(
                                child: ListTile(
                                  onTap: (){
                                    Navigator.push(context, ExitPage(page: ProfileUbahSandi()));
                                  },
                                  leading: FaIcon(FontAwesomeIcons.lock,color: HexColor(third_color),),
                                  title: Text("Ubah Sandi Akun",style: TextStyle(
                                      color: Colors.black, fontFamily: 'VarelaRound',fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                                  trailing: FaIcon(FontAwesomeIcons.angleRight,color: HexColor(third_color),),
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
                            child: Text("Version 2.5"),),),
                            Container(
                              padding: const EdgeInsets.only(top:20,left: 25,right: 25),
                              child: Container(
                                width: double.infinity,
                                height: 40,
                                child: RaisedButton(
                                  onPressed: (){
                                    signOut();
                                  },
                                  color: HexColor(main_color),
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