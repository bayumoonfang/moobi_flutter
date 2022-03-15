



import 'dart:convert';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:moobi_flutter/Helper/api_link.dart';
import 'package:moobi_flutter/Helper/app_helper.dart';
import 'package:moobi_flutter/Helper/page_route.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import '../page_intoduction.dart';
import '../page_login.dart';

class ProdukInsert2 extends StatefulWidget {
  final String getEmail;
  final String getLegalCode;
  final String getProdukNumber;
  final String getProdukTipe;
  final String getSatuan;
  final String getNamaUser;

  const ProdukInsert2(this.getEmail,this.getLegalCode,this.getProdukNumber, this.getProdukTipe, this.getSatuan, this.getNamaUser);

  @override
  _ProdukInsertState2 createState() => _ProdukInsertState2();
}

class _ProdukInsertState2 extends State<ProdukInsert2> {
  String selectedStore;
  String selectedWarehouse;

  List itemList = List();
  List itemList2 = List();
  bool _showstock = false;
  final _hargaproduk = TextEditingController();
  final _stockawal = TextEditingController();

  Future<bool> _onWillPop() async {

  }


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


  Future getAllStore() async {
    var response = await http.get(
        Uri.encodeFull(applink+"api_model.php?act=getdata_store&id="+widget.getLegalCode));
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        itemList = jsonData;
      });
    }
  }

  Future getAllWarehouse() async {
    var response = await http.get(
        Uri.encodeFull(applink+"api_model.php?act=getdata_warehouse2&id="+widget.getLegalCode));
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      //print (applink+"api_model.php?act=getdata_warehouse&id="+widget.getLegalCode);
      setState(() {
        itemList2 = jsonData;
      });
    }
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
    await getAllStore();
    await getAllWarehouse();
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
  }

  @override
  void initState(){
    super.initState();
    _prepare();

  }

  String stock_val = "false";
  void show_stock() async {
    setState(() {
      if(stock_val == 'false') {
        stock_val = 'true';
        _showstock = true;
      } else {
        stock_val = 'false';
        _showstock = false;
      }
    });
  }



  doSimpan() async {
    final response = await http.post(applink+"api_model.php?act=add_produkinfo", body: {
      "produk_number": widget.getProdukNumber,
      "produk_branch" : widget.getLegalCode,
      "produk_tipe" : widget.getProdukTipe,
      "produk_store" : selectedStore,
      "produk_warehouse": selectedWarehouse,
      "produk_harga": _hargaproduk.text,
      "produk_stock" : _stockawal.text,
      "show_stock" : stock_val,
      "produk_satuan" : widget.getSatuan,
      "nama_user" : widget.getNamaUser
    });
    Map data = jsonDecode(response.body);
    setState(() {
      if (data["message"].toString() == '1') {
        _stockawal.clear();
        _hargaproduk.clear();
        Navigator.pop(context);
      }
    });
  }



  alertSimpan() {
    if(stock_val == 'true') {
      if(selectedWarehouse == '' || _stockawal.text == '' || selectedStore == "" || _hargaproduk.text == '') {
        showToast("Form tidak boleh kosong ", gravity: Toast.BOTTOM,
            duration: Toast.LENGTH_LONG);
        return false;
      }
    } else {
      if(selectedStore == "" || _hargaproduk.text == '') {
        showToast("Form tidak boleh kosong ", gravity: Toast.BOTTOM,
            duration: Toast.LENGTH_LONG);
        return false;
      }
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
                      color: HexColor("#602d98"),size: 35,)),),
                    Padding(padding: const EdgeInsets.only(top: 15), child:
                    Align(alignment: Alignment.center, child:
                    Text("Apakah anda yakin menyimpan data ini ? ",
                        style: TextStyle(fontFamily: 'VarelaRound', fontSize: 12)),)),
                    Padding(padding: const EdgeInsets.only(top: 25), child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(child: OutlineButton(
                          onPressed: () {Navigator.pop(context);}, child: Text("Tutup"),)),
                        Expanded(child: OutlineButton(
                          borderSide: BorderSide(width: 1.0, color: HexColor("#602d98")),
                          onPressed: () {
                            doSimpan();
                            Navigator.pop(context);
                          }, child: Text("Simpan", style: TextStyle(color: HexColor("#602d98")),),)),
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
              automaticallyImplyLeading: false,
              backgroundColor: HexColor("#602d98"),
              actions: [
                InkWell(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    //Navigator.push(context, ExitPage(page: ProdukInsert2(widget.getEmail, widget.getLegalCode,"322657", "Product" )));
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
              title: Text(
                "Informasi Lainnya",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'VarelaRound',
                    fontSize: 16),
              ),
            ),
            body: Container(
             child : SingleChildScrollView(
               child : Column(
                 children: [
                   Padding(padding: const EdgeInsets.only(left: 15,top: 10,right: 15),
                       child: Column(
                         children: [
                           Align(alignment: Alignment.centerLeft,child: Padding(
                             padding: const EdgeInsets.only(left: 0,top: 15),
                             child: Text("Rilis ke Store",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "VarelaRound",
                                 fontSize: 12,color: HexColor("#0074D9")),),
                           ),),
                           Align(alignment: Alignment.centerLeft,child: Padding(
                             padding: const EdgeInsets.only(top:10),
                             child: DropdownButton(
                               isExpanded: false,
                               hint: Text("Pilih Store", style : GoogleFonts.varelaRound()),
                               value: selectedStore,
                               items: itemList.map((myitem){
                                 return DropdownMenuItem(
                                     value: myitem['a'],
                                     child: Text(myitem['b'], style : GoogleFonts.varelaRound(fontSize: 15))
                                 );
                               },
                               ).toList(),

                               onChanged: (value) {
                                 setState(() {
                                   FocusScope.of(context).requestFocus(FocusNode());
                                   selectedStore = value;
                                 });
                               },
                             ),
                           ))
                         ],
                       )
                   ),

                   Padding(padding: const EdgeInsets.only(left: 15,top: 10,right:15),
                       child: Column(
                         children: [
                           Align(alignment: Alignment.centerLeft,child: Padding(
                             padding: const EdgeInsets.only(left: 0,top: 15),
                             child: Text("Harga Jual",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "VarelaRound",
                                 fontSize: 12,color: HexColor("#0074D9")),),
                           ),),
                           Align(alignment: Alignment.centerLeft,child: Padding(
                             padding: const EdgeInsets.only(left: 0),
                             child: Container(
                               width: 150,
                               child : TextFormField(
                                 textCapitalization: TextCapitalization.sentences,
                                 keyboardType: TextInputType.number,
                                 controller: _hargaproduk,
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
                             )
                           ),),
                         ],
                       )
                   ),

                   widget.getProdukTipe == 'Product' ?
                   Padding(padding: const EdgeInsets.only(left: 15,top: 10,right:15),
                       child: Column(
                         children: [
                           Align(alignment: Alignment.centerLeft,child: Padding(
                             padding: const EdgeInsets.only(left: 0,top: 15),
                             child: Text("Atur Stock Awal",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "VarelaRound",
                                 fontSize: 12,color: HexColor("#0074D9")),),
                           ),),
                           Align(alignment: Alignment.centerLeft,child: Padding(
                               padding: const EdgeInsets.only(left: 0,top: 8),
                               child: Container(
                                 width: 35,
                                 child : Switch(
                                   value: stock_val == "false" ? false : true ,
                                   onChanged: (value) {
                                     setState(() {
                                              show_stock();
                                     });
                                   },
                                   activeTrackColor: HexColor("#bbffce"),
                                   activeColor: Colors.green,
                                 ),
                               )
                           ),),
                         ],
                       )
                   )
                   :
                       Container(),

                   Visibility(
                     visible: _showstock,
                      child : Column(
                        children: [
                          Padding(padding: const EdgeInsets.only(top: 20),
                              child: Container(
                                height: 8,
                                width: double.infinity,
                                color: HexColor("#f0f3f8"),
                              )),

                          Padding(padding: const EdgeInsets.only(top: 30,left: 15),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child : Text(
                                      "Stock Awal", style : GoogleFonts.varelaRound(fontSize: 15,fontWeight: FontWeight.bold)
                                  )
                              )),


                          Padding(padding: const EdgeInsets.only(left: 15,top: 10,right: 15),
                              child: Column(
                                children: [
                                  Align(alignment: Alignment.centerLeft,child: Padding(
                                    padding: const EdgeInsets.only(left: 0,top: 15),
                                    child: Text("Warehouse",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "VarelaRound",
                                        fontSize: 12,color: HexColor("#0074D9")),),
                                  ),),
                                  Align(alignment: Alignment.centerLeft,child: Padding(
                                    padding: const EdgeInsets.only(top:10),
                                    child: DropdownButton(
                                      isExpanded: false,
                                      hint: Text("Pilih Warehouse", style : GoogleFonts.varelaRound()),
                                      value: selectedWarehouse,
                                      items: itemList2.map((myitem2){
                                        return DropdownMenuItem(
                                            value: myitem2['a'],
                                            child: Text(myitem2['b'], style : GoogleFonts.varelaRound(fontSize: 15))
                                        );
                                      },
                                      ).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          FocusScope.of(context).requestFocus(FocusNode());
                                          selectedWarehouse = value;
                                        });
                                      },
                                    ),
                                  ))
                                ],
                              )
                          ),


                          Padding(padding: const EdgeInsets.only(left: 15,top: 10,right:15),
                              child: Column(
                                children: [
                                  Align(alignment: Alignment.centerLeft,child: Padding(
                                    padding: const EdgeInsets.only(left: 0,top: 15),
                                    child: Text("Stock Awal",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "VarelaRound",
                                        fontSize: 12,color: HexColor("#0074D9")),),
                                  ),),
                                  Align(alignment: Alignment.centerLeft,child: Padding(
                                      padding: const EdgeInsets.only(left: 0),
                                      child: Container(
                                        width: 100,
                                        child : TextFormField(
                                          textCapitalization: TextCapitalization.sentences,
                                          keyboardType: TextInputType.number,
                                          controller: _stockawal,
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
                                      )
                                  ),),
                                ],
                              )
                          ),


                        ],
                      )
                   ),

                 ],
               )
             )
            ),
            bottomNavigationBar: Container(
              padding : const EdgeInsets.only(bottom: 20),
              height: 50,
              width : double.infinity,
              child : Align(
                alignment: Alignment.bottomCenter,
                child: InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child : Text("Lewati  >> ", style : TextStyle(fontSize: 18, color: Colors.blueAccent))
                )
              ),
            )
          ),
          onWillPop: _onWillPop
      );
  }

}