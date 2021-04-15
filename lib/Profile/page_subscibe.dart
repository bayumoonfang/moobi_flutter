



import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:moobi_flutter/Helper/check_connection.dart';
import 'package:moobi_flutter/Helper/color_based.dart';
import 'package:moobi_flutter/Helper/page_route.dart';
import 'package:moobi_flutter/Helper/session.dart';
import 'package:moobi_flutter/Profile/page_profile.dart';
import 'package:moobi_flutter/page_login.dart';
import 'package:responsive_container/responsive_container.dart';
import 'package:steps/steps.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:moobi_flutter/Helper/api_link.dart';

class Subscribe extends StatefulWidget {
  @override
  SubscribeState createState() => SubscribeState();
}

class SubscribeState extends State<Subscribe> {
  TextEditingController valNama = TextEditingController();
  Future<bool> _onWillPop() async {
    Navigator.pop(context);
  }
  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }


  String getEmail = '...';
  _session() async {
    int value = await Session.getValue();
    getEmail = await Session.getEmail();
    if (value != 1) {Navigator.pushReplacement(context, ExitPage(page: Login()));}
  }

  _connect() async {
    Checkconnection().check().then((internet){
      if (internet != null && internet) {} else {
        showToast("Koneksi terputus..", gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      }
    });
  }



  _prepare() async {
    await _connect();
    await _session();

  }



  @override
  void initState() {
    super.initState();
    _prepare();
  }

  doSimpan() async {
    final response = await http.post(applink+"api_model.php?act=edit_namapengguna", body: {
      "valNama_edit": valNama.text,
      "valEmail_edit" : getEmail.toString()
    });
    Map data = jsonDecode(response.body);
    setState(() {
      if (data["message"].toString() == '1') {
        showToast("Nama berhasil diganti", gravity: Toast.BOTTOM,
            duration: Toast.LENGTH_LONG);
        Navigator.pop(context);
        return false;
      }
    });
  }


  alertSimpan() {
    if (valNama.text == "" ) {
      showToast("Form tidak boleh kosong ", gravity: Toast.BOTTOM,
          duration: Toast.LENGTH_LONG);
      return false;
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            //title: Text(),
            content: Container(
                width: double.infinity,
                height: 178,
                child: Column(
                  children: [
                    Align(alignment: Alignment.center, child:
                    Text("Konfirmasi", style: TextStyle(fontFamily: 'VarelaRound', fontSize: 20,
                        fontWeight: FontWeight.bold)),),
                    Padding(padding: const EdgeInsets.only(top: 15), child:
                    Align(alignment: Alignment.center, child: FaIcon(FontAwesomeIcons.save,
                      color: Colors.redAccent,size: 35,)),),
                    Padding(padding: const EdgeInsets.only(top: 15), child:
                    Align(alignment: Alignment.center, child:
                    Text("Apakah anda yakin menyimpan data ini ? ",
                        style: TextStyle(fontFamily: 'VarelaRound', fontSize: 12)),)),
                    Padding(padding: const EdgeInsets.only(top: 25), child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(child: OutlineButton(
                          onPressed: () {Navigator.pop(context);}, child: Text("Tidak"),)),
                        Expanded(child: OutlineButton(
                          borderSide: BorderSide(width: 1.0, color: Colors.redAccent),
                          onPressed: () {
                            doSimpan();
                          }, child: Text("Simpan", style: TextStyle(color: Colors.red),),)),
                      ],),)
                  ],
                )
            ),
          );
        });
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: new AppBar(
          backgroundColor: HexColor(main_color),
          title: Text(
            "Subscribe Moobie",
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
          padding: const EdgeInsets.only(left: 5,right: 5),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(padding: const EdgeInsets.only(left: 15,top: 10,right: 15),
                    child: Column(
                      children: [
                        Align(alignment: Alignment.centerLeft,child: Padding(
                          padding: const EdgeInsets.only(left: 0,top: 15),
                          child:
                          Text("Segera subscribe Moobie anda",
                            style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "VarelaRound",
                              fontSize: 16,color: Colors.black),),
                        ),),
                        Align(alignment: Alignment.centerLeft,child: Padding(
                          padding: const EdgeInsets.only(left: 0,top: 10, right: 35),
                          child:
                          Text("Sudah nyaman dengan moobie ? yuk terus kembangkan bisnis kamu , dengan moobie. "
                              "Segera dapatkan full version moobie dengan "
                              "cara subscribe dan dapatkan keuntungan lainnya serta update "
                              "terbaru yang keren habis dari moobie.",
                            style: TextStyle(fontFamily: "VarelaRound",
                                fontSize: 12,color: Colors.black,height: 1.5),),
                        ),),

                        Align(alignment: Alignment.centerLeft,child: Padding(
                          padding: const EdgeInsets.only(left: 0,top: 30, right: 35),
                          child:
                          Text("Mulai dari",
                            style: TextStyle(fontFamily: "VarelaRound",fontWeight: FontWeight.bold,
                                fontSize: 12,color: Colors.black,height: 1.5),),
                        ),),
                        Align(alignment: Alignment.centerLeft,child: Padding(
                          padding: const EdgeInsets.only(left: 0,top: 5, right: 35),
                          child:
                               Row(
                                 children: [
                                   Text("Rp.20.000",
                                       style: TextStyle(fontFamily: "VarelaRound",fontWeight: FontWeight.bold,
                                           fontSize: 28,color: HexColor("#2ECC40"))),
                                   Padding(padding: const EdgeInsets.only(top: 7,left: 5),
                                   child: Text("/ bulan",
                                       style: TextStyle(fontFamily: "VarelaRound",
                                           fontSize: 14,color: HexColor("#AAAAAA"))),)
                                 ],
                               )
                        ),),
                        Align(alignment: Alignment.centerLeft,child: Padding(
                          padding: const EdgeInsets.only(left: 0,top: 5, right: 35),
                          child:
                     Opacity(
                       opacity: 0.6,
                       child: Text("*Sudah termasuk PPN , dan biaya admin",
                         style: TextStyle(fontFamily: "VarelaRound",
                             fontSize: 10,color: Colors.black),),
                     )
                        ),),


                        Padding(padding: const EdgeInsets.only(top :20),
                          child: Container(
                            height: 7,
                            width: double.infinity,
                            color: HexColor("#f4f4f4"),
                          ),),

                        Align(alignment: Alignment.centerLeft,child: Padding(
                          padding: const EdgeInsets.only(left: 0,top: 10, right: 35),
                          child:
                          ResponsiveContainer(
                            widthPercent: 100,
                            heightPercent: 85,
                                child:        Steps(
                                  direction: Axis.vertical,
                                  size: 10.0,
                                  path: {
                                    'color': HexColor("#DDDDDD"),
                                    'width': 1.0},
                                  steps: [
                                    {
                                      'color': Colors.white,
                                      'background': HexColor(main_color),
                                      'label': '1',
                                      'content': Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'Pembayaran',
                                            style: TextStyle(fontSize: 22.0),
                                          ),
                                          Text(
                                            'Lakukan pembayaran untuk memulai subscribe aplikasi moobie. Anda dapat melakukan pembayaran ke beberapa rekening atau layanan ',
                                            style: TextStyle(fontSize: 12.0),
                                          ),
                                        ],
                                      ),
                                    },

                                    {
                                      'color': Colors.white,
                                      'background': Colors.lightBlue.shade200,
                                      'label': '1',
                                      'content': Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'Laborum exercitation',
                                            style: TextStyle(fontSize: 22.0),
                                          ),
                                          Text(
                                            'Qui et consectetur esse duis excepteur magna consectetur.',
                                            style: TextStyle(fontSize: 12.0),
                                          ),
                                        ],
                                      ),
                                    },

                                  ],

                                ),
                              )
                        ),),





                      ],
                    )
                ),
              ],
            ),
          ),
        ),
      ),
    );


  }
}