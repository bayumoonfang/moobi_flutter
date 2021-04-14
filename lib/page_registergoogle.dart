


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:moobi_flutter/Helper/api_link.dart';
import 'package:moobi_flutter/Helper/check_connection.dart';
import 'package:moobi_flutter/Helper/color_based.dart';
import 'package:moobi_flutter/Helper/page_route.dart';
import 'package:moobi_flutter/page_home.dart';
import 'package:moobi_flutter/page_login.dart';
import 'package:moobi_flutter/page_successregister.dart';
import 'package:responsive_container/responsive_container.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;


class RegisterGoogle extends StatefulWidget{
  final String parEmail;
  final String parUsername;


  const RegisterGoogle(this.parEmail, this.parUsername);
  @override
  _RegisterGoogleState createState() => _RegisterGoogleState();
}

class _RegisterGoogleState extends State<RegisterGoogle> {
  final _password = TextEditingController();
  final _namatoko = TextEditingController();
  bool _isPressed = false;

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }

  Future<bool> _onWillPop() async {
    Navigator.pushReplacement(context, EnterPage(page: Login()));
  }


  _connect() async {
    Checkconnection().check().then((internet){
      if (internet != null && internet) {} else {
        showToast("Koneksi terputus..", gravity: Toast.CENTER,
            duration: Toast.LENGTH_LONG);
        return ;
      }
    });
  }


  String getMessage;
  _daftar() async {
    if (_password.text == '' || _namatoko.text == '') {
      setState(() {
        _isPressed = false;
      });
      showToast("Form tidak boleh kosong", gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }  else {
      final response = await http.post(
          applink+"api_model.php?act=register",
          body: {
            "nama": widget.parUsername.toString(),
            "email": widget.parEmail.toString(),
            "password": _password.text.toString(),
            "namatoko": _namatoko.text.toString()
          }).timeout(Duration(seconds: 20),
          onTimeout: (){
            setState(() {
              _isPressed = false;
            });
            showToast("Koneksi timeout , mohon periksa jaringan anda..", gravity: Toast.CENTER,
                duration: Toast.LENGTH_LONG);
            return;
          });
      Map showdata = jsonDecode(response.body);
      getMessage = showdata["message"].toString();
      setState(() {
        getMessage = showdata["message"].toString();
        if (getMessage == '0') {
          showToast("Nama toko sudah ada... coba dengan yang lain", gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
          return;
        } else if (getMessage == '1') {
          showToast("Email sudah terdaftar", gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
          return;
        } else if (getMessage == '2') {
          savePref(1, widget.parEmail);
          Navigator.pushReplacement(context, EnterPage(page: Home()));
        }
        setState(() {
          _isPressed = false;
        });
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



  @override
  void initState() {
    super.initState();

  }



  @override
  Widget build(BuildContext context) {
      return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: new AppBar(
            backgroundColor: HexColor(main_color),
            leading: Builder(
              builder: (context) => IconButton(
                  icon: new Icon(Icons.arrow_back,size: 20,),
                  color: Colors.white,
                  onPressed: () => {
                    Navigator.push(context, EnterPage(page: Login()))
                  }),
            ),
            title: Text("Daftar Pengguna Baru", style: TextStyle(
                fontFamily: 'VarelaRound',
                color: Colors.white,fontSize: 16
            ),),
          ),
          body: Container(
            child: Column(
              children: [
                Padding(padding: const EdgeInsets.only(top:30,left: 15),
                  child: Align(alignment: Alignment.centerLeft,
                    child: Text("Lengkapi Data", style: TextStyle(fontFamily: "VarelaRound",fontSize: 20,fontWeight: FontWeight.bold),),
                  ),),
                Padding(padding: const EdgeInsets.only(top:5,left: 15),
                  child: Align(alignment: Alignment.centerLeft,
                    child: Text("Yuk lengkapi data kamu untuk melanjutkan registrasi..",
                        style: TextStyle(fontFamily: "VarelaRound",fontSize: 13)),
                  ),),

                Padding(padding: const EdgeInsets.only(left: 15,top: 10,right: 15),
                  child: TextFormField(
                    controller: _namatoko,
                    textCapitalization: TextCapitalization.words,
                    style: TextStyle(fontFamily: "VarelaRound",fontSize: 15),
                    decoration: new InputDecoration(
                      contentPadding: const EdgeInsets.only(top: 1,left: 10,bottom: 1),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: HexColor("#DDDDDD"), width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: HexColor("#DDDDDD"), width: 1.0),
                      ),
                      hintText: 'Nama Toko',
                    ),
                  ),
                ),

                Padding(padding: const EdgeInsets.only(left: 15,top: 20,right: 15),
                  child: TextFormField(
                    controller: _password,
                    style: TextStyle(fontFamily: "VarelaRound",fontSize: 15),
                    decoration: new InputDecoration(
                      contentPadding: const EdgeInsets.only(top: 1,left: 10,bottom: 1),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: HexColor("#DDDDDD"), width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: HexColor("#DDDDDD"), width: 1.0),
                      ),
                      hintText: 'Password Akun',
                    ),
                  ),
                ),

                Padding(padding: const EdgeInsets.only(left: 17,top: 10,right: 15),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Digunakan untuk login sebagai user jika anda kehilangan akun google anda",
                        style: TextStyle(fontFamily: "VarelaRound",fontSize: 10))
                  )
                ),

              ResponsiveContainer(widthPercent: 10, heightPercent: 30),
              Visibility(
                visible: _isPressed,
                child:
                Center(
                    child: Image.asset(
                      "assets/loadingq.gif",
                      width: 110.0,
                    )
                )
                ,
              )





              ],
            ),
          ),
          bottomSheet:
          Container(
            color: Colors.white,
            height: 160,
            width: double.infinity,
            child:
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child:  Container(
                      color: Colors.white,
                      height: 50,
                      padding: const EdgeInsets.only(left: 25,right: 25),
                      width: 250,
                      child :
                      RaisedButton(
                          shape: RoundedRectangleBorder(side: BorderSide(
                              color: Colors.black,
                              width: 0.1,
                              style: BorderStyle.solid
                          ),
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          color: HexColor(main_color),
                          child: Text(
                            "Daftar Sekarang",
                            style: TextStyle(
                                fontFamily: 'VarelaRound',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _isPressed = true;
                              _daftar();
                            });

                          }
                      )),
                ),
              ],
            ),
          )
        ),
      );
  }
}