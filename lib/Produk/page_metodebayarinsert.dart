

import 'dart:convert';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:moobi_flutter/Helper/api_link.dart';
import 'package:moobi_flutter/Helper/app_helper.dart';
import 'package:moobi_flutter/Helper/check_connection.dart';
import 'package:moobi_flutter/Helper/page_route.dart';
import 'package:moobi_flutter/Helper/session.dart';
import 'package:moobi_flutter/Helper/setting_apps.dart';
import 'package:moobi_flutter/page_login.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

import '../page_intoduction.dart';


class MetodeBayarInsert extends StatefulWidget{
  final String getEmail;
  final String getLegalCode;
  const MetodeBayarInsert(this.getEmail, this.getLegalCode);
  @override
  _MetodeBayarInsert createState() => _MetodeBayarInsert();
}


class _MetodeBayarInsert extends State<MetodeBayarInsert> {

  final _valNama = TextEditingController();
  final _valDetail = TextEditingController();
  final _valNamaPemilik = TextEditingController();
  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }

  String selectedType;
  String selectedAcc;
  String selectedPosition;
  List typeList = List();
  List accList = List();

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

  Future getTypeBayar() async {
    var response = await http.get(
        Uri.encodeFull(applink+"api_model.php?act=getdata_typebayar"));
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        typeList = jsonData;
      });
    }
    //print(itemList);
  }



  Future getAccBayar() async {
    var response = await http.get(
        Uri.encodeFull(applink+"api_model.php?act=getdata_accbayar"));
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        accList = jsonData;
      });
    }
    //print(itemList);
  }


  showFlushBarsuccess(BuildContext context, String stringme) => Flushbar(
    // title:  "Hey Ninja",
    message:  stringme,
    shouldIconPulse: false,
    duration:  Duration(seconds: 3),
    backgroundColor: Colors.black,
    flushbarPosition: FlushbarPosition.BOTTOM ,
  )..show(context);

  void showsuccess(String txtError){
    showFlushBarsuccess(context, txtError);
    return;
  }


  _prepare() async {
    await _startingVariable();
    await getTypeBayar();
    await getAccBayar();
  }

  @override
  void initState(){
    super.initState();
    _prepare();

  }

  doSimpan() async {
    Navigator.pop(context);
    final response = await http.post(applink+"api_model.php?act=add_paymentmethod", body: {
      "paymentmethod_nama": _valNama.text,
      "paymentmethod_type" : selectedType,
      "paymentmethod_detail" : _valDetail.text,
      "paymentmethod_an" : _valNamaPemilik.text,
      "paymentmethod_branch" : widget.getLegalCode,
      "getserver" : serverCode,
      "paymentmethod_akun" : selectedAcc.toString(),
      "paymentmethod_positionme" : selectedPosition.toString()
    });
    Map data = jsonDecode(response.body);
    setState(() {
      EasyLoading.dismiss();
      if (data["message"].toString() == '0') {
        showsuccess("Metode Bayar sudah ada");
        return false;
      } else {
        _valNama.clear();
        _valDetail.clear();
        _valNamaPemilik.clear();
        showsuccess("Metode Bayar berhasil ditambah");
        return false;
      }
    });
  }


  _showAlert() {
    if (_valNama.text == "" || _valDetail.text == "" || selectedType == "" || _valNamaPemilik.text == "") {
      showToast("Form tidak boleh kosong", gravity: Toast.BOTTOM,
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
                            EasyLoading.show(status: easyloading_text);
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
      child: Scaffold(
        appBar: new AppBar(
          backgroundColor: HexColor("#602d98"),
          title: Text(
            "Tambah Metode Bayar ",
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
            InkWell(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                _showAlert();
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 27,top : 14),
                child: FaIcon(
                    FontAwesomeIcons.check
                ),
              ),
            )
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
                          child: Text("Nama Bank/Pembayaran",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "VarelaRound",
                              fontSize: 12,color: HexColor("#0074D9")),),
                        ),),
                        Align(alignment: Alignment.centerLeft,child: Padding(
                          padding: const EdgeInsets.only(left: 0),
                          child: TextFormField(
                            controller: _valNama,
                            style: GoogleFonts.nunito(fontSize: 16),
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(top:2),
                              hintText: 'Contoh : Bank BCA, Bank BRI',
                              labelText: '',
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              hintStyle: TextStyle(fontFamily: "VarelaRound", color: HexColor("#c4c4c4"), fontSize: 13),
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
                          child: Text("Nama Pemilik",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "VarelaRound",
                              fontSize: 12,color: HexColor("#0074D9")),),
                        ),),
                        Align(alignment: Alignment.centerLeft,child: Padding(
                          padding: const EdgeInsets.only(left: 0),
                          child: TextFormField(
                            controller: _valNamaPemilik,
                            style: GoogleFonts.nunito(fontSize: 16),
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(top:2),
                              hintText: 'Contoh : Ragil Bayu Respati',
                              labelText: '',
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              hintStyle: TextStyle(fontFamily: "VarelaRound", color: HexColor("#c4c4c4"), fontSize: 13),
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
                          child: Text("Type Pembayaran",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "VarelaRound",
                              fontSize: 12,color: HexColor("#0074D9")),),
                        ),),
                        Align(alignment: Alignment.centerLeft,child: Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: Padding(
                              padding: const EdgeInsets.only(top:10),
                              child: DropdownButton(
                                isExpanded: false,
                                hint: Text("Pilih Type Pembayaran",style: GoogleFonts.nunito(fontSize: 16,color: Colors.black),),
                                value: selectedType,
                                items: typeList.map((myitem){
                                  return DropdownMenuItem(
                                      value: myitem['DATA'],
                                      child: Text(myitem['DATA'],style: GoogleFonts.nunito(fontSize: 16))
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    FocusScope.of(context).requestFocus(FocusNode());
                                    selectedType = value;
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
                          child: Text("Detail",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "VarelaRound",
                              fontSize: 12,color: HexColor("#0074D9")),),
                        ),),
                        Align(alignment: Alignment.centerLeft,child: Padding(
                          padding: const EdgeInsets.only(left: 0),
                          child: TextFormField(
                            controller: _valDetail,
                            style: GoogleFonts.nunito(fontSize: 16),
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(top:2),
                              hintText: 'Contoh : No Rekening, dll',
                              labelText: '',
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              hintStyle: TextStyle(fontFamily: "VarelaRound", color: HexColor("#c4c4c4"), fontSize: 13),
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

                Padding(padding: const EdgeInsets.only(top: 50,left: 13),
                    child: Align(
                        alignment : Alignment.centerLeft,
                        child : Text(
                            "Jurnal Akun", style : GoogleFonts.varelaRound(fontWeight: FontWeight.bold, fontSize: 18)
                        )
                    )),





                Padding(padding: const EdgeInsets.only(left: 15,top: 5,right: 15),
                    child: Column(
                      children: [
                        Align(alignment: Alignment.centerLeft,child: Padding(
                          padding: const EdgeInsets.only(left: 0,top: 15),
                          child: Text("Akun",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "VarelaRound",
                              fontSize: 12,color: HexColor("#0074D9")),),
                        ),),
                        Align(alignment: Alignment.centerLeft,child: Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: Padding(
                              padding: const EdgeInsets.only(top:10),
                              child: DropdownButton(
                                isExpanded: true,
                                hint: Text("Pilih Akun",style: GoogleFonts.nunito(fontSize: 16,color: Colors.black),),
                                value: selectedAcc,
                                items: accList.map((myitem){
                                  return DropdownMenuItem(
                                      value: myitem['mainaccount_kode'],
                                      child: Text(myitem['mainaccount_kode'] + " - "+myitem['mainaccount_nama'],style: GoogleFonts.nunito(fontSize: 16))
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    FocusScope.of(context).requestFocus(FocusNode());
                                    selectedAcc = value;
                                  });
                                },
                              ),
                            )
                        ),),
                      ],
                    )
                ),




                Padding(padding: const EdgeInsets.only(left: 15,top: 5,right: 15),
                    child: Column(
                      children: [
                        Align(alignment: Alignment.centerLeft,child: Padding(
                          padding: const EdgeInsets.only(left: 0,top: 15),
                          child: Text("Position",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "VarelaRound",
                              fontSize: 12,color: HexColor("#0074D9")),),
                        ),),
                        Align(alignment: Alignment.centerLeft,child: Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: Padding(
                              padding: const EdgeInsets.only(top:10),
                              child: DropdownButton(
                                isExpanded: false,
                                hint: Text("Pilih posisi akun",style: GoogleFonts.nunito(fontSize: 16,color: Colors.black),)
                                ,value: selectedPosition,
                                items: <DropdownMenuItem<String>>[
                                  new DropdownMenuItem(
                                    child: new Text('Debit',style: GoogleFonts.nunito(fontSize: 16)),
                                    value: "Debit",
                                  ),
                                  new DropdownMenuItem(
                                    child: new Text('Kredit',style: GoogleFonts.nunito(fontSize: 16)),
                                    value: "Kredit",
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    FocusScope.of(context).requestFocus(FocusNode());
                                    selectedPosition = value;
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