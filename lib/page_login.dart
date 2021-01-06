


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:moobi_flutter/helper/api_link.dart';
import 'package:moobi_flutter/helper/check_connection.dart';
import 'package:moobi_flutter/helper/page_route.dart';
import 'package:moobi_flutter/page_home.dart';
import 'package:moobi_flutter/page_index.dart';
import 'package:moobi_flutter/page_register.dart';
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();

}


class _LoginState extends State<Login> {
    final _username = TextEditingController();
    final _password = TextEditingController();
    String _email = '';
    void showToast(String msg, {int duration, int gravity}) {
      Toast.show(msg, context, duration: duration, gravity: gravity);
    }

  Future<bool> _onWillPop() async {
  }

    _connect() async {
      Checkconnection().check().then((internet){
        if (internet != null && internet) {
          // Internet Present Case
        } else {
          showToast("Koneksi internet anda terputus..", gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        }
      });
    }


  _login() async {
      if(_username.text == '' || _password.text == '') {
        showToast("Form tidak boleh kosong", gravity: Toast.BOTTOM, duration: Toast.LENGTH_LONG);
        return;
      } else {
        final response = await http.post(applink+"api_model.php?act=login",
            body: {"username": _username.text, "password": _password.text});
        Map data = jsonDecode(response.body);
        setState(() {
          int getValue = data["value"];
          if (getValue == 1) {
            savePref(getValue, _username.text);
            Navigator.push(context, EnterPage(page: Home()));
          } else {
            showToast("Email atau Password salah", gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
            return;
          }
        });
      }
  }

    savePref(int value, String emailval) async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      setState(() {
        preferences.setInt("value", value);
        preferences.setString("email", emailval);
        preferences.commit();
      });
    }

    _loginact() async {
      await _connect();
      await _login();
    }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body :
        Container(
          child: Center(
              child : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("assets/logo4.png",width: 150,),
                  Padding(padding: const EdgeInsets.only(left: 35,top: 60,right: 35),
                    child:   TextFormField(
                      style: TextStyle(
                          fontFamily: 'VarelaRound', fontSize: 17),
                      validator: (e) {
                        if (e.isEmpty) {
                          return "Username tidak boleh kosong";
                        }
                      },
                      controller: _username,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 20,top:10,right: 10),
                          child: Opacity(
                            opacity: 0.8,
                            child: FaIcon(FontAwesomeIcons.envelope,color: Colors.black,size: 20,),
                          )
                        ),
                        hintText: "Email",
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                            color: HexColor("#602d98"),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                            color: HexColor("#dbd0ea"),
                            width: 1.0,
                          ),
                        ),

                      ),
                    ),
                  ),
                  Padding(padding: const EdgeInsets.only(left: 35,top: 20,right: 35),
                    child: TextFormField(
                      style: TextStyle(
                          fontFamily: 'VarelaRound', fontSize: 17),
                      validator: (e) {
                        if (e.isEmpty) {
                          return "Email tidak boleh kosong";
                        }
                      },
                      controller: _password,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 20,top:10,right: 10),
                          child: Opacity(
                            opacity: 0.8,
                            child: FaIcon(FontAwesomeIcons.lock,color: Colors.black,size: 20,),
                          )
                        ),
                        hintText: "Password",
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                            color: HexColor("#602d98"),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                            color: HexColor("#dbd0ea"),
                            width: 1.0,
                          ),
                        ),

                      ),
                    ),
                  ),
                        Padding(padding: const EdgeInsets.only(left: 35,right: 35,top: 30),child:
                              Container(
                                  height: 50,
                                  width: double.infinity,
                                  child :
                      RaisedButton(
                          shape: RoundedRectangleBorder(side: BorderSide(
                              color: Colors.black,
                              width: 0.1,
                              style: BorderStyle.solid
                          ),
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                                    color: HexColor("#602d98"),
                                    child: Text(
                                      "Sign In",
                                      style: TextStyle(
                                          fontFamily: 'VarelaRound',
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white
                                      ),
                                    ),
                                    onPressed: () {
                                      _loginact();
                                    }
                                )
                          )
                        ),
                  Center(
                    child:
                    Padding(padding: const EdgeInsets.only(left: 35,right: 35,top: 30),child:
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Anda tidak mempunyai akun ?",textAlign: TextAlign.center,style: TextStyle(fontFamily: 'VarelaRound'),),
                            Padding(padding: const EdgeInsets.only(left: 10),child:
                            InkWell(
                              child: Text("Daftar",style: TextStyle(color: Colors.blue,fontFamily: 'VarelaRound',fontWeight: FontWeight.bold),),
                              onTap: (){
                                Navigator.push(context, ExitPage(page: Register()));
                              },
                            ),)
                          ],
                        )
                    ),
                  )
                ]
              )
          ),
        ),
      )
    );
  }
}