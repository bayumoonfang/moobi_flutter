

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:moobi_flutter/Helper/api_link.dart';
import 'package:moobi_flutter/Helper/app_helper.dart';
import 'package:moobi_flutter/Helper/color_based.dart';
import 'package:moobi_flutter/Helper/page_route.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import '../page_intoduction.dart';
import '../page_login.dart';

class RiwayatTransaksiDetail extends StatefulWidget{
  final String getEmail;
  final String getLegalCode;
  final String idPayment;

  const RiwayatTransaksiDetail(this.getEmail, this.getLegalCode,this.idPayment);
  @override
  _RiwayatTransaksiDetail createState() => _RiwayatTransaksiDetail();

}


class _RiwayatTransaksiDetail extends State<RiwayatTransaksiDetail> {
  List data;

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }

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


  showFlushBarsuccess(BuildContext context, String stringme) => Flushbar(
    // title:  "Hey Ninja",
    message:  stringme,
    shouldIconPulse: false,
    duration:  Duration(seconds: 10),
    backgroundColor: Colors.black,
    flushbarPosition: FlushbarPosition.BOTTOM ,
  )..show(context);

  void showsuccess(String txtError){
    showFlushBarsuccess(context, txtError);
    return;
  }


  Future<bool> _onWillPop() async {
    Navigator.pop(context);
  }




  String getPayKode = "...";
  String getStatus = "...";
  String getKasir = "...";
  String getMethod = "...";
  String getBank = "...";
  String getCardno = "...";
  String getPemilik = "...";
  String getPaid = "0";
  String getSubtotal = "0";
  String getCharge = "0";
  String getPpn = "0";
  String getTotal = "0";
  String getTgl = "...";
  String getBulan = "...";
  String getTahun = "...";
  String getKodeTrans = "...";
  String getSoNumber = "...";
  String getcustAcc = "...";
  _getDetailPayment() async {
    final response = await http.get(applink+"api_model.php?act=getdata_transaksicust_detail&id="+widget.idPayment+"&getserver="+serverCode.toString());
    Map data2 = jsonDecode(response.body);
    setState(() {
      getPayKode = data2["a"].toString();
      getStatus = data2["b"].toString();
      getPaid = data2["c"].toString();
      getSubtotal = data2["d"].toString();
      getCharge = data2["f"].toString();
      getPpn = data2["e"].toString();
      getTotal = data2["g"].toString();
      getKasir = data2["k"].toString();
      getMethod = data2["p"].toString();
      getBank = data2["i"].toString();
      getCardno = data2["j"].toString();
      getPemilik = data2["q"].toString();
      getTgl = data2["n"].toString();
      getBulan = data2["o"].toString();
      getTahun = data2["l"].toString();
      getKodeTrans = data2["r"].toString();
      getSoNumber = data2["s"].toString();
      getcustAcc = data2["t"].toString();
    });
  }



  Future<List> getData() async {
    http.Response response = await http.get(
        Uri.encodeFull(applink+"api_model.php?act=getdata_listproduktransaksi&"
            "sonumber="+getSoNumber.toString()+"&branch="+widget.getLegalCode+"&getserver="+serverCode.toString()),
        headers: {"Accept":"application/json"});
    return json.decode(response.body);
  }



  _prepare() async {
    await _startingVariable();
    await _getDetailPayment();
  }


  @override
  void initState() {
    super.initState();
    _prepare();
  }


  @override
  Widget build(BuildContext context) {
        return WillPopScope(
            onWillPop: _onWillPop,
          child: Scaffold(
            appBar: new AppBar(
              /* centerTitle: true,*/
              elevation: 0,
              backgroundColor: HexColor(main_color),
              /*title: Image.asset("assets/logo2.png",width: 100,),*/
              title: Text(
                "Detail Transaksi",
                style: TextStyle(
                    color: Colors.white, fontFamily: 'VarelaRound', fontSize: 16),
              ),
              leading: Builder(
                builder: (context) => IconButton(
                    icon: new FaIcon(FontAwesomeIcons.times),
                    color: Colors.white,
                    onPressed: () => {
                      Navigator.pop(context)
                    }),
              ),
            ),
            body: Container(
              color : Colors.white,
              child : Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 120,
                    color: HexColor(main_color),
                    child: Padding(
                        padding: const EdgeInsets.only(top: 10,left: 20,right: 20),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceBetween,
                              children: [
                                Text(getPayKode,style: GoogleFonts.varelaRound(color:Colors.white,fontSize: 16),),
                                Text(getStatus,style: GoogleFonts.varelaRound(color:Colors.white,fontSize: 16),),
                              ],
                            ),
                            Padding(padding: const EdgeInsets.only(top:3),
                              child: Align(alignment: Alignment.centerLeft,child:
                              Text("Kasir : "+getKasir,style: GoogleFonts.varelaRound(color:Colors.white,fontSize: 11),),),),
                            Padding(padding: const EdgeInsets.only(top:20),
                              child: Align(alignment: Alignment.centerLeft,child:
                              Text("Rp. "+
                                  NumberFormat.currency(
                                      locale: 'id', decimalDigits: 0, symbol: '').format(
                                      int.parse(getPaid.toString())),style: GoogleFonts.varelaRound(color:Colors.white,fontSize: 32,fontWeight: FontWeight.bold),),),)
                          ],

                        )
                    ),
                  ),
                  Expanded (
                    child: SingleChildScrollView(
                      child : Column(
                        children: [

                          Padding(padding: const EdgeInsets.only(top: 25,left: 20,right: 20),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(padding: const EdgeInsets.only(top:3),
                                  child: Align(alignment: Alignment.centerLeft,child:
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Align(alignment: Alignment.centerLeft,child:
                                      Text("Dibayar :",style: GoogleFonts.varelaRound(color:Colors.black,fontSize: 12),textAlign: TextAlign.left,),),
                                      Padding(padding : const EdgeInsetsDirectional.only(top:5),child :
                                      Text(getMethod,style: GoogleFonts.varelaRound(color:Colors.black,fontSize: 14,fontWeight: FontWeight.bold),),),
                                      Padding(padding : const EdgeInsetsDirectional.only(top:5),child :
                                      getMethod != 'Cash' ?
                                      Text(getBank+ " - "+getCardno,style: GoogleFonts.varelaRound(color:Colors.black,fontSize: 12),)
                                          :
                                      Container(),
                                      ),
                                      Padding(padding :
                                      getMethod != 'Cash' ?
                                      const EdgeInsetsDirectional.only(top:5)
                                          :
                                      const EdgeInsetsDirectional.only(top:1),child :
                                      Text(getPemilik,style: GoogleFonts.varelaRound(color:Colors.black,fontSize: 11),),)
                                    ],
                                  )

                                  ),),

                              ],
                            ),),


                          Align(
                            alignment: Alignment.centerLeft,
                            child :     Padding(padding:const EdgeInsets.only(top :25,left: 20,right: 20),
                                child: Text("Detail Transaksi", style: GoogleFonts.varelaRound(
                                    fontWeight: FontWeight.bold,fontSize: 15
                                ),)),
                          ),
                          Padding(padding:const EdgeInsets.only(top :5,left: 20,right: 20),
                              child : Divider(height: 5,)),
                          Padding(padding:const EdgeInsets.only(top :10,left: 20,right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Tanggal",style: GoogleFonts.varelaRound(color:Colors.black,fontSize: 13),textAlign: TextAlign.left,),
                                Text(getTgl.toString()+ " "+getBulan.toString()+" "+getTahun.toString()
                                  ,style: GoogleFonts.varelaRound(color:Colors.black,fontSize: 13),),
                              ],
                            ),),
                          Padding(padding:const EdgeInsets.only(top :10,left: 20,right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Customer",style: GoogleFonts.varelaRound(color:Colors.black,fontSize: 13),textAlign: TextAlign.left,),
                                Text(getPemilik.toString()+ " ("+getcustAcc.toString()+")",style: GoogleFonts.varelaRound(color:Colors.black,fontSize: 13),),
                              ],
                            ),),

                          Padding(padding:const EdgeInsets.only(top :10,left: 20,right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Keterangan",style: GoogleFonts.varelaRound(color:Colors.black,fontSize: 13),textAlign: TextAlign.left,),
                                Text(
                                  getKodeTrans == 'RE' ?
                                  "Retur Pembelian" : "Sales Transaction"
                                  ,style: GoogleFonts.varelaRound(color:Colors.black,fontSize: 13),),
                              ],
                            ),),





                          Align(
                            alignment: Alignment.centerLeft,
                            child :     Padding(padding:const EdgeInsets.only(top :25,left: 20,right: 20),
                                child: Text("Detail Pembayaran", style: GoogleFonts.varelaRound(
                                    fontWeight: FontWeight.bold,fontSize: 15
                                ),)),
                          ),
                          Padding(padding:const EdgeInsets.only(top :5,left: 20,right: 20),
                              child : Divider(height: 5,)),


                          Padding(padding:const EdgeInsets.only(top :10,left: 20,right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Subtotal",style: GoogleFonts.varelaRound(color:Colors.black,fontSize: 13),textAlign: TextAlign.left,),
                                Text(NumberFormat.currency(
                                    locale: 'id', decimalDigits: 0, symbol: '').format(
                                    int.parse(getSubtotal.toString())),style: GoogleFonts.varelaRound(color:Colors.black,fontSize: 13),),
                              ],
                            ),),
                          Padding(padding:const EdgeInsets.only(top :10,left: 20,right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Service Charge",style: GoogleFonts.varelaRound(color:Colors.black,fontSize: 13),textAlign: TextAlign.left,),
                                Text(NumberFormat.currency(
                                    locale: 'id', decimalDigits: 0, symbol: '').format(
                                    int.parse(getCharge.toString())),style: GoogleFonts.varelaRound(color:Colors.black,fontSize: 13),),
                              ],
                            ),),
                          Padding(padding:const EdgeInsets.only(top :10,left: 20,right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Tax",style: GoogleFonts.varelaRound(color:Colors.black,fontSize: 13),textAlign: TextAlign.left,),
                                Text(NumberFormat.currency(
                                    locale: 'id', decimalDigits: 0, symbol: '').format(
                                    int.parse(getPpn.toString())),style: GoogleFonts.varelaRound(color:Colors.black,fontSize: 13),),
                              ],
                            ),),
                          Padding(padding:const EdgeInsets.only(top :10,left: 20,right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Total",style: GoogleFonts.varelaRound(color:Colors.black,fontSize: 13),textAlign: TextAlign.left,),
                                Text(NumberFormat.currency(
                                    locale: 'id', decimalDigits: 0, symbol: '').format(
                                    int.parse(getTotal.toString())),style: GoogleFonts.varelaRound(color:Colors.black,fontSize: 13),),
                              ],
                            ),),

                          Align(
                            alignment: Alignment.centerLeft,
                            child :     Padding(padding:const EdgeInsets.only(top :25,left: 20,right: 20),
                                child: Text("Detail Item", style: GoogleFonts.varelaRound(
                                    fontWeight: FontWeight.bold,fontSize: 15
                                ),)),
                          ),
                          Padding(padding:const EdgeInsets.only(top :5,left: 20,right: 20),
                              child : Divider(height: 5,)),
                          Padding(padding:const EdgeInsets.only(top :1,left: 20,right: 20),
                              child : Container(
                                height: 200,
                                width: double.infinity,
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
                                        new ListView.builder(
                                            itemCount: snapshot.data == null ? 0 : snapshot.data.length,
                                            itemBuilder: (context, i) {
                                              return Column(
                                                    children: [
                                                      Padding(padding: const EdgeInsets.only(top: 2)),
                                                      ListTile(
                                                        leading: SizedBox(
                                                            width: 45,
                                                            height: 45,
                                                            child: ClipRRect(
                                                              borderRadius: BorderRadius.circular(6.0),
                                                              child : CachedNetworkImage(
                                                                fit: BoxFit.cover,
                                                                imageUrl:
                                                                snapshot.data[i]["a"] == '' ?
                                                                applink+"photo/nomage.jpg"
                                                                    :
                                                                applink+"photo/"+widget.getLegalCode+"/"+snapshot.data[i]["a"],
                                                                progressIndicatorBuilder: (context, url,
                                                                    downloadProgress) =>
                                                                    CircularProgressIndicator(value:
                                                                    downloadProgress.progress),
                                                                errorWidget: (context, url, error) =>
                                                                    Icon(Icons.error),
                                                              ),
                                                            )),
                                                        title: Align(alignment: Alignment.centerLeft,
                                                          child: Text(snapshot.data[i]["b"],
                                                              style: GoogleFonts.varelaRound(fontSize: 14,fontWeight: FontWeight.bold))
                                                        ),
                                                        subtitle: Column(
                                                          children: [
                                                              Padding(
                                                                padding : const EdgeInsets.only(top: 2),
                                                                child :  Align(alignment: Alignment.centerLeft,
                                                                    child: Text(snapshot.data[i]["c"],
                                                                        style: GoogleFonts.varelaRound(fontSize: 12))
                                                                ),
                                                              ),
                                                          ],
                                                        ),
                                                          trailing:
                                                          Container(
                                                            height: 22,
                                                            width :80,
                                                            child: RaisedButton(
                                                              onPressed: (){},
                                                              color: HexColor("#fe5c83"),
                                                              elevation: 0,
                                                              child: Text(snapshot.data[i]["d"].toString()+ " "+snapshot.data[i]["e"],style: TextStyle(
                                                                  color: HexColor("#f9fffd"), fontFamily: 'Nunito',fontSize: 12,fontWeight: FontWeight.bold)),
                                                            ),
                                                          )
                                                      ),
                                                      Padding(padding: const EdgeInsets.only(top: 2),
                                                      child: Divider(height : 5),)
                                                    ],
                                                  );
                                            }
                                        );
                                      }

                                    }
                                ),
                              )),
                        ],
                      )
                    ),
                  )



                ],
              )
            ),
          ),
        );
  }
}