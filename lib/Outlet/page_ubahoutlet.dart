


import 'dart:convert';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:moobi_flutter/Helper/api_link.dart';
import 'package:moobi_flutter/Helper/app_helper.dart';
import 'package:moobi_flutter/Helper/color_based.dart';
import 'package:moobi_flutter/Helper/page_route.dart';
import 'package:moobi_flutter/page_login.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

import '../page_intoduction.dart';


class UbahOutlet extends StatefulWidget{
  final String getEmail;
  final String getLegalCode;
  final String idOutlet;

  const UbahOutlet(this.getEmail, this.getLegalCode,this.idOutlet);
  _UbahOutlet createState() => _UbahOutlet();
}


class _UbahOutlet extends State<UbahOutlet> {
  TextEditingController valNama = TextEditingController();
  TextEditingController valAlamat = TextEditingController();
  TextEditingController valTelpon = TextEditingController();

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);}

  _cekLegalandUser() async {
    final response = await http.post(applink+"api_model.php?act=cek_legalanduser",
        body: {"username": widget.getEmail.toString()},
        headers: {"Accept":"application/json"});
    Map data = jsonDecode(response.body);
    setState(() {
      if (data["message"].toString() == '2' || data["message"].toString() == '3') {
        Navigator.pushReplacement(context, ExitPage(page: Introduction()));
      }
    });
  }

  //=============================================================================
  _startingVariable() async {
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      showToast("Koneksi terputus..", gravity: Toast.CENTER,duration:
      Toast.LENGTH_LONG);}});
    await AppHelper().getSession().then((value){
      if(value[0] != 1) {
        Navigator.pushReplacement(context, ExitPage(page: Login()));
      }
    });
    await _cekLegalandUser();

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

  String getOutletName = "...";
  String getOutletAddress = "...";
  String getOutletPhone = "...";

  _outletDetail() async {
    final response = await http.get(
        applink+"api_model.php?act=outletdetail&id="+widget.idOutlet);
    Map data = jsonDecode(response.body);
    setState(() {
      getOutletName = data["a"].toString();
      getOutletAddress = data["b"].toString();
      getOutletPhone = data["d"].toString();
    });
  }



  _prepare() async {
    await _startingVariable();
    await _outletDetail();
    setState(() {
      valNama.text = getOutletName;
      valAlamat.text = getOutletAddress;
      valTelpon.text = getOutletPhone;
    });
  }



  @override
  void initState() {
    super.initState();
    _prepare();
  }


  Future<bool> _onWillPop() async {
    Navigator.pop(context);
  }

  doSimpan() async {
    Navigator.pop(context);
    final response = await http.post(applink+"api_model.php?act=edit_keteranganoutlet", body: {
      "valnama_edit": valNama.text,
      "valalamat_edit": valAlamat.text,
      "valtelpon_edit": valTelpon.text,
      "valID_edit" : widget.idOutlet.toString()
    });
    Map data = jsonDecode(response.body);
    setState(() {
      if (data["message"].toString() == '1') {
        showsuccess("Data outlet berhasil diubah");
        return false;
      } else {
        showsuccess("Nama outlet sudah ada , silahkan gunakan nama lain");
        return false;
      }
    });
  }



  alertSimpan() {
    if (valNama.text == "" || valAlamat.text == "" || valTelpon.text == "") {
      showToast("Form tidak boleh kosong ", gravity: Toast.BOTTOM,
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
    return WillPopScope(child: Scaffold(
      appBar: new AppBar(
          backgroundColor: HexColor(main_color),
          title: Text(
            "Ubah Keterangan Outlet",
            style: TextStyle(
                color: Colors.white, fontFamily: 'VarelaRound', fontSize: 16),
          ),
          leading: Builder(
            builder: (context) => IconButton(
                icon: new Icon(Icons.arrow_back),
                color: Colors.white,
                onPressed: () => {
                  //Navigator.pushReplacement(context, EnterPage(page: DetailOutlet(widget.idOutlet)))
                  Navigator.pop(context)
                }),
          ),
        actions: [
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
                        child: Text("Nama Outlet",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "VarelaRound",
                            fontSize: 12,color: HexColor("#0074D9")),),
                      ),),
                      Align(alignment: Alignment.centerLeft,child: Padding(
                        padding: const EdgeInsets.only(left: 0),
                        child: TextFormField(
                          controller: valNama,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(top:2),
                            hintText: 'Nama Outlet...',
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


                      Align(alignment: Alignment.centerLeft,child: Padding(
                        padding: const EdgeInsets.only(left: 0,top: 25),
                        child: Text("Alamat",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "VarelaRound",
                            fontSize: 12,color: HexColor("#0074D9")),),
                      ),),
                      Align(alignment: Alignment.centerLeft,child: Padding(
                        padding: const EdgeInsets.only(left: 0),
                        child: TextFormField(
                          controller: valAlamat,
                          maxLines: 4,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(top:2),
                            hintText: 'Alamat Outlet...',
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



                      Align(alignment: Alignment.centerLeft,child: Padding(
                        padding: const EdgeInsets.only(left: 0,top: 25),
                        child: Text("Telpon",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "VarelaRound",
                            fontSize: 12,color: HexColor("#0074D9")),),
                      ),),
                      Align(alignment: Alignment.centerLeft,child: Padding(
                        padding: const EdgeInsets.only(left: 0),
                        child: TextFormField(
                          controller: valTelpon,
                          keyboardType: TextInputType.number,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(top:2),
                            hintText: 'Telpon...',
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
    ), onWillPop: _onWillPop);
  }
}