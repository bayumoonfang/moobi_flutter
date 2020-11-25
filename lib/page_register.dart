


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
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
  final _kotatoko = TextEditingController();
  final _telpontoko = TextEditingController();
  final _idtoko = TextEditingController();
  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }
  String getMessage;




  Future<bool> _onWillPop() async {
    Navigator.pop(context);
  }


  _daftar() async {
    if (_nama.text == '' || _email.text == '' || _password.text == '' || _namatoko.text == '' || _alamattoko.text == '' || _kotatoko.text == '' ||
        _telpontoko.text == '' || _idtoko.text == '' ) {
      showToast("Form tidak boleh kosong", gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    } else if(_idtoko.text.length == 1) {
      showToast("ID minimal 2 karakter", gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    } else {
      final response = await http.post(
          "https://duakata-dev.com/moobi/m-moobi/api_model.php?act=register",
          body: {
            "nama": _nama.text.toString(),
            "email": _email.text.toString(),
            "password": _password.text.toString(),
            "namatoko": _namatoko.text.toString(),
            "alamattoko": _alamattoko.text.toString(),
            "kotatoko": _kotatoko.text.toString(),
            "telpontoko": _telpontoko.text.toString(),
            "idtoko": _idtoko.text.toString()
          });
          Map showdata = jsonDecode(response.body);
          setState(() {
            getMessage = showdata["message"].toString();
              if (getMessage == '0') {
                showToast("Nama Toko atau ID Toko sudah ada... coba dengan yang lain", gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
                return;
              } else if (getMessage == '1') {
                showToast("Email sudah terdaftar", gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
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
                appBar: new AppBar(
                  backgroundColor: Colors.white,
                  leading: Builder(
                    builder: (context) => IconButton(
                        icon: new Icon(Icons.arrow_back,size: 20,),
                        color: Colors.black,
                        onPressed: () => {
                          Navigator.pop(context)
                        }),
                  ),
                  title: Text("Daftar Pengguna Baru", style: TextStyle(
                    fontFamily: 'VarelaRound',
                    color: Colors.black,fontSize: 16
                  ),),
                ),
              body: Container(
                    color: Colors.white,
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
                        Padding(padding: const EdgeInsets.only(left: 15,top: 10,right: 90),
                          child: TextFormField(
                            controller: _nama,
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
                        Padding(padding: const EdgeInsets.only(left: 15,top: 10,right: 90),
                          child: TextFormField(
                            controller: _email,
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
                        Padding(padding: const EdgeInsets.only(left: 15,top: 10,right: 90),
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

                        Padding(padding: const EdgeInsets.only(left: 15,top: 10,right: 90),
                          child: TextFormField(
                            controller: _namatoko,
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


                        Padding(padding: const EdgeInsets.only(left: 15,top: 10,right: 90),
                          child: TextFormField(
                            controller: _alamattoko,
                            style: TextStyle(fontFamily: "VarelaRound",fontSize: 15),
                            decoration: new InputDecoration(
                              contentPadding: const EdgeInsets.only(top: 1,left: 10,bottom: 1),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: HexColor("#DDDDDD"), width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: HexColor("#DDDDDD"), width: 1.0),
                              ),
                              hintText: 'Alamat Toko',
                            ),
                          ),
                        ),


                        Padding(padding: const EdgeInsets.only(left: 15,top: 10,right: 90),
                          child: TextFormField(
                            controller: _kotatoko,
                            style: TextStyle(fontFamily: "VarelaRound",fontSize: 15),
                            decoration: new InputDecoration(
                              contentPadding: const EdgeInsets.only(top: 1,left: 10,bottom: 1),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: HexColor("#DDDDDD"), width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: HexColor("#DDDDDD"), width: 1.0),
                              ),
                              hintText: 'Kota',
                            ),
                          ),
                        ),

                        Padding(padding: const EdgeInsets.only(left: 15,top: 10,right: 90),
                          child: TextFormField(
                            controller: _telpontoko,
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
                              hintText: 'Telpon Toko',
                            ),
                          ),
                        ),


                        Padding(padding: const EdgeInsets.only(top:50,left: 15),
                          child: Align(alignment: Alignment.centerLeft,
                            child: Text("Identitas Toko Kamu", style: TextStyle(fontFamily: "VarelaRound",fontSize: 20,fontWeight: FontWeight.bold),),
                          ),),
                        Padding(padding: const EdgeInsets.only(top:5,left: 15),
                          child: Align(alignment: Alignment.centerLeft,
                            child: Text("Terakhir nih , kasih tau identitas toko kamu..",
                                style: TextStyle(fontFamily: "VarelaRound",fontSize: 13)),
                          ),),

                        Padding(padding: const EdgeInsets.only(left: 15,top: 10,right: 90,bottom: 100),
                          child: TextFormField(
                            controller: _idtoko,
                            maxLength: 2,
                            textCapitalization: TextCapitalization.characters,

                            style: TextStyle(fontFamily: "VarelaRound",fontSize: 15),
                            decoration: new InputDecoration(
                              contentPadding: const EdgeInsets.only(top: 1,left: 10,bottom: 1),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: HexColor("#DDDDDD"), width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: HexColor("#DDDDDD"), width: 1.0),
                              ),
                              hintText: 'Contoh : KM, SI, HO',
                            ),
                          ),
                        ),

                      ],
                    )),
              ),
              bottomSheet:Row(
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
                                    "Daftar Sekarang",
                                    style: TextStyle(
                                        fontFamily: 'VarelaRound',
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white
                                    ),
                                  ),
                                  onPressed: () {
                                    _daftar();
                                  }
                              ))
                          ),
                    ]
                )
            ),
        );
  }
}