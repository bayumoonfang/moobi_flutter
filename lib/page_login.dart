


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
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
    Navigator.push(context, EnterPage(page: Index()));
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
        showToast("Username atau Password tidak boleh kosong", gravity: Toast.BOTTOM, duration: Toast.LENGTH_LONG);
        return;
      } else {
        final response = await http.post("https://duakata-dev.com/moobi/m-moobi/api_model.php?act=login",
            body: {"username": _username.text, "password": _password.text});
        Map data = jsonDecode(response.body);
        setState(() {
          int getValue = data["value"];
          String emailq = data["email"].toString();
          if (getValue == 1) {
            savePref(getValue, _username.text, emailq);
            Navigator.push(context, EnterPage(page: Home()));
          } else {
            showToast("Username atau Password salah", gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
            return;
          }
        });
      }
  }


    savePref(int value, String usernameval, String emailval) async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      setState(() {
        preferences.setInt("value", value);
        preferences.setString("username", usernameval);
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
      child: Scaffold(
        body :
        Container(
          child: Center(
              child : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("assets/c.png",width: 250,),
                  Padding(padding: const EdgeInsets.only(left: 35,top: 10,right: 35),
                    child: TextFormField(
                      controller: _username,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(fontFamily: "VarelaRound",fontSize: 15),
                      decoration: new InputDecoration(
                        contentPadding: const EdgeInsets.only(top: 1,left: 10,bottom: 1),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: HexColor("#DDDDDD"), width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: HexColor("#DDDDDD"), width: 1.0),
                        ),
                        hintText: 'Username',
                      ),
                    ),
                  ),
                  Padding(padding: const EdgeInsets.only(left: 35,top: 20,right: 35),
                    child: TextFormField(
                      controller: _password,
                      obscureText: true,
                      style: TextStyle(fontFamily: "VarelaRound",fontSize: 15),
                      decoration: new InputDecoration(
                        contentPadding: const EdgeInsets.only(top: 1,left: 10,bottom: 1),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: HexColor("#DDDDDD"), width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: HexColor("#DDDDDD"), width: 1.0),
                        ),
                        hintText: 'Password',
                      ),
                    ),
                  ),
                        Padding(padding: const EdgeInsets.only(left: 35,right: 35,top: 30),child:
                              Container(
                                  height: 50,
                                  width: double.infinity,
                                  child :
                              Opacity(
                                opacity: 0.7,
                                child : RaisedButton(
                                    color: HexColor("#063761"),
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
                        )),
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