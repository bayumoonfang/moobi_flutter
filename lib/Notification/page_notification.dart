


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:moobi_flutter/Helper/check_connection.dart';
import 'package:moobi_flutter/Helper/color_based.dart';
import 'package:moobi_flutter/Helper/page_route.dart';
import 'package:moobi_flutter/Helper/session.dart';
import 'package:moobi_flutter/Notification/page_detailnotification.dart';
import 'package:moobi_flutter/Notification/page_detailnotificationtransaksi.dart';
import 'package:moobi_flutter/page_login.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:moobi_flutter/helper/api_link.dart';


class NotificationPage extends StatefulWidget{

  @override
  NotificationPageState createState() => NotificationPageState();
}


class NotificationPageState extends State<NotificationPage> {
  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }
  bool isSemua = true;
  bool isTransaksi = false;
  bool isPromo = false;
  bool isInfo = false;
  bool _isvisible = true;
  List data;


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

  String getUserIDVal = '';
  _getUserDetail() async {
    final response = await http.get(
        applink+"api_model.php?act=userdetail&id="+getEmail.toString());
    Map data = jsonDecode(response.body);
    setState(() {
      getUserIDVal = data["m"].toString();
    });
  }

  _prepare() async {
    await _connect();
    await _session();
    await _getUserDetail();
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
  void initState() {
    super.initState();
    _prepare();
  }


  String filter = "Semua";
  Future<List> getDataNotifAll() async {
    http.Response response = await http.get(
        Uri.encodeFull(applink+"api_model.php?act=getdata_notifikasi&id="+getUserIDVal+"&filter="+filter),
        headers: {"Accept":"application/json"}
    );
    setState((){
      data = json.decode(response.body);
    });
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: new AppBar(
          backgroundColor: HexColor(main_color),
          title: Text(
            "Notifikasi",
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
                            child: Text("Semua",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,fontFamily: 'VarelaRound',
                                color: isSemua == true ? Colors.white : Colors.black
                            ),),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: isSemua == true ? HexColor(main_color) : Colors.black,width: 0.8),
                            ),
                            color: isSemua == true ? HexColor(main_color) : Colors.white ,
                            onPressed: (){
                              setState(() {
                                _isvisible = false;
                                isSemua = true;
                                isTransaksi = false;
                                isPromo = false;
                                isInfo = false;
                                filter = "Semua";
                                startSCreen();
                              });
                            },
                          ),
                        ),),


                      Padding(padding: const EdgeInsets.only(left: 10),
                        child: Container(
                          height: 30,
                          child: RaisedButton(
                            elevation: 0,
                            child: Text("Transaksi",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,fontFamily: 'VarelaRound',
                                color: isTransaksi == true ? Colors.white : Colors.black
                            ),),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: isTransaksi == true ? HexColor(main_color) : Colors.black,width: 0.8),
                            ),
                            color: isTransaksi == true ? HexColor(main_color) : Colors.white ,
                            onPressed: (){
                              setState(() {
                                _isvisible = false;
                                isSemua = false;
                                isTransaksi = true;
                                isPromo = false;
                                isInfo = false;
                                filter = "Transaksi";
                                startSCreen();
                              });
                            },
                          ),
                        ),),


                      Padding(padding: const EdgeInsets.only(left: 10),
                        child: Container(
                          height: 30,
                          child: RaisedButton(
                            elevation: 0,
                            child: Text("Promo",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,fontFamily: 'VarelaRound',
                                color: isPromo == true ? Colors.white : Colors.black
                            ),),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: isPromo == true ? HexColor(main_color) : Colors.black,width: 0.8),
                            ),
                            color: isPromo == true ? HexColor(main_color) : Colors.white ,
                            onPressed: (){
                              setState(() {
                                _isvisible = false;
                                isSemua = false;
                                isTransaksi = false;
                                isPromo = true;
                                isInfo = false;
                                filter = "Promo";
                                startSCreen();
                              });
                            },
                          ),
                        ),),


                      Padding(padding: const EdgeInsets.only(left: 10),
                        child: Container(
                          height: 30,
                          child: RaisedButton(
                            elevation: 0,
                            child: Text("Info",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,fontFamily: 'VarelaRound',
                                color: isInfo == true ? Colors.white : Colors.black
                            ),),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: isInfo == true ? HexColor(main_color) : Colors.black,width: 0.8),
                            ),
                            color: isInfo == true ? HexColor(main_color) : Colors.white ,
                            onPressed: (){
                              setState(() {
                                _isvisible = false;
                                isSemua = false;
                                isTransaksi = false;
                                isPromo = false;
                                isInfo = true;
                                filter = "Info";
                                startSCreen();
                              });
                            },
                          ),
                        ),),
                    ],
                  ),
                ),
              ),
              Padding(padding: const EdgeInsets.only(left: 15,right: 15),
                child: Divider(height: 4,),),
              Padding(padding: const EdgeInsets.only(top: 10),),
              Visibility(
                visible: _isvisible,
                child: Expanded(
                  child: _dataField(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


  Widget _dataField() {
    return FutureBuilder(
      future: getDataNotifAll(),
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
                        "Oppps..",
                        style: new TextStyle(
                            fontFamily: 'VarelaRound', fontSize: 18),
                      ),
                      new Text(
                        "Tidak ada notifikasi untuk anda",
                        style: new TextStyle(
                            fontFamily: 'VarelaRound', fontSize: 12),
                      ),
                    ],
                  )))
              :
          ListView.builder(
            padding: const EdgeInsets.only(top: 2,bottom: 80),
            itemCount: data == null ? 0 : data.length,
            itemBuilder: (context, i) {
                  return Column(
                    children: [
                       InkWell(
                         onTap: (){
                           data[i]["g"].toString() == 'Promo'  ?
                           Navigator.push(context, ExitPage(page: DetailNotification(data[i]["a"].toString(), data[i]["c"])))
                               : data[i]["g"].toString() == 'Info' ?
                           Navigator.push(context, ExitPage(page: DetailNotification(data[i]["a"].toString(), data[i]["c"])))
                               :
                           Navigator.push(context, ExitPage(page: DetailNotifikasiTransaksi(data[i]["a"].toString(), data[i]["c"])));
                         },
                         child: ListTile(
                           title: Align(alignment: Alignment.centerLeft,
                             child: Row(
                               children: [
                                 data[i]["g"] == 'Transaksi' ?
                                 FaIcon(FontAwesomeIcons.creditCard,size: 10,color: HexColor(main_color),)
                                 : data[i]["g"] == 'Promo' ?
                                 FaIcon(FontAwesomeIcons.tag,size: 10,color: HexColor("#FF851B"),)
                                     :
                                 FaIcon(FontAwesomeIcons.infoCircle,size: 10,color: HexColor("0074D9"),),
                                 Padding(padding: const EdgeInsets.only(left: 10),
                                 child:    Row(
                                   children: [
                                     Text(data[i]["g"],
                                         style: TextStyle(fontFamily: "VarelaRound",
                                             fontSize: 12,color: HexColor("#a1a0a0"))),
                                     Padding(padding: const EdgeInsets.only(left: 5),
                                     child: Icon(Icons.fiber_manual_record, color: Colors.grey, size: 7),),
                                     Padding(padding: const EdgeInsets.only(left: 5),
                                       child: Text(data[i]["b"].toString().substring(8,10)+"-"+data[i]["b"].toString().substring(5,7)+"-"+
                                           data[i]["b"].toString().substring(0,4)
                                         ,
                                         style: TextStyle(fontFamily: "VarelaRound",
                                             fontSize: 12,color: HexColor("#a1a0a0")),))
                                   ],
                                 )
                                   ,)
                               ],
                             )
                             ,),
                           subtitle: Padding(padding: const EdgeInsets.only(top: 8),
                           child: Column(
                             children: [
                                Align(alignment: Alignment.centerLeft,
                                child: Text(data[i]["c"],
                                  style: TextStyle(fontFamily: "VarelaRound",
                                  fontWeight:  data[i]["i"] == 0 ? FontWeight.bold : FontWeight.normal,
                                  fontSize: 13,color: data[i]["i"] == 1 ? HexColor("#585b60") : Colors.black),),),
                               Padding(padding: const EdgeInsets.only(top: 5,bottom: 10),
                               child: Align(alignment: Alignment.centerLeft,
                                 child: Text(data[i]["d"],
                                   overflow: TextOverflow.ellipsis,
                                   style: TextStyle(fontWeight: data[i]["i"] == 0 ? FontWeight.bold : FontWeight.normal,
                                       fontFamily: "OpenSans",
                                       fontSize: 12,color:  data[i]["i"] == 1 ? HexColor("#585b60") : Colors.black,height: 1.5),),))
                             ],
                           ),),
                         ),
                       ),
                      Padding(padding: const EdgeInsets.only(left: 15,right: 15,top: 2),
                      child: Divider(height: 5,),),
                      Padding(padding: const EdgeInsets.only(top :10,bottom: 10 ))
                    ],
                  );
            },
          );
        }
      },
    );
  }
}