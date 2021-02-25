


import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:moobi_flutter/Helper/api_link.dart';
import 'package:moobi_flutter/Helper/check_connection.dart';
import 'package:moobi_flutter/Helper/session.dart';
import 'package:moobi_flutter/Produk/page_produkdetail.dart';
import 'package:moobi_flutter/helper/page_route.dart';
import 'package:moobi_flutter/page_login.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

class ProdukEdit extends StatefulWidget {
  final String idItem;
  const ProdukEdit(this.idItem);
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
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }



  String getEmail = '...';
  _session() async {
    int value = await Session.getValue();
    getEmail = await Session.getEmail();
    if (value != 1) {Navigator.pushReplacement(context, ExitPage(page: Login()));}
  }

  _connect() async {
    Checkconnection().check().then((internet){
      if (internet != null && internet) {} else {
        showToast("Koneksi terputus..", gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      }
    });
  }

  String getBranchVal = '';
  _getBranch() async {
    final response = await http.get(
        applink+"api_model.php?act=userdetail&id="+getEmail.toString());
    Map data = jsonDecode(response.body);
    setState(() {
      getBranchVal = data["c"].toString();
    });
  }


  String getName = '...';
  String getPhoto = '...';
  String getDiscount = '0';
  String getDiscountVal = '0';
  String getHarga = '0';
  String getItemNumb = '0';
  String getKategori = "...";
  String getStatusProduk = "...";
  String getDateCreated = "...";
  String getSatuan = "...";
  String getType = "...";
  _getDetail() async {
    final response = await http.get(applink+"api_model.php?act=item_detail&id="+widget.idItem);
    Map data = jsonDecode(response.body);
    setState(() {
      getName = data["a"].toString();
      _namaproduk.text = getName;
      getPhoto = data["g"].toString();
      //getDiscount = data["b"].toString();
      //getDiscountVal = data["k"].toString();
      getHarga = data["d"].toString();
      _hargaproduk.text = getHarga;
      getItemNumb = data["l"].toString();
      getKategori = data["i"].toString();
      getStatusProduk = data["f"].toString();
      getDateCreated = data["h"].toString();
      getSatuan = data["c"].toString();
      getType = data["e"].toString();

    });
  }


  _prepare() async {
    await _connect();
    await _session();
    await _getBranch();
    await  _getDetail();
    await getAllItem();
    await getAllCategory();
    setState(() {
      showsave = true;
    });
  }


  Future getAllItem() async {
    //var url = applink+"api_model.php?act=getdata_unit&id="+getBranchVal;
    var response = await http.get(
        Uri.encodeFull(applink+"api_model.php?act=getdata_unit&id="+getBranchVal));
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
        Uri.encodeFull(applink+"api_model.php?act=getdata_category&id="+getBranchVal));
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        categoryList = jsonData;
      });
    }
    print(categoryList);
  }


  @override
  void initState() {
    super.initState();
    _prepare();
  }


  Future<bool> _onWillPop() async {
    Navigator.pushReplacement(context, EnterPage(page: ProdukDetail(widget.idItem)));
  }




  doSimpan() async {
    final response = await http.post(applink+"api_model.php?act=edit_produk", body: {
      "produk_nama": _namaproduk.text,
      "produk_satuan" : selectedSatuan.toString(),
      "produk_harga" : _hargaproduk.text,
      "produk_type" : selectedType.toString(),
      "produk_kategori" : selectedCategory.toString(),
      "produk_branch" : getBranchVal,
      "produk_iditem" : widget.idItem
    });
    Map data = jsonDecode(response.body);
    setState(() {
      if (data["message"].toString() == '0') {
        showToast("Nama Produk sudah ada", gravity: Toast.BOTTOM,
            duration: Toast.LENGTH_LONG);
        return false;
      } else {
        Navigator.pop(context);
        showToast("Produk berhasil diedit", gravity: Toast.BOTTOM,
            duration: Toast.LENGTH_LONG);
        return false;
      }
    });
  }



  alertSimpan() {
    if (_namaproduk.text == "" || _hargaproduk.text == "" ) {
      showToast("Form tidak boleh kosong ", gravity: Toast.BOTTOM,
          duration: Toast.LENGTH_LONG);
      return false;
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(
                "Apakah anda yakin data sudah benar dan menyimpan data ini  ?",
                style: TextStyle(fontFamily: 'VarelaRound', fontSize: 14)),
            actions: [
              Padding(padding: const EdgeInsets.only(left:10,right: 5),
                  child: Container(
                      width: 80,
                      child: new RaisedButton(
                        //color: HexColor("#fb3464"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child:
                          Text("Cancel", style: TextStyle(fontFamily: 'VarelaRound',
                              fontSize: 14)))
                  )
              ),
              Padding(padding: const EdgeInsets.only(left:10,right: 5),
                  child: Container(
                      width: 80,
                      child: new RaisedButton(
                          color: HexColor("#fb3464"),
                          onPressed: () {
                            doSimpan();
                          },
                          child:
                          Text("Simpan", style: TextStyle(fontFamily: 'VarelaRound',
                              fontSize: 14)))
                  )
              )
            ],
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
                        Navigator.pushReplacement(context, EnterPage(page: ProdukDetail(widget.idItem)))
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
                                  child: Text("Harga Produk",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "VarelaRound",
                                      fontSize: 12,color: HexColor("#0074D9")),),
                                ),),
                                Align(alignment: Alignment.centerLeft,child: Padding(
                                  padding: const EdgeInsets.only(left: 0),
                                  child: TextFormField(
                                    controller: _hargaproduk,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.only(top:2),
                                      hintText: 'Contoh : 12000, 15000',
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
                                  child: Text("Type",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "VarelaRound",
                                      fontSize: 12,color: HexColor("#0074D9")),),
                                ),),
                                Padding(
                                  padding: const EdgeInsets.only(top:10),
                                  child: DropdownButton(
                                    isExpanded: true,
                                    hint: Text(getType),
                                    value: selectedType,
                                    items: _listType.map((value){
                                      return DropdownMenuItem(
                                          value: value,
                                          child: Text(value)
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