


import 'dart:async';
import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:moobi_flutter/Helper/check_connection.dart';
import 'package:moobi_flutter/Helper/page_route.dart';
import 'package:moobi_flutter/Helper/session.dart';
import 'package:moobi_flutter/page_login.dart';
import 'package:responsive_container/responsive_container.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:moobi_flutter/helper/api_link.dart';

class Checkout extends StatefulWidget{
  @override
  CheckoutState createState() => CheckoutState();
}

class CheckoutState extends State<Checkout> {
  List data;
  bool _isvisible = true;
  bool isSemua = true;
  bool isTerjual = false;
  bool isDiskon = false;
  bool isTerlaris = false;
  bool isTermurah = false;
  bool isTermahal = false;
  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }


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
      if (internet != null && internet) {
        // Internet Present Case
      } else {
        showToast("Koneksi terputus..", gravity: Toast.CENTER,
            duration: Toast.LENGTH_LONG);
      }
    });
  }

  String getBranchVal = '';
  String getNamaUser = '';
  _getBranch() async {
    final response = await http.get(
        applink+"api_model.php?act=userdetail&id="+getEmail.toString());
    Map data = jsonDecode(response.body);
    setState(() {
      getBranchVal = data["c"].toString();
      getNamaUser = data["j"].toString();
    });
  }


  String valgetTotal = '0';
  _getTotal() async {
    final response = await http.get(
        applink+"api_model.php?act=getdata_charttotal&branch="+getBranchVal+"&operator="+getNamaUser);
    Map data = jsonDecode(response.body);
    setState(() {
      valgetTotal = data["a"].toString();
    });
  }



  @override
  void initState() {
    super.initState();
    _prepare();
  }


  String filter = "Semua";
  String filterq = "";
  String sortby = '0';
  Future<List> getData() async {
    http.Response response = await http.get(
        Uri.encodeFull(applink+"api_model.php?act=getdata_produkcheckout&branch="+getBranchVal+"&operator="+getNamaUser),
        headers: {"Accept":"application/json"}
    );
    setState((){
      data = json.decode(response.body);
    });
  }

  _prepare() async {
    await _connect();
    await _session();
    await _getBranch();
    await _getTotal();
  }

  startSCreen() async {
    var duration = const Duration(seconds: 1);
    return Timer(duration, () {
      setState(() {
        _isvisible = true;
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
          appBar: new AppBar(
            elevation: 0.5,
            backgroundColor: Colors.white,
            title:Text( "Rp. "+
              NumberFormat.currency(
                  locale: 'id', decimalDigits: 0, symbol: '').format(
                  int.parse(valgetTotal)),
              style: TextStyle(
                  color: Colors.black, fontFamily: 'VarelaRound', fontSize: 16),
            ),
            leading: Container(
              padding: const EdgeInsets.only(left: 7),
              child: Builder(
                builder: (context) => IconButton(
                    icon: new Icon(Icons.arrow_back),
                    color: Colors.black,
                    onPressed: () => {
                      Navigator.pop(context)
                    }),
              ),
            ),
            actions: [
              InkWell(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  //_showAlert();
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 27,top : 14),
                  child: FaIcon(
                      FontAwesomeIcons.check,color: Colors.black,
                  ),
                ),
              )
            ],
          ),
          body: Container(
            color: Colors.white,
            child: Column(
              children: [
                Container(
                    height: 50,
                    width: double.infinity,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Padding(padding: const EdgeInsets.only(left: 10),
                            child: Container(
                              height: 30,
                              child: RaisedButton(
                                elevation: 0,
                                child: Text("Tambah Biaya",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,fontFamily: 'VarelaRound',
                                    color: isSemua == true ? Colors.white : Colors.black
                                ),),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: isSemua == true ? HexColor("#602d98") : Colors.black,width: 0.8),
                                ),
                                color: isSemua == true ? HexColor("#602d98") : Colors.white ,
                                onPressed: (){

                                },
                              ),
                            ),),
                        ],
                      ),
                    )
                ),
                Padding(padding: const EdgeInsets.only(left: 15,right: 15),
                  child: Divider(height: 4,),),
                Padding(padding: const EdgeInsets.only(top: 10),),
                Visibility(
                    visible: _isvisible,
                    child :
                    Expanded(child: _dataField())
                )
                //
              ],
            ),
          )


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
            padding: const EdgeInsets.only(top: 2,bottom: 80),
            itemBuilder: (context, i) {
              return Column(
                children: <Widget>[
                  InkWell(
                    child: ListTile(
                      leading:
                          Badge(
                            badgeContent: Text(data[i]["j"].toString(), style: TextStyle(color: Colors.white,
                              fontFamily: "VarelaRound",),),
                  child :
                      SizedBox(
                          width: 50,
                          height: 50,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6.0),
                            child : CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl:
                              data[i]["d"] == '' ?
                              applink+"photo/nomage.jpg"
                                  :
                              applink+"photo/"+getBranchVal+"/"+data[i]["d"],
                              progressIndicatorBuilder: (context, url, downloadProgress) =>
                                  CircularProgressIndicator(value: downloadProgress.progress),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            ),
                          ))),
                      title: Align(alignment: Alignment.centerLeft,
                        child: Text(data[i]["a"],
                            style: TextStyle(fontFamily: "VarelaRound",
                                fontSize: 13,fontWeight: FontWeight.bold)),),
                      subtitle: Align(alignment: Alignment.centerLeft,
                          child:
                          Text(data[i]["j"].toString() + " x"+" Rp. "+
                              NumberFormat.currency(
                                  locale: 'id', decimalDigits: 0, symbol: '').format(
                                  data[i]["k"])+" = "+NumberFormat.currency(
                              locale: 'id', decimalDigits: 0, symbol: '').format(
                              data[i]["l"]), style: new TextStyle(
                              fontFamily: 'VarelaRound',fontSize: 12),)
                      ),
                    ),
                  ),
                  Padding(padding: const EdgeInsets.only(top :10 ))
                ],
              );
            },
          );
        }
      },
    );
  }


}