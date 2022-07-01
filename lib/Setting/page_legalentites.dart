


import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:moobi_flutter/Helper/app_helper.dart';
import 'package:moobi_flutter/Helper/color_based.dart';
import 'package:moobi_flutter/Helper/setting_apps.dart';
import 'package:moobi_flutter/Setting/page_editlegalentites.dart';
import 'package:moobi_flutter/Setting/page_renewalhistory.dart';
import 'package:moobi_flutter/helper/api_link.dart';
import 'package:moobi_flutter/helper/page_route.dart';
import 'package:moobi_flutter/helper/session.dart';
import 'package:moobi_flutter/page_login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:toast/toast.dart';

import '../page_intoduction.dart';
class LegalEntities extends StatefulWidget {
  final String getEmail;
  final String getLegalCode;
  const LegalEntities(this.getEmail, this.getLegalCode);
  @override
  _LegalEntities createState() => _LegalEntities();
}


class _LegalEntities extends State<LegalEntities> {
  Future<bool> _onWillPop() async {
    Navigator.pop(context);
  }
  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }

  String getStorename = "-";
  String getStoreAddress = "-";
  String getIDToko = "-";
  String getPhoneToko = "-";
  String getCityToko = "-";
  String getStatusToko = '-';
  String getWebsiteToko = '-';
  String getLicense = '...';
  String getRegisterDate = '...';
  String getEndDate = '...';

  //=============================================================================
  String serverName = '';
  String serverCode = '';
  _startingVariable() async {
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      showToast("Koneksi terputus..", gravity: Toast.CENTER,duration:
      Toast.LENGTH_LONG);}});
    await AppHelper().getSession().then((value){
      setState(() {serverName = value[11];serverCode = value[12];});});
    await AppHelper().cekServer(widget.getEmail).then((value){
      if(value[0] == '0') {Navigator.pushReplacement(context, ExitPage(page: Introduction()));}});
    await AppHelper().cekLegalUser(widget.getEmail.toString(), serverCode.toString()).then((value){
      if(value[0] == '0') {Navigator.pushReplacement(context, ExitPage(page: Introduction()));}});
    AppHelper().getDetailUser(widget.getEmail.toString(), serverCode.toString()).then((value){
      setState(() {
        getStorename = value[0];
        getStoreAddress = value[3];
        getIDToko = value[15];
        getPhoneToko = value[6];
        getWebsiteToko = value[12];
        getCityToko = value[5];
        getStatusToko = value[7];
        getLicense = value[18];
        getRegisterDate = value[19];
        getEndDate = value[20];
      });
    });

  }

  FutureOr onGoBack(dynamic value) {
    AppHelper().getDetailUser(widget.getEmail.toString(), serverCode.toString()).then((value){
      setState(() {
        getStorename = value[0];
        getStoreAddress = value[3];
        getIDToko = value[15];
        getPhoneToko = value[6];
        getWebsiteToko = value[12];
        getCityToko = value[5];
        getStatusToko = value[7];
        getLicense = value[18];
        getRegisterDate = value[19];
        getEndDate = value[20];
      });
    });
    setState(() {});
  }

  loadData() async {
    EasyLoading.show(status: easyloading_text);
    await _startingVariable();
    EasyLoading.dismiss();
  }


  @override
  void initState() {
    super.initState();
    loadData();
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: new AppBar(
          backgroundColor: HexColor("#602d98"),
          title: Text(
            "Detail Legal Entities",
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
          height: double.infinity,
          width: double.infinity,
          child:
          SingleChildScrollView(
              child:
              Column(
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(padding: const EdgeInsets.only(top: 35,left: 15),
                          child: Text("Legal Entities", style: GoogleFonts.varelaRound(fontWeight: FontWeight.bold, fontSize: 24)))),

                  Padding(padding: const EdgeInsets.only(top: 20),
                    child: ListTile(
                      leading: Opacity(
                        opacity: 0.7,
                        child: CircleAvatar(
                          radius: 30,
                          child: FaIcon(FontAwesomeIcons.store),
                        ),
                      ),
                      title: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(getStorename.toString(),style: TextStyle(fontFamily: 'VarelaRound',)),),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top:5),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(getStoreAddress.toString(),style: TextStyle(fontFamily: 'VarelaRound',height: 1.6)),),
                      )
                    ),
                  ),

                  Padding(padding: const EdgeInsets.only(top :15),
                    child: Container(
                      height: 10,
                      width: double.infinity,
                      color: HexColor("#f4f4f4"),
                    ),),


                  Padding(padding: const EdgeInsets.only(top: 20,left: 25),
                    child: Column(
                      children: [
                        Align(alignment: Alignment.centerLeft,child: Text("Informasi",style: TextStyle(
                            color: Colors.black, fontFamily: 'VarelaRound',fontSize: 16,
                            fontWeight: FontWeight.bold)),),


                        Padding(padding: const EdgeInsets.only(top: 10,right: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .spaceBetween,
                            children: [
                              Text(
                                "Email",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: 'VarelaRound',
                                    fontSize: 14),
                              ),
                              Text(widget.getEmail.toString(),
                                  style: TextStyle(
                                      fontFamily: 'VarelaRound',
                                      fontSize: 14)),
                            ],
                          ),),


                        Padding(padding: const EdgeInsets.only(top: 10,right: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .spaceBetween,
                            children: [
                              Text(
                                "Phone",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: 'VarelaRound',
                                    fontSize: 14),
                              ),
                              Text(getPhoneToko.toString(),
                                  style: TextStyle(
                                      fontFamily: 'VarelaRound',
                                      fontSize: 14)),
                            ],
                          ),),



                        Padding(padding: const EdgeInsets.only(top: 10,right: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .spaceBetween,
                            children: [
                              Text(
                                "Website",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: 'VarelaRound',
                                    fontSize: 14),
                              ),
                              Text(getWebsiteToko.toString(),
                                  style: TextStyle(
                                      fontFamily: 'VarelaRound',
                                      fontSize: 14)),
                            ],
                          ),),


                        Padding(padding: const EdgeInsets.only(top: 10,right: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .spaceBetween,
                            children: [
                              Text(
                                "Kota",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: 'VarelaRound',
                                    fontSize: 14),
                              ),
                              Text(getCityToko.toString(),
                                  style: TextStyle(
                                      fontFamily: 'VarelaRound',
                                      fontSize: 14)),
                            ],
                          ),),


                      ],
                    ),),

                  Padding(padding: const EdgeInsets.only(top :25),
                    child: Container(
                      height: 10,
                      width: double.infinity,
                      color: HexColor("#f4f4f4"),
                    ),),



                  Padding(padding: const EdgeInsets.only(top: 20,left: 25),
                    child: Column(
                      children: [
                        Align(alignment: Alignment.centerLeft,child: Text("License Information",style: TextStyle(
                            color: Colors.black, fontFamily: 'VarelaRound',fontSize: 16,
                            fontWeight: FontWeight.bold)),),

                        Padding(padding: const EdgeInsets.only(top: 10,right: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .spaceBetween,
                            children: [
                              Text(
                                "Entiti ID",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: 'VarelaRound',
                                    fontSize: 14),
                              ),
                              Text(getIDToko.toString(),
                                  style: TextStyle(
                                      fontFamily: 'VarelaRound',
                                      fontSize: 14)),
                            ],
                          ),),



                        Padding(padding: const EdgeInsets.only(top: 10,right: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .spaceBetween,
                            children: [
                              Text(
                                "License Number",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: 'VarelaRound',
                                    fontSize: 14),
                              ),
                              Text(getLicense.toString(),
                                  style: TextStyle(
                                      fontFamily: 'VarelaRound',
                                      fontSize: 14,fontWeight: FontWeight.bold)),
                            ],
                          ),),

                        Padding(padding: const EdgeInsets.only(top: 10,right: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .spaceBetween,
                            children: [
                              Text(
                                "End Date",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: 'VarelaRound',
                                    fontSize: 14),
                              ),
                              Text(getEndDate.toString(),
                                  style: TextStyle(
                                      fontFamily: 'VarelaRound',
                                      fontSize: 14,fontWeight: FontWeight.bold)),
                            ],
                          ),),


                        Padding(padding: const EdgeInsets.only(top: 10,right: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .spaceBetween,
                            children: [
                              Text(
                                "Status",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: 'VarelaRound',
                                    fontSize: 14),
                              ),
                              Container(
                                height: 22,
                                child : RaisedButton(
                                  onPressed: (){},
                                  color: HexColor("#00c160"),
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(side: BorderSide(
                                      color: Colors.black,
                                      width: 0.1,
                                      style: BorderStyle.solid
                                  ),
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                  child: Text(getStatusToko,style: TextStyle(
                                      color: Colors.white, fontFamily: 'VarelaRound',fontSize: 13)),
                                )
                              )
                            ],
                          ),),


                      ],
                    ),),

                  Padding(padding: const EdgeInsets.only(top :20),
                    child: Container(
                      height: 10,
                      width: double.infinity,
                      color: HexColor("#f4f4f4"),
                    ),),




                  Padding(padding: const EdgeInsets.only(top: 20,left: 25,right: 25),
                    child: Column(
                      children: [


                        InkWell(
                          child: ListTile(
                            dense: true,
                            minLeadingWidth: 20,
                            horizontalTitleGap: 20,
                            contentPadding: EdgeInsets.all(1),
                            onTap: (){
                              Navigator.push(context, ExitPage(page: RenewalHistory(widget.getEmail, widget.getLegalCode)));

                            },//Navigator.push(context, ExitPage(page: SettingPPN(widget.getEmail, widget.getLegalCode)));},
                            title: Text("Renewal History",style: TextStyle(
                                color: Colors.black, fontFamily: 'VarelaRound',fontSize: 15,
                                fontWeight: FontWeight.bold)),
                            subtitle: Text("Lihat history pembayaran renewal kamu",style: TextStyle(
                                color: Colors.black, fontFamily: 'VarelaRound',fontSize: 12)),
                            trailing: FaIcon(FontAwesomeIcons.angleRight,color: HexColor("#594d75")),
                          ),
                        ),
                        Padding(padding: const EdgeInsets.only(top: 5,left: 15),
                          child: Divider(height: 3,),),



                        Padding(padding: const EdgeInsets.only(top: 10),
                            child: InkWell(
                              child: ListTile(
                                  dense: true,
                                  minLeadingWidth: 20,
                                  horizontalTitleGap: 20,
                                  contentPadding: EdgeInsets.all(1),
                                  onTap: (){

                                    Navigator.push(context, ExitPage(page: UbahKeteranganToko(widget.getEmail, widget.getLegalCode))).then(onGoBack);

                                  },
                                  leading: FaIcon(FontAwesomeIcons.edit,color: HexColor("#ffa427"),size: 19,),
                                  title: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 1,top: 4),
                                      child: Text("Ubah Keterangan",style: TextStyle(
                                          color: Colors.black, fontFamily: 'VarelaRound',fontSize: 14)),
                                    ),
                                  ),
                                  trailing: FaIcon(FontAwesomeIcons.angleRight,color: HexColor("#594d75"),
                                  )
                              ),
                            )
                        ),
                        Padding(padding: const EdgeInsets.only(top: 5),
                          child: Divider(height: 3,),),


                      ],
                    ),),


                ],
              )),
        ),
      ),

    );
  }
}