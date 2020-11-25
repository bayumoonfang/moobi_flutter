

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:moobi_flutter/helper/page_route.dart';
import 'package:moobi_flutter/page_login.dart';

class Index extends StatefulWidget {
  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {



  @override
  Widget build(BuildContext context) {
        return WillPopScope(
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Container(
              child: Center(
                child : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    Image.asset("assets/c.png",width: 300,),


                  ],
                )
              ),
            ),
            bottomSheet: new
            Container(
                color: Colors.white,
                padding: const EdgeInsets.only(left: 15,right: 15,bottom: 15),
                child:Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded (
                child :
                      Padding(
                          padding: const EdgeInsets.only(right: 15.0, left: 15.0, bottom: 15.0, top: 10),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
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
                              Navigator.push(context, ExitPage(page: Login()));
                            }
                          )
                      )),

                      Expanded (
                          child :
                          Padding(
                              padding: const EdgeInsets.only(right: 15.0, left: 15.0, bottom: 15.0, top: 10),
                              child: RaisedButton(
                                  shape: RoundedRectangleBorder(side: BorderSide(
                                      color: Colors.black,
                                      width: 0.1,
                                      style: BorderStyle.solid
                                  ),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  color: HexColor("#DDDDDD"),
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                      fontFamily: 'VarelaRound',
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                  onPressed: () {

                                  }
                              )
                          )),
                    ])
            ),
          ),
        );

  }

}