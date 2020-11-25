


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}


class _LoginState extends State<Login> {

  Future<bool> _onWillPop() async {
    Navigator.pop(context);
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
                  title: Text("Daftar", style: TextStyle(
                    fontFamily: 'VarelaRound',
                    color: Colors.black,fontSize: 16
                  ),),
                ),
              body: Container(
                    color: Colors.white,
                    child: Column (
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
                      ],
                    ),
              ),
            ),
        );
  }
}