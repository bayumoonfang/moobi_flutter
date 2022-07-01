



import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:moobi_flutter/Helper/api_link.dart';
import 'package:moobi_flutter/Helper/app_helper.dart';
import 'package:moobi_flutter/Helper/page_route.dart';
import 'package:moobi_flutter/Setting/page_detailrenewal.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import '../page_intoduction.dart';

class RenewalHistory extends StatefulWidget {
  final String getEmail;
  final String getLegalCode;
  const RenewalHistory(this.getEmail, this.getLegalCode);
  @override
  _RenewalHistory createState() => _RenewalHistory();
}


class _RenewalHistory extends State<RenewalHistory> {

  List data;
  bool _isvisible = true;

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);}


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
  }

  Future<bool> _onWillPop() async {
    Navigator.pop(context);}


  _prepare() async {
    await _startingVariable();
    EasyLoading.dismiss();
  }

  @override
  void initState() {
    super.initState();
    _prepare();
  }


  String filter = "";
  String sortby = '0';
  Future<List> getData() async {
    http.Response response = await http.get(
        Uri.encodeFull(applink+"api_model.php?act=getdata_renewalhistory&"
            "branch="+widget.getLegalCode+
            "&filter="+filter),
        headers: {"Accept":"application/json"});
    return json.decode(response.body);
  }





  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child : Scaffold(
        appBar: new AppBar(
      backgroundColor: HexColor("#602d98"),
      title: Text(
        "Renewal History",
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
              Padding(padding: const EdgeInsets.only(left: 15,top: 10,right: 15),
                  child: Container(
                    height: 50,
                    child: TextFormField(
                      enableInteractiveSelection: false,
                      onChanged: (text) {
                        setState(() {
                          filter = text;
                        });
                      },
                      style: TextStyle(fontFamily: "VarelaRound",fontSize: 14),
                      decoration: new InputDecoration(
                        contentPadding: const EdgeInsets.all(10),
                        fillColor: HexColor("#f4f4f4"),
                        filled: true,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Icon(Icons.search,size: 18,color: HexColor("#6c767f"),),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 1.0,),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: HexColor("#f4f4f4"), width: 1.0),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        hintText: 'Cari  Renewal History...',
                      ),
                    ),
                  )
              ),

              Padding(padding: const EdgeInsets.only(top: 10),),
              Expanded(
                  child: FutureBuilder(
                    future: getData(),
                    builder: (context, snapshot){
                      if (snapshot.data == null) {
                        return Center(
                            child: CircularProgressIndicator()
                        );
                      } else {
                        return snapshot.data == 0 ?
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
                                      "Tidak ada data",
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
                        ListView.builder(
                          itemCount: snapshot.data == null ? 0 : snapshot.data.length,
                          padding: const EdgeInsets.only(left: 10,right: 15),
                          itemBuilder: (context, i) {
                            return InkWell(
                              onTap: (){
                                Navigator.push(context, ExitPage(page: DetailRenewal(snapshot.data[i]["a"].toString(), widget.getEmail)));
                              },
                                child : Card(
                                    child: Column(
                                      children: [
                                        Padding(padding: const EdgeInsets.only(top: 10)),
                                        ListTile(
                                          title: Text(snapshot.data[i]["e"], style: GoogleFonts.varelaRound(fontWeight: FontWeight.bold,fontSize: 12)),
                                          subtitle: Column(
                                            children: [
                                              Padding(
                                                padding : const EdgeInsets.only(top:15)
                                              ),

                                              Padding(padding: const EdgeInsets.only(top: 5),
                                                  child:Align(alignment: Alignment.centerLeft,
                                                    child: Text("Rp. "+
                                                      NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: '').
                                                      format(snapshot.data[i]["c"]), style: GoogleFonts.varelaRound(fontSize: 16,color: Colors.black, fontWeight: FontWeight.bold)),
                                                  )),


                                              Padding(padding: const EdgeInsets.only(top: 5),
                                                  child:Align(alignment: Alignment.centerLeft,
                                                    child: Text("#"+snapshot.data[i]["a"].toString(), style: GoogleFonts.varelaRound(fontSize: 12,color: Colors.black)),)),



                                              Padding(padding: const EdgeInsets.only(top: 5),
                                                child: Align(alignment: Alignment.centerLeft,
                                                  child: Text(snapshot.data[i]["d"].toString(), style: GoogleFonts.varelaRound(fontSize: 12,color: Colors.black))


                                                  ,),)
                                            ],
                                          ),
                                          trailing:                              Container(
                                              height: 22,
                                              child : RaisedButton(
                                                onPressed: (){},
                                                color: snapshot.data[i]["f"].toString() == 'Canceled' ? HexColor("#fe6e66") :
                                                snapshot.data[i]["f"].toString() == 'Unverified' ? HexColor("#ffa528") :
                                                snapshot.data[i]["f"].toString() == 'Verified' ? HexColor("#1c6bea") :
                                                HexColor("#00c160"),
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(side: BorderSide(
                                                    color: Colors.white,
                                                    width: 0.1,
                                                    style: BorderStyle.solid
                                                ),
                                                  borderRadius: BorderRadius.circular(50.0),
                                                ),
                                                child: Text(snapshot.data[i]["f"].toString(),style: TextStyle(
                                                    color: Colors.white, fontFamily: 'VarelaRound',fontSize: 13)),
                                              )
                                          ),
                                        ),
                                        Padding(padding: const EdgeInsets.only(bottom: 10))

                                      ],
                                    )
                                )
                            );
                          },
                        );
                      }

                    },
                  )
              ),
            ],
          ),
        ),


      )
    );
  }
}