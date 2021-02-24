
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:moobi_flutter/Helper/api_link.dart';
import 'package:moobi_flutter/Helper/check_connection.dart';
import 'package:moobi_flutter/Helper/page_route.dart';
import 'dart:async';
import 'dart:convert';

import 'package:moobi_flutter/Helper/session.dart';
import 'package:moobi_flutter/page_login.dart';
import 'package:toast/toast.dart';


class ProdukInsert extends StatefulWidget {
    @override
    _ProdukInsertState createState() => _ProdukInsertState();
}

class _ProdukInsertState extends State<ProdukInsert> {
  String selectedSatuan;
  String selectedType;
  String selectedCategory;
  List _listType = ["Product", "Service"];
  List itemList = List();
  List categoryList = List();
  File galleryFile;
  String Base64;
  String Baseq = "";
  String namaFileq = "";
  String tesMessage = "";
  FocusNode focusNama;
  FocusNode focusHarga;
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
    if (value != 1) {
      Navigator.pushReplacement(context, ExitPage(page: Login()));
    }
  }
  _connect() async {
    Checkconnection().check().then((internet){
      if (internet != null && internet) {} else {
        showToast("Koneksi terputus..", gravity: Toast.CENTER,
            duration: Toast.LENGTH_LONG);
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



  _prepare() async {
    await _connect();
    await _session();
    await _getBranch();
    await getAllItem();
    await getAllCategory();
  }

  @override
  void initState(){
    super.initState();
    _prepare();

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

  imageSelectorGallery() async {
    galleryFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    String fileName = galleryFile.path.split('/').last;
    Base64 = base64Encode((galleryFile.readAsBytesSync()));
    print("You selected gallery image : " + Base64);
    setState(() {
      Baseq = Base64;
      namaFileq = fileName;
    });
  }


  doSimpan() async {
    final response = await http.post(applink+"api_model.php?act=add_produk", body: {
      "produk_nama": _namaproduk.text,
      "produk_satuan" : selectedSatuan,
      "produk_harga" : _hargaproduk.text,
      "produk_type" : selectedType,
      "produk_kategori" : selectedCategory,
      "produk_image": Baseq,
      "produk_branch" : getBranchVal,
      "image_nama" : namaFileq,
       "produk_stockawal" : _stockawalproduk.text
    });
    Map data = jsonDecode(response.body);
    setState(() {
      if (data["message"].toString() == '0') {
        showToast("Nama Produk sudah ada", gravity: Toast.BOTTOM,
            duration: Toast.LENGTH_LONG);
        return false;
      } else {
        _namaproduk.clear();
        _hargaproduk.clear();
        _stockawalproduk.clear();
        namaFileq = "";
        Base64 = "";
        Baseq = "";
        Navigator.pop(context);
        showToast("Produk berhasil diinput", gravity: Toast.BOTTOM,
            duration: Toast.LENGTH_LONG);
        return false;
      }
    });
  }

  alertSimpan() {
    if (selectedCategory == null && selectedSatuan == null && selectedType == null) {
      showToast("Form tidak boleh kosong ", gravity: Toast.BOTTOM,
          duration: Toast.LENGTH_LONG);
      return false;
    }

    if (_namaproduk.text == "" || _hargaproduk.text == "" || _stockawalproduk.text == "") {
      showToast("Form tidak boleh kosong ", gravity: Toast.BOTTOM,
          duration: Toast.LENGTH_LONG);
      return false;
    }

    if (selectedCategory == "" || selectedCategory == null) {
      showToast("Kategori tidak boleh kosong", gravity: Toast.BOTTOM,
          duration: Toast.LENGTH_LONG);
       return false;
    }

    if (selectedSatuan == "" || selectedSatuan == null) {
      showToast("Satuan tidak boleh kosong", gravity: Toast.BOTTOM,
          duration: Toast.LENGTH_LONG);
      return false;
    }

    if (selectedType == "" || selectedSatuan == null) {
      showToast("Type tidak boleh kosong", gravity: Toast.BOTTOM,
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



  Future<bool> _onWillPop() async {
    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
          appBar: new AppBar(
            backgroundColor: HexColor("#602d98"),
            leading: Builder(
              builder: (context) => IconButton(
                icon: new Icon(Icons.arrow_back),
                color: Colors.white,
                onPressed: () {
                  _onWillPop();
                }
              ),
            ),
            title: Text(
             "Input Produk Baru",
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'VarelaRound',
                  fontSize: 16),
            ),
            actions: [
              InkWell(
                onTap: () {
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
          child : SingleChildScrollView(
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
                           hint: Text("Pilih Satuan"),
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
                        child: Text("Type",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "VarelaRound",
                            fontSize: 12,color: HexColor("#0074D9")),),
                      ),),
                      Padding(
                        padding: const EdgeInsets.only(top:10),
                        child: DropdownButton(
                          isExpanded: true,
                          hint: Text("Pilih Type"),
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
                          hint: Text("Pilih Category"),
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


              Padding(padding: const EdgeInsets.only(left: 15,top: 10,right: 15),
                  child: Column(
                    children: [
                      Align(alignment: Alignment.centerLeft,child: Padding(
                        padding: const EdgeInsets.only(left: 0,top: 15),
                        child: Text("Stock Awal Produk",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "VarelaRound",
                            fontSize: 12,color: HexColor("#0074D9")),),
                      ),),
                      Align(alignment: Alignment.centerLeft,child: Padding(
                        padding: const EdgeInsets.only(left: 0),
                        child: TextFormField(
                          controller: _stockawalproduk,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(top:2),
                            hintText: 'Contoh : 1, 50, 100, dst',
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
                        child: Text("Photo Produk",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "VarelaRound",
                            fontSize: 12,color: HexColor("#0074D9")),),
                      ),),
                      Align(alignment: Alignment.centerLeft,child: Padding(
                        padding: const EdgeInsets.only(left: 0),
                        child: Padding(
                          padding: const EdgeInsets.only(top:18),
                          child: Row(
                            children: [
                              OutlineButton(
                                child: Opacity(
                                  opacity: 0.9,
                                  child: Text("Browse Photo"),
                                ),
                                borderSide: BorderSide(
                                  color: HexColor("#602d98"), //Color of the border
                                  style: BorderStyle.solid, //Style of the border
                                  width: 0.8, //width of the border
                                ),
                                onPressed: () {
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  imageSelectorGallery();
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Container(
                                  width: 100,
                                  child: Text(namaFileq.toString(),overflow: TextOverflow.ellipsis,)
                                  ,)
                              )
                            ],
                          )
                        )
                      ),),
                    ],
                  )
              ),



            ],
          )),
        ),
      ),
    );
  }
}