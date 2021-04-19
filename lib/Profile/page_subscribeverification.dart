


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:moobi_flutter/Helper/check_connection.dart';
import 'package:moobi_flutter/Helper/color_based.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:moobi_flutter/Helper/api_link.dart';
import 'package:moobi_flutter/Helper/page_route.dart';
import 'package:moobi_flutter/Helper/session.dart';
import 'package:moobi_flutter/page_login.dart';
import 'package:toast/toast.dart';

class SubscribeVerification extends StatefulWidget{

  @override
  SubscribeVerificationState createState() => SubscribeVerificationState();
}

class SubscribeVerificationState extends State<SubscribeVerification> {
  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }
  List itemList = List();
  String selectedTransferKe;
  String getEmail = '...';
  _session() async {
    int value = await Session.getValue();
    getEmail = await Session.getEmail();
    if (value != 1) {
      Navigator.pushReplacement(context, ExitPage(page: Login()));
    }
  }
  _connect() async {
    Checkconnection().check().then((internet){
      if (internet != null && internet) {} else {
        showToast("Koneksi terputus..", gravity: Toast.CENTER,
            duration: Toast.LENGTH_LONG);
      }
    });
  }


  _prepare() async {
    await _connect();
    await _session();
    //await _getBranch();
    await getAllItem();

  }

  @override
  void initState(){
    super.initState();
    _prepare();

  }

  Future getAllItem() async {
    var response = await http.get(
        Uri.encodeFull(applink+"api_model.php?act=getdata_paymentgatewayreg2"));
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        itemList = jsonData;
      });
    }
    print(itemList);
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: new AppBar(
          backgroundColor: HexColor(main_color),
          title: Text(
            "Verifikasi Pembayaran",
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
                          child: Text("User ID",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "VarelaRound",
                              fontSize: 12,color: HexColor("#0074D9")),),
                        ),),
                        Align(alignment: Alignment.centerLeft,child: Padding(
                          padding: const EdgeInsets.only(left: 0),
                          child: TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            enabled: false,
                            //controller: _namaproduk,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(top:2),
                              hintText: 'Contoh : Nasi Goreng, Es Jeruk',
                              labelText: '',
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              hintStyle: TextStyle(fontFamily: "VarelaRound", color: HexColor("#c4c4c4")),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: HexColor("#DDDDDD")),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: HexColor("#8c8989")),
                              ),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: HexColor("#DDDDDD")),
                              ),
                            ),
                          ),
                        ),),
                      ],
                    )
                ),



                Padding(padding: const EdgeInsets.only(left: 15,top: 10,right: 15),
                    child: Column(
                      children: [
                        Align(alignment: Alignment.centerLeft,child: Padding(
                          padding: const EdgeInsets.only(left: 0,top: 15),
                          child: Text("Transfer/Bayar Ke",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "VarelaRound",
                              fontSize: 12,color: HexColor("#0074D9")),),
                        ),),
                        Align(alignment: Alignment.centerLeft,child: Padding(
                          padding: const EdgeInsets.only(left: 0),
                          child: Padding(
                            padding: const EdgeInsets.only(top:10),
                            child: DropdownButton(
                              isExpanded: true,
                              hint: Text("Pilih Tujuan"),
                              value: selectedTransferKe,
                              items: itemList.map((myitem){
                                return DropdownMenuItem(
                                    value: myitem['NAMA'],
                                    child: Text(myitem['NAMA'])
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  selectedTransferKe = value;
                                });
                              },
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