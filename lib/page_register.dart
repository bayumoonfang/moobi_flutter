


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:moobi_flutter/Helper/color_based.dart';
import 'package:moobi_flutter/helper/api_link.dart';
import 'package:moobi_flutter/page_index.dart';
import 'package:moobi_flutter/page_login.dart';
import 'package:moobi_flutter/page_registergoogle.dart';
import 'package:moobi_flutter/page_successregister.dart';
import 'package:toast/toast.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'helper/page_route.dart';


class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}


class _RegisterState extends State<Register> {
  final _nama = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _namatoko = TextEditingController();
  final _alamattoko = TextEditingController();
  final _nomortoko = TextEditingController();
  GoogleSignIn _googleSignIn =  GoogleSignIn(scopes: ['email']);
  String authEmail = '';
  String autUsername = '';
  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }
  String getMessage;




  Future<bool> _onWillPop() async {
    Navigator.pop(context);
  }

  _daftargoogle() async {
    try {
      await _googleSignIn.signIn();
      setState(() {
        authEmail = _googleSignIn.currentUser.email;
        autUsername = _googleSignIn.currentUser.displayName;
        if (authEmail != '') {
          _cekRegister(authEmail);
        } else {
          showToast("Register Gagal", gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
          return;
        }
      });
    }
    catch(err) {
      print(err);
    }
  }


  _cekRegister(String emailGoogle) async{
    final response = await http.post(
        applink+"api_model.php?act=cekregister",
        body: {
          "email": emailGoogle.toString()
        });
    Map showdata = jsonDecode(response.body);
    setState(() {
      if (showdata["message"].toString() == '1') {
        _googleSignIn.signOut();
        showToast("Mohon maaf email sudah terdaftar", gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        return;
      } else {
        Navigator.pushReplacement(context, EnterPage(page: RegisterGoogle(authEmail,autUsername)));
        _googleSignIn.signOut();
      }
    });
  }

  _daftar() async {
    if (_nama.text == '' || _email.text == '' || _password.text == '' || _namatoko.text == '' || _alamattoko.text == '' || _nomortoko.text == '') {
      showToast("Form tidak boleh kosong", gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }  else {
      final response = await http.post(
          applink+"api_model.php?act=register",
          body: {
            "nama": _nama.text.toString(),
            "email": _email.text.toString(),
            "password": _password.text.toString(),
            "namatoko": _namatoko.text.toString(),
            "alamattoko": _alamattoko.text.toString(),
            "nomortoko": _nomortoko.text.toString()
          });
          Map showdata = jsonDecode(response.body);
          getMessage = showdata["message"].toString();
          setState(() {
            getMessage = showdata["message"].toString();
              if (getMessage == '0') {
                showToast("Nama Toko atau ID Toko sudah ada... coba dengan yang lain", gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
                return;
              } else if (getMessage == '1') {
                showToast("Email sudah terdaftar", gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
                return;
              } else if (getMessage == '3') {
                showToast("Nomor anda sudah terdaftar", gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
                return;
              } else if (getMessage == '2') {
                Navigator.push(context, ExitPage(page: SuksesRegister(_email.text)));
              }
          });
    }
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
                    color: Colors.white,
                    height: double.infinity,
                    child:
                    SingleChildScrollView(child :
                    Column (
                      children: [
                          Padding(padding: const EdgeInsets.only(top:30,left: 15),
                            child: Align(alignment: Alignment.centerLeft,
                              child: Text("Kenalin diri kamu", style: TextStyle(fontFamily: "VarelaRound",fontSize: 20,fontWeight: FontWeight.bold),),
                          ),),
                        Padding(padding: const EdgeInsets.only(top:5,left: 15),
                          child: Align(alignment: Alignment.centerLeft,
                            child: Text("Mulai dari identitas singkat kamu ya..",
                              style: TextStyle(fontFamily: "VarelaRound",fontSize: 13)),
                          ),),
                        Padding(padding: const EdgeInsets.only(left: 15,top: 10,right: 15),
                          child: TextFormField(
                            controller: _nama,
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
                              hintText: 'Nama Lengkap',
                            ),
                          ),
                        ),
                        Padding(padding: const EdgeInsets.only(left: 15,top: 10,right: 15),
                          child: TextFormField(
                            controller: _alamattoko,
                            textCapitalization: TextCapitalization.words,
                            keyboardType: TextInputType.text,
                            style: TextStyle(fontFamily: "VarelaRound",fontSize: 15),
                            decoration: new InputDecoration(
                              contentPadding: const EdgeInsets.only(top: 1,left: 10,bottom: 1),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: HexColor("#DDDDDD"), width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: HexColor("#DDDDDD"), width: 1.0),
                              ),
                              hintText: 'Alamat',
                            ),
                          ),
                        ),
                        Padding(padding: const EdgeInsets.only(left: 15,top: 10,right: 15),
                          child: TextFormField(
                            controller: _nomortoko,
                            keyboardType: TextInputType.number,
                            style: TextStyle(fontFamily: "VarelaRound",fontSize: 15),
                            decoration: new InputDecoration(
                              contentPadding: const EdgeInsets.only(top: 1,left: 10,bottom: 1),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: HexColor("#DDDDDD"), width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: HexColor("#DDDDDD"), width: 1.0),
                              ),
                              hintText: 'Nomor Telpon',
                            ),
                          ),
                        ),
                        Padding(padding: const EdgeInsets.only(left: 15,top: 10,right: 15),
                          child: TextFormField(
                            controller: _email,
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) => val.isEmpty || !val.contains("@")
                                ? "enter a valid eamil"
                                : null,
                            style: TextStyle(fontFamily: "VarelaRound",fontSize: 15),
                            decoration: new InputDecoration(
                              contentPadding: const EdgeInsets.only(top: 1,left: 10,bottom: 1),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: HexColor("#DDDDDD"), width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: HexColor("#DDDDDD"), width: 1.0),
                              ),
                              hintText: 'Email',
                            ),
                          ),
                        ),
                        Padding(padding: const EdgeInsets.only(left: 15,top: 10,right: 15),
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

                        Padding(padding: const EdgeInsets.only(top:50,left: 15),
                          child: Align(alignment: Alignment.centerLeft,
                            child: Text("Toko Kamu", style: TextStyle(fontFamily: "VarelaRound",fontSize: 20,fontWeight: FontWeight.bold),),
                          ),),
                        Padding(padding: const EdgeInsets.only(top:5,left: 15),
                          child: Align(alignment: Alignment.centerLeft,
                            child: Text("Yuk Kenalin toko kamu ya..",
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
                      ],
                    )),
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
                                _daftar();
                              }
                          )),
                    ),
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
                              color: Colors.white,
                              child:        Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Image.asset("assets/logo_google.png",height: 30,width: 30,),// <-- Use 'Image.asset(...)' here
                                  SizedBox(width: 14),
                                  Text('Daftar Dengan Google',
                                      style: TextStyle(
                                          fontFamily: 'VarelaRound',
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black
                                      )),
                                ],
                              ),
                              onPressed: () {
                                _daftargoogle();
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