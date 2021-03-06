

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:moobi_flutter/Helper/api_link.dart';
import 'package:moobi_flutter/Helper/check_connection.dart';
import 'package:moobi_flutter/Helper/color_based.dart';
import 'package:moobi_flutter/Helper/page_route.dart';
import 'package:moobi_flutter/Helper/session.dart';
import 'package:moobi_flutter/Setting/page_settinghome.dart';
import 'package:moobi_flutter/Setting/page_legalentites.dart';
import 'package:moobi_flutter/page_login.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class UbahKeteranganToko extends StatefulWidget {
  final String varKode;
  const UbahKeteranganToko(this.varKode);
  @override
  UbahKeteranganTokoState createState() => UbahKeteranganTokoState();
}

class UbahKeteranganTokoState extends State<UbahKeteranganToko> {
  TextEditingController valAlamat = TextEditingController();
  TextEditingController valTelpon = TextEditingController();
  TextEditingController valWebsite = TextEditingController();
  TextEditingController valKota = TextEditingController();


  Future<bool> _onWillPop() async {
    Navigator.pushReplacement(context, EnterPage(page: Toko()));
  }
  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }


  String getEmail = '...';
  _session() async {
    int value = await Session.getValue();
    getEmail = await Session.getEmail();
    if (value != 1) {Navigator.pushReplacement(context, ExitPage(page: Login()));}
  }


  String getStoreAddress = "-";
  String getIDToko = "-";
  String getPhoneToko = "-";
  String getCityToko = "-";
  String getWebsiteToko = '-';
  _userDetail() async {
    final response = await http.get(
        applink+"api_model.php?act=userdetail&id="+getEmail.toString());
    Map data = jsonDecode(response.body);
    setState(() {
      getStoreAddress = data["e"].toString();
      getIDToko = data["f"].toString();
      getPhoneToko = data["h"].toString();
      getCityToko = data["g"].toString();
      getWebsiteToko = data["o"].toString();
    });
  }



  _connect() async {
    Checkconnection().check().then((internet){
      if (internet != null && internet) {} else {
        showToast("Koneksi terputus..", gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      }
    });
  }


  _prepare() async {
    await _connect();
    await _session();
    await _userDetail();
    setState(() {
      valAlamat.text = getStoreAddress.toString();
      valTelpon.text = getPhoneToko.toString();
      valWebsite.text = getWebsiteToko.toString();
      valKota.text = getCityToko.toString();
    });
  }


  @override
  void initState() {
    super.initState();
    _prepare();
  }



  doSimpan() async {
    final response = await http.post(applink+"api_model.php?act=edit_keterangantoko", body: {
      "valalamat_edit": valAlamat.text,
      "valtelpon_edit": valTelpon.text,
      "valwebsite_edit": valWebsite.text,
      "valkota_edit": valKota.text,
      "valID_edit" : getIDToko.toString()
    });
    Map data = jsonDecode(response.body);
    setState(() {
      if (data["message"].toString() == '1') {
        showToast("Legal Entities berhasil diubah ", gravity: Toast.BOTTOM,
            duration: Toast.LENGTH_LONG);
        Navigator.pop(context);
        return false;
       }
    });
  }


  alertSimpan() {
    if (valAlamat.text == "" || valTelpon.text == "" || valKota.text == "") {
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
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: new AppBar(
          backgroundColor: HexColor(main_color),
          title: Text(
            "Edit Legal Entities",
            style: TextStyle(
                color: Colors.white, fontFamily: 'VarelaRound', fontSize: 16),
          ),
          leading: Builder(
            builder: (context) => IconButton(
                icon: new Icon(Icons.arrow_back),
                color: Colors.white,
                onPressed: () => {
                  Navigator.pushReplacement(context, EnterPage(page: Toko()))
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
                              hintText: 'Alamat...',
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


                        Align(alignment: Alignment.centerLeft,child: Padding(
                          padding: const EdgeInsets.only(left: 0,top: 25),
                          child: Text("Website",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "VarelaRound",
                              fontSize: 12,color: HexColor("#0074D9")),),
                        ),),
                        Align(alignment: Alignment.centerLeft,child: Padding(
                          padding: const EdgeInsets.only(left: 0),
                          child: TextFormField(
                            controller: valWebsite,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(top:2),
                              hintText: 'Website...',
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
                          child: Text("Kota",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "VarelaRound",
                              fontSize: 12,color: HexColor("#0074D9")),),
                        ),),
                        Align(alignment: Alignment.centerLeft,child: Padding(
                          padding: const EdgeInsets.only(left: 0),
                          child: TextFormField(
                            controller: valKota,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(top:2),
                              hintText: 'Kota...',
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