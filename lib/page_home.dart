



import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:moobi_flutter/Gudang/page_gudang.dart';
import 'package:moobi_flutter/Helper/color_based.dart';
import 'package:moobi_flutter/Jualan/page_jualan.dart';
import 'package:moobi_flutter/Kategori/page_kategori.dart';
import 'package:moobi_flutter/Notification/page_notification.dart';
import 'package:moobi_flutter/Produk/page_produk.dart';
import 'package:moobi_flutter/Produk/page_produkhome.dart';
import 'package:moobi_flutter/Profile/page_profile.dart';
import 'package:moobi_flutter/Setting/page_settinghome.dart';
import 'package:moobi_flutter/Setting/page_legalentites.dart';
import 'package:moobi_flutter/Laporan/page_laporanhome.dart';

import 'package:moobi_flutter/helper/api_link.dart';
import 'package:moobi_flutter/helper/check_connection.dart';
import 'package:moobi_flutter/helper/page_route.dart';
import 'package:moobi_flutter/helper/session.dart';
import 'package:moobi_flutter/page_login.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}


class _HomeState extends State<Home> {
  String getUsername, getEmail = "";
  List data;
  List data2;
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }


  Future<bool> _onWillPop() async {
  }

  _session() async {
    int value = await Session.getValue();
    getEmail = await Session.getEmail();
    if (value != 1) {
      Navigator.push(context, ExitPage(page: Login()));
    }
  }




  String getMoobiIdentity = '...';
  String getStorename = '...';
  String getBranch = '...';
  String getUserID = '...';
  _userDetail() async {
    final response = await http.get(
         applink+"api_model.php?act=userdetail&id="+getEmail.toString());
    Map data = jsonDecode(response.body);
    setState(() {
      getMoobiIdentity = data["d"].toString();
      getStorename = data["b"].toString();
      getBranch = data["c"].toString();
      getUserID = data["m"].toString();
    });
  }

  String getBulan = '...';
  String getTahun = "...";
  getDateNow() async {
    final response = await http.get(
        applink+"api_model.php?act=getdatenow");
    Map data2 = jsonDecode(response.body);
    setState(() {
      getBulan = data2["a"].toString();
      getTahun = data2["b"].toString();
    });
  }

  void _loaddata() async {
    await _session();
    await _userDetail();
    await getDateNow();
  }


  @override
  void initState() {
    super.initState();
    _loaddata();
  }

  Future<List> getDataTotal() async {
    http.Response response = await http.get(
        Uri.encodeFull(applink+"api_model.php?act=getdata_monthsalestotal&branch="+getBranch),
        headers: {"Accept":"application/json"}
    );
    setState((){
      data = json.decode(response.body);
    });
  }



  Future<List> getDataTotalNotif() async {
    http.Response response = await http.get(
        Uri.encodeFull(applink+"api_model.php?act=getdata_totalnotif&userid="+getUserID.toString()),
        headers: {"Accept":"application/json"}
    );
    setState((){
      data2 = json.decode(response.body);
    });
  }



  @override
  Widget build(BuildContext context) {
      return WillPopScope(
        onWillPop: _onWillPop,
          child: Scaffold(
            //backgroundColor: Colors.white,
            appBar: new AppBar(
              backgroundColor: HexColor(main_color),
              automaticallyImplyLeading: false,
              actions: [

                Container(
                  padding: const EdgeInsets.only(top: 19,right: 35),
                  height: 33,
                  width: 58,
                  child: FutureBuilder(
                    future: getDataTotalNotif(),
                    builder: (context, snapshot) {
                      return ListView.builder(
                        itemCount: data2 == null ? 0 : data2.length,
                        itemBuilder: (context, i) {
                          return data2[i]["a"] == "0" ?
                          InkWell(
                              onTap: (){
                                Navigator.push(context, ExitPage(page: NotificationPage()));
                              },
                              child:
                              FaIcon(FontAwesomeIcons.solidBell, size: 20,))
                              :
                       InkWell(
                         onTap: (){
                           Navigator.push(context, ExitPage(page: NotificationPage()));
                         },
                         child: Badge(
                           badgeContent: Text(data2[i]["a"].toString(),
                             style: TextStyle(color: Colors.white,fontSize: 12),),
                           child: FaIcon(FontAwesomeIcons.solidBell, size: 20,),
                         )
                       );


                        },
                      );
                    },
                  ),
                ),

                Padding(padding: const EdgeInsets.only(top: 19,right: 25), child :
                InkWell(
                  hoverColor: Colors.transparent,
                  child : FaIcon(FontAwesomeIcons.cog, size: 20,),
                  onTap: () {
                    Navigator.push(context, ExitPage(page: SettingHome()));
                  },
                )
                ),
              ],
              title:
              Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child:   Text("Moobi", style: TextStyle(color: Colors.white,
                      fontFamily: 'VarelaRound', fontSize: 24,
                      fontWeight: FontWeight.bold),)
              ),
              elevation: 0,
              centerTitle: false,
            ),
            body:
                Stack(
                  children: [
                    Container(
                          width: double.infinity,
                          height: 120,
                          color:  HexColor("#602d98"),
                          child: Stack(
                            children: [
                              Column(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.only(left: 28,top: 15),
                                      child:  Align(
                                        alignment: Alignment.bottomLeft,
                                        child:  Text(getStorename, style: TextStyle(color: Colors.white,
                                            fontFamily: 'VarelaRound', fontSize: 12,
                                            fontWeight: FontWeight.bold),textAlign: TextAlign.left,),
                                      )
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(left: 28,top: 5),
                                      child:  Align(
                                        alignment: Alignment.bottomLeft,
                                        child:  Container(
                                            padding: const EdgeInsets.only(top: 2),
                                            height: 33,
                                            width: double.infinity,
                                            child: FutureBuilder(
                                              future: getDataTotal(),
                                              builder: (context, snapshot) {
                                                return ListView.builder(
                                                  itemCount: (data == null ? 0 : data.length),
                                                  itemBuilder: (context, i) {
                                                    return
                                                      data[i]['a'] == null ?
                                                      Text("Rp. 0",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontFamily: 'VarelaRound',
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 22),)
                                                          :
                                                      Text( "Rp. "+
                                                          NumberFormat.currency(
                                                              locale: 'id', decimalDigits: 0, symbol: '').format(
                                                              int.parse(
                                                                  data[i]['a'] == null ? "0" :
                                                                  data[i]['a'].toString())),
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontFamily: 'VarelaRound',
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 22),
                                                    );
                                                  },
                                                );
                                              },
                                            )
                                        ),
                                      )
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(left: 28,top: 5),
                                      child:  Align(
                                          alignment: Alignment.bottomLeft,
                                          child:  Opacity(
                                            opacity: 0.7,
                                            child: Text(getBulan.toString()+" "+getTahun.toString(), style: TextStyle(color: Colors.white,
                                                fontFamily: 'VarelaRound', fontSize: 11,
                                                fontWeight: FontWeight.bold),textAlign: TextAlign.left,),
                                          )
                                      )
                                  ),
                                ],
                              )
                            ],
                          )
                    ),
                      Padding(
                        padding: const EdgeInsets.only(top: 95,left: 25,right: 25),
                        child:
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 4,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        height: 77,
                        width: double.infinity,
                        child:
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15,left: 15,right: 25),
                                    child:
                                    Wrap(
                                      alignment: WrapAlignment.center,
                                      spacing: 60,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(context, ExitPage(page: Profile()));
                                          },
                                          child:
                                          Column(
                                            children: [
                                              FaIcon(FontAwesomeIcons.user,color: HexColor(second_color)),
                                              Padding(padding: const EdgeInsets.only(top:8),
                                                child: Text("Profile", style: TextStyle(fontFamily: 'VarelaRound',
                                                    fontSize: 12,color: HexColor(second_color))),)
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(context, ExitPage(page: Toko()));
                                          },
                                          child:
                                        Column(
                                          children: [
                                            FaIcon(FontAwesomeIcons.store,color: HexColor(second_color)),
                                            Padding(padding: const EdgeInsets.only(top:8),
                                              child: Text("Outlet Saya", style: TextStyle(fontFamily: 'VarelaRound',
                                                  fontSize: 12,color: HexColor(second_color)
                                                  )),)
                                          ],
                                        )),

                                        InkWell(
                                          onTap: () {
                                            Navigator.push(context, ExitPage(page: Gudang()));
                                          },
                                          child:
                                        Column(
                                          children: [
                                            FaIcon(FontAwesomeIcons.warehouse,color: HexColor(second_color)),
                                            Padding(padding: const EdgeInsets.only(top:8),
                                              child: Text("Gudang", style: TextStyle(fontFamily: 'VarelaRound',
                                                  fontSize: 12,color: HexColor(second_color))),)
                                          ],
                                        )),
                                      ],
                                    ),
                                  )

                      ),),

                    Padding(
                      padding: const EdgeInsets.only(top: 200,left: 25,right: 25),
                      child: Column(
                        children: [
                          getMoobiIdentity == 'Classic' ?
                          Container(
                            padding: const EdgeInsets.only(bottom: 30),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: HexColor("#e8fcfb"),
                              ),
                              width: double.infinity,
                              height: 70,
                              child: ListTile(
                                title:
                                Text("Subscribe ke MOOBIE Premier", style: TextStyle(
                                    fontFamily: 'VarelaRound',fontWeight: FontWeight.bold,
                                    fontSize: 14,color: HexColor("#025f64"))),
                                subtitle:
                                Text("Nikmati fitur lengkapnya", style: TextStyle(fontFamily: 'VarelaRound'
                                    ,fontSize: 12,color: HexColor("#025f64"))),
                                trailing: FaIcon(FontAwesomeIcons.angleRight,color: HexColor("#025f64")),
                              )
                          )
                          :
                          Container(),
                          getMoobiIdentity == 'Classic' ?
                          SizedBox(
                            height: 25,
                          )
                          : Container(),
                          Wrap(
                            spacing: 30,
                                runSpacing: 30,
                                children: [
                                  InkWell(
                                    onTap: (){Navigator.push(context, ExitPage(page: Jualan()));},
                                    child:Column(
                                      children: [
                                        Container(
                                          height: 55, width: 55,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(50),
                                            color: HexColor("#f7faff"),
                                          ),
                                          child: Center(
                                            child: FaIcon(FontAwesomeIcons.shoppingBasket, color: HexColor("#1c6bea"), size: 24,),
                                          )
                                        ),
                                        Padding(padding: const EdgeInsets.only(top:8),
                                          child: Text("Jualan", style: TextStyle(fontFamily: 'VarelaRound',fontSize: 13)),)
                                      ],
                                    ),
                                  ),

                                  InkWell(
                                    onTap: () {
                                      Navigator.push(context, ExitPage(page: ProdukHome()));
                                    },
                                    child:Column(
                                      children: [
                                        Container(
                                            height: 55, width: 55,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(50),
                                              color: HexColor("#fff4f0"),
                                            ),
                                            child: Center(
                                              child: FaIcon(FontAwesomeIcons.cubes, color: HexColor("#ff8556"), size: 24,),
                                            )
                                        ),
                                        Padding(padding: const EdgeInsets.only(top:8),
                                          child: Text("Produk", style: TextStyle(fontFamily: 'VarelaRound',fontSize: 13)),)
                                      ],
                                    ),
                                  ),

/*
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushReplacement(context, ExitPage(page: Kategori()));
                                    },
                                    child:Column(
                                      children: [
                                        Container(
                                            height: 55, width: 55,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(50),
                                              color: HexColor("#eaf9ff"),
                                            ),
                                            child: Center(
                                              child: FaIcon(FontAwesomeIcons.list, color: HexColor("#3ac2ff"), size: 24,),
                                            )
                                        ),
                                        Padding(padding: const EdgeInsets.only(top:8),
                                          child: Text("Kategori", style: TextStyle(fontFamily: 'VarelaRound',fontSize: 13)),)
                                      ],
                                    ),
                                  ),*/

                                  InkWell(
                                    onTap: (){Navigator.pushReplacement(context, ExitPage(page: LaporanHome()));},
                                    child:Column(
                                      children: [
                                        Container(
                                            height: 55, width: 55,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(50),
                                              color: HexColor("#f3fcf9"),
                                            ),
                                            child: Center(
                                              child: FaIcon(FontAwesomeIcons.clipboard, color: HexColor("#00c160"), size: 24,),
                                            )
                                        ),
                                        Padding(padding: const EdgeInsets.only(top:8),
                                          child: Text("Laporan", style: TextStyle(fontFamily: 'VarelaRound',fontSize: 13)),)
                                      ],
                                    ),
                                  ),

                                  InkWell(
                                    child:Column(
                                      children: [
                                        Container(
                                            height: 55, width: 55,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(50),
                                              color: HexColor("#f3effd"),
                                            ),
                                            child: Center(
                                              child: FaIcon(FontAwesomeIcons.moneyCheck, color: HexColor("#6238b6"),
                                                size: 24,),
                                            )
                                        ),
                                        Padding(padding: const EdgeInsets.only(top:8),
                                          child: Text("Kas Saya",
                                              style: TextStyle(fontFamily: 'VarelaRound',fontSize: 13)),)
                                      ],
                                    ),
                                  ),
  //PREIMUM CONTENT=====================================================
                                  Opacity(
                                    opacity: 0.6,
                                    child : Column(
                                        children: [
                                          Container(
                                              height: 55, width: 55,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(50),
                                                color: HexColor("#DDDDDD"),
                                              ),
                                              child: Center(
                                                child: FaIcon(FontAwesomeIcons.users, color: Colors.black,
                                                  size: 24,),
                                              )
                                          ),
                                          Padding(padding: const EdgeInsets.only(top:8),
                                            child: Text("Customer",
                                                style: TextStyle(fontFamily: 'VarelaRound',fontSize: 13)),)
                                        ],
                                      )),

                                  Opacity(
                                      opacity: 0.6,
                                      child : Column(
                                        children: [
                                          Container(
                                              height: 55, width: 55,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(50),
                                                color: HexColor("#DDDDDD"),
                                              ),
                                              child: Center(
                                                child: FaIcon(FontAwesomeIcons.percent, color: Colors.black,
                                                  size: 24,),
                                              )
                                          ),
                                          Padding(padding: const EdgeInsets.only(top:8),
                                            child: Text("Diskon",
                                                style: TextStyle(fontFamily: 'VarelaRound',fontSize: 13)),)
                                        ],
                                      )),

                                  Opacity(
                                      opacity: 0.6,
                                      child : Column(
                                        children: [
                                          Container(
                                              height: 55, width: 55,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(50),
                                                color: HexColor("#DDDDDD"),
                                              ),
                                              child: Center(
                                                child: FaIcon(FontAwesomeIcons.receipt, color: Colors.black,
                                                  size: 24,),
                                              )
                                          ),
                                          Padding(padding: const EdgeInsets.only(top:8),
                                            child: Text("Voucher",
                                                style: TextStyle(fontFamily: 'VarelaRound',fontSize: 13)),)
                                        ],
                                      )),

                                  Opacity(
                                      opacity: 0.6,
                                      child : Column(
                                        children: [
                                          Container(
                                              height: 55, width: 55,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(50),
                                                color: HexColor("#DDDDDD"),
                                              ),
                                              child: Center(
                                                child: FaIcon(FontAwesomeIcons.truckLoading, color: Colors.black,
                                                  size: 24,),
                                              )
                                          ),
                                          Padding(padding: const EdgeInsets.only(top:8),
                                            child: Text("Pembelian",
                                                style: TextStyle(fontFamily: 'VarelaRound',fontSize: 13)),)
                                        ],
                                      )),

                                  Opacity(
                                      opacity: 0.6,
                                      child : Column(
                                        children: [
                                          Container(
                                              height: 55, width: 55,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(50),
                                                color: HexColor("#DDDDDD"),
                                              ),
                                              child: Center(
                                                child: FaIcon(FontAwesomeIcons.fileInvoice, color: Colors.black,
                                                  size: 24,),
                                              )
                                          ),
                                          Padding(padding: const EdgeInsets.only(top:8),
                                            child: Text("Invoiced",
                                                style: TextStyle(fontFamily: 'VarelaRound',fontSize: 13)),)
                                        ],
                                      )),

                                  Opacity(
                                      opacity: 0.6,
                                      child : Column(
                                        children: [
                                          Container(
                                              height: 55, width: 55,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(50),
                                                color: HexColor("#DDDDDD"),
                                              ),
                                              child: Center(
                                                child: FaIcon(FontAwesomeIcons.user, color: Colors.black,
                                                  size: 24,),
                                              )
                                          ),
                                          Padding(padding: const EdgeInsets.only(top:8),
                                            child: Text("Vendor",
                                                style: TextStyle(fontFamily: 'VarelaRound',fontSize: 13)),)
                                        ],
                                      )),

                                ],
                          )
                        ],
                      )
                    ),


                  ],
                )

          ),
      );
  }
}

/*
class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height-100);
    path.quadraticBezierTo(size.width/2, size.height, size.width, size.height-100);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return null;
  }
}*/