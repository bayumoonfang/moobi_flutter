


import 'dart:convert';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:moobi_flutter/Helper/api_link.dart';
import 'package:moobi_flutter/Helper/app_helper.dart';
import 'package:moobi_flutter/Helper/check_connection.dart';
import 'package:moobi_flutter/Helper/session.dart';
import 'package:moobi_flutter/Produk/page_produkdetail.dart';
import 'package:moobi_flutter/helper/page_route.dart';
import 'package:moobi_flutter/page_login.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

import '../page_intoduction.dart';

class ProdukEdit extends StatefulWidget {
  final String getEmail;
  final String getLegalCode;
  final String getItemNumber;
  final String getNamaUser;
  const ProdukEdit(this.getEmail,this.getLegalCode,this.getItemNumber,this.getNamaUser);
  @override
  _ProdukEdit createState() => _ProdukEdit();
}


class _ProdukEdit extends State<ProdukEdit> {
  String selectedSatuan;
  String selectedType;
  String selectedCategory;
  List _listType = ["Product", "Service"];
  List itemList = List();
  List categoryList = List();

  bool showsave = false;

  final _namaproduk = TextEditingController();
  final _hargaproduk = TextEditingController();
  final _stockawalproduk = TextEditingController();

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




  Future getAllItem() async {
    //var url = applink+"api_model.php?act=getdata_unit&id="+getBranchVal;
    var response = await http.get(
        Uri.encodeFull(applink+"api_model.php?act=getdata_unit&id="+widget.getLegalCode));
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        itemList = jsonData;
      });
    }
    print(itemList);
  }

  Future getAllCategory() async {
    var response = await http.get(
        Uri.encodeFull(applink+"api_model.php?act=getdata_category&id="+widget.getLegalCode));
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        categoryList = jsonData;
      });
    }
    print(categoryList);
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
    await getAllItem();
    await getAllCategory();
    await  _getDetail();

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



  String getName = '...';
  String getPhoto = '...';
  String getKategori = "...";
  String getSatuan = "...";

  _getDetail() async {
    final response = await http.get(applink+"api_model.php?act=item_detail&id="+widget.getItemNumber);
    Map data = jsonDecode(response.body);
    setState(() {
      getName = data["a"].toString();
      _namaproduk.text = getName;
      getPhoto = data["g"].toString();
      getKategori = data["i"].toString();
      getSatuan = data["c"].toString();


    });
  }


  _prepare() async {
    await _startingVariable();
    setState(() {
      showsave = true;
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
    final response = await http.post(applink+"api_model.php?act=edit_produk", body: {
      "produk_nama": _namaproduk.text,
      "produk_satuan" : selectedSatuan.toString(),
      "produk_kategori" : selectedCategory.toString(),
      "produk_branch" : widget.getLegalCode,
      "produk_iditem" : widget.getItemNumber,
      "produk_namauser":widget.getNamaUser
    });
    Map data = jsonDecode(response.body);
    setState(() {
      if (data["message"].toString() == '0') {
        showsuccess("Nama Produk sudah ada");
        return false;
      } else {
        Navigator.pop(context);
        showsuccess("Produk berhasil diedit");
        return false;
      }
    });
  }



  alertSimpan() {
    if (_namaproduk.text == "") {
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
              backgroundColor: HexColor("#602d98"),
              leading: Builder(
                builder: (context) => IconButton(
                    icon: new Icon(Icons.arrow_back,size: 20,),
                    color: Colors.white,
                    onPressed: () => {
                       // Navigator.pushReplacement(context, EnterPage(page: ProdukDetail(widget.idItem)))
                    }),
              ),
              title: Text(
                "Edit Produk",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'VarelaRound',
                    fontSize: 16),
              ),
              actions: [
                  Visibility(
                    child: InkWell(
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
                    ),
                    visible: showsave,
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
                                  child: Text("Nama Produk",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "VarelaRound",
                                      fontSize: 12,color: HexColor("#0074D9")),),
                                ),),
                                Align(alignment: Alignment.centerLeft,child: Padding(
                                  padding: const EdgeInsets.only(left: 0),
                                  child: TextFormField(
                                    controller: _namaproduk,
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.only(top:2),
                                      hintText: 'Contoh : Nasi Goreng, Es Jeruk',
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
                                  child: Text("Satuan",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "VarelaRound",
                                      fontSize: 12,color: HexColor("#0074D9")),),
                                ),),
                                Padding(
                                  padding: const EdgeInsets.only(top:10),
                                  child: DropdownButton(
                                    isExpanded: true,
                                   hint: Text(getSatuan),
                                    value: selectedSatuan,
                                    items: itemList.map((myitem){
                                      return DropdownMenuItem(
                                          value: myitem['DATA'],
                                          child: Text(myitem['DATA']+" ("+myitem['DESCRIPTION']+")")
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        FocusScope.of(context).requestFocus(FocusNode());
                                        selectedSatuan = value;
                                      });
                                    },
                                  ),
                                )
                              ],
                            )
                        ),



                        Padding(padding: const EdgeInsets.only(left: 15,top: 10,right: 15),
                            child: Column(
                              children: [
                                Align(alignment: Alignment.centerLeft,child: Padding(
                                  padding: const EdgeInsets.only(left: 0,top: 15),
                                  child: Text("Category",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "VarelaRound",
                                      fontSize: 12,color: HexColor("#0074D9")),),
                                ),),
                                Padding(
                                  padding: const EdgeInsets.only(top:10),
                                  child: DropdownButton(
                                    isExpanded: true,
                                    hint: Text(getKategori),
                                    value: selectedCategory,
                                    items: categoryList.map((myitem){
                                      return DropdownMenuItem(
                                          value: myitem['DATA'],
                                          child: Text(myitem['DATA'])
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        FocusScope.of(context).requestFocus(FocusNode());
                                        selectedCategory = value;
                                      });
                                    },
                                  ),
                                )
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