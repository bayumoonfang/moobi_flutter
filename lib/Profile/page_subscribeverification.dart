


import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:moobi_flutter/Helper/app_helper.dart';
import 'package:moobi_flutter/Helper/check_connection.dart';
import 'package:moobi_flutter/Helper/color_based.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:moobi_flutter/Helper/api_link.dart';
import 'package:moobi_flutter/Helper/page_route.dart';
import 'package:moobi_flutter/Helper/session.dart';
import 'package:moobi_flutter/Helper/setting_apps.dart';
import 'package:moobi_flutter/Profile/page_paymentloading.dart';
import 'package:moobi_flutter/page_intoduction.dart';
import 'package:moobi_flutter/page_login.dart';
import 'package:toast/toast.dart';

class SubscribeVerification extends StatefulWidget{
  final String getEmail;
  final String getLegalcode;
  const SubscribeVerification(this.getEmail, this.getLegalcode);
  @override
  SubscribeVerificationState createState() => SubscribeVerificationState();
}

class SubscribeVerificationState extends State<SubscribeVerification> {
  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }
  List itemList = List();
  List bankUserList = List();
  String selectedTransferKe;
  String selectedBankUser;
  final valUserid = TextEditingController();
  String valType = "REGISTER";
  String valAmount = hargaAplikasi;
  String valTanggalFix;
  final valTanggal = TextEditingController();
  final valNamaUserPembayaran = TextEditingController();
  DateTime selectedDate = DateTime.now();


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

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2020),
      helpText: 'Pilih tanggal pembayaran', // Can be used as title
      cancelText: 'Keluar',
      confirmText: 'Pilih',
      lastDate: DateTime(2055),
    );

      setState(() {
        selectedDate = picked;
        if (picked != null && picked != selectedDate) {
          valTanggal.text = new DateFormat("dd-MM-yyyy").format(picked);
          valTanggalFix = new DateFormat("yyyy-MM-dd").format(picked);
        } else {
          valTanggal.text = new DateFormat("dd-MM-yyyy").format(selectedDate);
          valTanggalFix = new DateFormat("yyyy-MM-dd").format(selectedDate);
        }

      });
  }


  String val_legalcode = "";
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
      setState(() {val_legalcode = value[15]; });});

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
    //print(itemList);
  }

  Future getBankUser() async {
    var response = await http.get(
        Uri.encodeFull(applink+"api_model.php?act=getdata_bankuser&legalid="+widget.getLegalcode+"&getserver="+serverCode.toString()));
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        bankUserList = jsonData;
      });
    }
    //print(bankUserList);
  }





  _prepare() async {
    await _startingVariable();
    await getAllItem();
    await getBankUser();
    setState(() {
      valUserid.text = val_legalcode;
    });
  }

  @override
  void initState(){
    super.initState();
    _prepare();

  }


  doSimpan() async {
    //Navigator.pop(context);
    //showsuccess("Mohon menunggu sebentar , dan tidak keluar dari aplikasi");
    final response = await http.post(applink+"api_model.php?act=add_pembayaranreg", body: {
      "pembayaran_userid": valUserid.text,
      "pembayaran_type" : valType,
      "pembayaran_amount" : valAmount,
      "pembayaran_description" : "Pembayaran Registrasi Subscribe "+valUserid.text,
      "pembayaran_status": "Unverified",
      "pembayaran_paymentvendor" : selectedTransferKe,
      "pembayaran_bankuser" : selectedBankUser,
      "pembayaran_tglbayar" : valTanggalFix,
      "getserver" : serverCode
      //"pembayaran_an" : valNamaUserPembayaran.text
    });
    Map data = jsonDecode(response.body);
    setState(() {
        Navigator.pushReplacement(context, ExitPage(page: PaymentLoading()));
    });
  }



  alertSimpan() {
    if (selectedTransferKe == null && selectedBankUser == null) {
      showToast("Form tidak boleh kosong ", gravity: Toast.BOTTOM,
          duration: Toast.LENGTH_LONG);
      return false;
    }

    if (valUserid.text == "" || valTanggal.text == "") {
      showToast("Form tidak boleh kosong ", gravity: Toast.BOTTOM,
          duration: Toast.LENGTH_LONG);
      return false;
    }

    if (selectedTransferKe == "" || selectedTransferKe == null) {
      showToast("Kategori tidak boleh kosong", gravity: Toast.BOTTOM,
          duration: Toast.LENGTH_LONG);
      return false;
    }

    if (selectedBankUser == "" || selectedBankUser == null) {
      showToast("Satuan tidak boleh kosong", gravity: Toast.BOTTOM,
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
                    Text("Apakah data pembayaran anda sudah benar ? ",
                        style: TextStyle(fontFamily: 'VarelaRound', fontSize: 12)),)),
                    Padding(padding: const EdgeInsets.only(top: 25), child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(child: OutlineButton(
                          onPressed: () {Navigator.pop(context);}, child: Text("Belum"),)),
                        Expanded(child: OutlineButton(
                          borderSide: BorderSide(width: 1.0, color: Colors.redAccent),
                          onPressed: () {
                            Navigator.pop(context);
                            showsuccess("Mohon menunggu sebentar , dan tidak keluar dari aplikasi");
                            doSimpan();
                            //Navigator.pop(context);
                          }, child: Text("Sudah", style: TextStyle(color: Colors.red),),)),
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
          actions: [
            val_legalcode != '' ?
            InkWell(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                alertSimpan();
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 27,top : 14),
                child: FaIcon(
                    FontAwesomeIcons.check
                ),
              ),
            )
                :
                Container()
          ],
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
                          child: Text("Legal Code",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "VarelaRound",
                              fontSize: 12,color: HexColor("#0074D9")),),
                        ),),
                        Align(alignment: Alignment.centerLeft,child: Padding(
                          padding: const EdgeInsets.only(left: 0),
                          child: TextFormField(
                            style: TextStyle(color: HexColor("#AAAAAA"),fontFamily: "VarelaRound", ),
                            textCapitalization: TextCapitalization.sentences,
                            enabled: false,
                            controller: valUserid,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(top:2),
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
                              isExpanded: false,
                              hint: Text("Pilih Bank/Payment Tujuan",style: TextStyle(
                                fontFamily: "VarelaRound", fontSize: 14
                                 )),
                              value: selectedTransferKe,
                              items: itemList.map((myitem){
                                return DropdownMenuItem(
                                    value: myitem['ID'],
                                    child: Row(
                                      children: [
                                        Text(myitem['NAMA'],style: GoogleFonts.nunito(fontWeight: FontWeight.bold,fontSize: 16)),
                                        Padding(padding: const EdgeInsets.only(left: 5)),
                                        Text(myitem['NOPAYMENT'],style: GoogleFonts.nunito(fontSize: 13))
                                      ],
                                    )
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




                Padding(padding: const EdgeInsets.only(left: 15,top: 10,right: 15),
                    child: Column(
                      children: [
                        Align(alignment: Alignment.centerLeft,child: Padding(
                          padding: const EdgeInsets.only(left: 0,top: 15),
                          child: Text("Payment anda",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "VarelaRound",
                              fontSize: 12,color: HexColor("#0074D9")),),
                        ),),
                        Align(alignment: Alignment.centerLeft,child: Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: Padding(
                              padding: const EdgeInsets.only(top:10),
                              child: DropdownButton(
                                isExpanded: false,
                                hint: Text("Pilih Payment anda",style: TextStyle(
                                    fontFamily: "VarelaRound", fontSize: 14
                                )),
                                value: selectedBankUser,
                                items: bankUserList.map((myitem){
                                  return DropdownMenuItem(
                                      value: myitem['bank_id'],
                                      child: Row(
                                        children: [
                                          Text(myitem['bank_nama'],style: GoogleFonts.nunito(fontWeight: FontWeight.bold,fontSize: 16)),
                                          Padding(padding: const EdgeInsets.only(left: 5)),
                                          Text(myitem['bank_norek'],style: GoogleFonts.nunito(fontSize: 13))
                                        ],
                                      )
                                     /* child: Column(
                                        children: [
                                          Align(alignment: Alignment.bottomLeft,child :
                                          Padding(padding : const EdgeInsets.only(top: 5), child :
                                          Text(myitem['bank_nama'], style: GoogleFonts.nunito(fontWeight: FontWeight.bold,fontSize: 16),))),
                                          Align(alignment: Alignment.bottomLeft,child :
                                          Padding(padding : const EdgeInsets.only(top: 3), child :
                                          Text(myitem['bank_norek'], style: GoogleFonts.nunito(fontSize: 14),))),
                                          Align(alignment: Alignment.bottomLeft,child :
                                          Padding(padding : const EdgeInsets.only(top: 3), child :
                                          Text("a.n "+myitem['bank_pemilik'], style: GoogleFonts.nunito(fontSize: 12),))),
                                          Padding(padding : const EdgeInsets.only(top: 5), child :
                                          Divider(height: 4,)),

                                        ],
                                      )*/
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    FocusScope.of(context).requestFocus(FocusNode());
                                    selectedBankUser = value;
                                  });
                                },
                              ),
                            )
                        ),),
                      ],
                    )
                ),


/*
                Padding(padding: const EdgeInsets.only(left: 15,top: 10,right: 15),
                    child: Column(
                      children: [
                        Align(alignment: Alignment.centerLeft,child: Padding(
                          padding: const EdgeInsets.only(left: 0,top: 15),
                          child: Text("Pembayaran atas nama",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "VarelaRound",
                              fontSize: 12,color: HexColor("#0074D9")),),
                        ),),
                        Align(alignment: Alignment.centerLeft,child: Padding(
                          padding: const EdgeInsets.only(left: 0),
                          child: TextFormField(
                            style: TextStyle(fontFamily: "VarelaRound", ),
                            textCapitalization: TextCapitalization.words,
                            controller: valNamaUserPembayaran,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(top:2),
                              labelText: 'Contoh : Ragil Bayu Respati',
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
                ),*/



                Padding(padding: const EdgeInsets.only(left: 15,top: 10,right: 15),
                    child: Column(
                      children: [
                        Align(alignment: Alignment.centerLeft,child: Padding(
                          padding: const EdgeInsets.only(left: 0,top: 15),
                          child: Text("Tanggal Pembayaran",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "VarelaRound",
                              fontSize: 12,color: HexColor("#0074D9")),),
                        ),),
                        Align(alignment: Alignment.centerLeft,child: Padding(
                          padding: const EdgeInsets.only(left: 0),
                          child: TextFormField(
                            //style: TextStyle(color: HexColor("#AAAAAA")),
                            onTap: (){
                              FocusScope.of(context).requestFocus(FocusNode());
                              _selectDate(context);
                            },
                            textCapitalization: TextCapitalization.sentences,
                            controller: valTanggal,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(top:2),
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

              ],
            ),
          ),
        ),


      ),
    );
  }
}