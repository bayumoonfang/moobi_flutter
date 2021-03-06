


import 'package:cached_network_image/cached_network_image.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:moobi_flutter/Helper/api_link.dart';
import 'package:moobi_flutter/Helper/check_connection.dart';
import 'package:moobi_flutter/Helper/color_based.dart';
import 'package:moobi_flutter/Helper/page_route.dart';
import 'package:moobi_flutter/Helper/session.dart';
import 'package:moobi_flutter/page_login.dart';
import 'package:toast/toast.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;


class PaymentMethodRegistration extends StatefulWidget{
  @override
  _PaymentMethodRegistrationState createState() => _PaymentMethodRegistrationState();
}


class _PaymentMethodRegistrationState extends State<PaymentMethodRegistration>{
  List data;
  Future<bool> _onWillPop() async {
    Navigator.pop(context);
  }
  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }

  _connect() async {
    Checkconnection().check().then((internet){
      if (internet != null && internet) {} else {
        showToast("Koneksi terputus..", gravity: Toast.CENTER,
            duration: Toast.LENGTH_LONG);
      }
    });
  }
  String getEmail = '...';
  _session() async {
    int value = await Session.getValue();
    getEmail = await Session.getEmail();
    if (value != 1) {
      Navigator.pushReplacement(context, ExitPage(page: Login()));
    }
  }

  Future<List> getData() async {
    http.Response response = await http.get(
        Uri.encodeFull(applink+"api_model.php?act=getdata_paymentgatewayreg"),
        headers: {"Accept":"application/json"}
    );
    setState((){
      data = json.decode(response.body);
    });
  }

  @override
  void initState() {
    super.initState();
    _prepare();
  }

  _prepare() async {
    await _connect();
    await _session();
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: new AppBar(
          backgroundColor: HexColor(main_color),
          title: Text(
            "Payment Method",
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
          child: Column(
            children: [
              Padding(padding: const EdgeInsets.only(top: 10),),
              Expanded(child: _dataField())
            ],
          ),
        ),
      ),
    );
  }

  Widget _dataField() {
    return FutureBuilder(
      future : getData(),
      builder: (context, snapshot) {
        if (data == null) {
          return Center(
              child: Image.asset(
                "assets/loadingq.gif",
                width: 110.0,
              )
          );
        } else {
          return data == 0 ?
          Container(
              height: double.infinity, width : double.infinity,
              child: new
              Center(
                  child :
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Text(
                        "Data tidak ditemukan",
                        style: new TextStyle(
                            fontFamily: 'VarelaRound', fontSize: 18),
                      ),
                      new Text(
                        "Silahkan lakukan input data",
                        style: new TextStyle(
                            fontFamily: 'VarelaRound', fontSize: 12),
                      ),
                    ],
                  )))
              :
          new ListView.builder(
            itemCount: data == null ? 0 : data.length,
            padding: const EdgeInsets.only(top: 5,bottom: 80,left: 5,right: 5),
            itemBuilder: (context, i) {
              return Column(
                children: <Widget>[
                  InkWell(
                    onTap: () {

                    },
                    child: ListTile(
                      leading:
                      Padding(padding: const EdgeInsets.only(top: 5),
                        child: Image.network(applink+'photo/payment/'+data[i]["e"],
                          alignment: Alignment.center,
                          height: 25,
                          width: 53,
                         )),
                      title: Text(data[i]["b"], style: TextStyle(fontFamily: 'VarelaRound', fontSize: 20,
                          fontWeight: FontWeight.bold)),
                      subtitle: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(data[i]["c"], style: TextStyle(fontFamily: 'VarelaRound', fontSize: 15
                                    ,color: Colors.black)),
                              )
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("a.n "+data[i]["d"], style: TextStyle(fontFamily: 'VarelaRound',
                                      fontSize: 11,color: Colors.black))),
                            )
                          ],
                        ),
                      ),
                      trailing: InkWell(
                        child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                          child: FaIcon(FontAwesomeIcons.copy,size: 23,),
                        ),
                        onTap: () {
                          FlutterClipboard.copy(data[i]["c"]).then(( value ) =>
                              showToast("Nomor Akun berhasil disalin", gravity: Toast.BOTTOM,
                                  duration: Toast.LENGTH_LONG)
                          );
                        },
                      ),

                    ),
                  ),
                  Padding(padding: const EdgeInsets.only(top: 2,  left: 15,right: 15),
                    child: Divider(height: 4,),)
                ],
              );
            },
          );
        }
      },
    );
  }


}