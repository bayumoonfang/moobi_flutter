


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
                              child: Text("Kenalin diri kamu", style: TextStyle(fontFamily: "VarelaRound",fontSize: 18,fontWeight: FontWeight.bold),),
                          ),),
                        Padding(padding: const EdgeInsets.only(top:5,left: 15),
                          child: Align(alignment: Alignment.centerLeft,
                            child: Text("Mulai dari identitas singkat kamu ya..",
                              style: TextStyle(fontFamily: "VarelaRound",fontSize: 13)),
                          ),)
                      ],
                    ),
              ),
            ),
        );
  }
}