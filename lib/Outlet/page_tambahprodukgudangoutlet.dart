


import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:moobi_flutter/Helper/api_link.dart';
import 'package:http/http.dart' as http;
import 'package:moobi_flutter/Helper/app_helper.dart';
import 'package:moobi_flutter/Helper/color_based.dart';
import 'package:moobi_flutter/Helper/page_route.dart';
import 'package:toast/toast.dart';

import '../page_intoduction.dart';
import '../page_login.dart';



class TambahProdukGudangOutlet extends StatefulWidget {
  final String kodeGudang;
  final String getEmail;
  final String getLegalCode;
  final String getNamaUser;
  final String getIdOutlet;
  const TambahProdukGudangOutlet(this.kodeGudang, this.getEmail, this.getLegalCode, this.getNamaUser, this.getIdOutlet);
  @override
  _TambahProdukGudangOutlet createState() => _TambahProdukGudangOutlet();
}


class _TambahProdukGudangOutlet extends State<TambahProdukGudangOutlet> {

  List data;
  bool _isvisible = true;



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

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);}


  _prepare() async {
    await _startingVariable();
  }

  @override
  void initState() {
    super.initState();
    _prepare();
  }


  showFlushBarsuccess(BuildContext context, String stringme) => Flushbar(
    // title:  "Hey Ninja",
    message:  stringme,
    shouldIconPulse: false,
    duration:  Duration(seconds: 5),
    backgroundColor: Colors.black,
    flushbarPosition: FlushbarPosition.BOTTOM ,
  )..show(context);

  void showsuccess(String txtError){
    showFlushBarsuccess(context, txtError);
    return;
  }

  Future<bool> _onWillPop() async {
    Navigator.pop(context);}
  final addJumlahawal = TextEditingController();

  String filter = "";
  String sortme = "0";
  Future<List> getData() async {
    http.Response response = await http.get(
        Uri.encodeFull(applink+"api_model.php?act=getdata_produkadd_gudang&"
            "filter="+filter+
            "&store_id="+widget.getIdOutlet+
            "&id="+widget.getLegalCode),
        headers: {"Accept":"application/json"});

    return json.decode(response.body);
  }

  startSCreen() async {
    var duration = const Duration(seconds: 1);
    return Timer(duration, () {
      setState(() {
        _isvisible = true;
      });
    });
  }

  showFlushBar(BuildContext context, String stringme) => Flushbar(
    // title:  "Hey Ninja",
    message:  stringme,
    shouldIconPulse: false,
    duration:  Duration(seconds: 5),
    backgroundColor: Colors.red,
    flushbarPosition: FlushbarPosition.BOTTOM ,
  )..show(context);

  void showerror(String txtError){
    showFlushBar(context, txtError);
    return;
  }





  _doAddStockAwal (String valueParse2) async {
    Navigator.pop(context);
    if (addJumlahawal.text == "") {
      showerror("Keterangan atau Jumlah tidak boleh kosong");
    }
    final response = await http.post(applink+"api_model.php?act=action_addprodukgudang",
        body: {"id": valueParse2,
          "addJumlahawal" : addJumlahawal.text,
          "kodeGudang" : widget.kodeGudang,
          "branch" : widget.getLegalCode,
        "namaUser" : widget.getNamaUser,
        "storeId" : widget.getIdOutlet},
        headers: {"Accept":"application/json"});
    Map data = jsonDecode(response.body);
    setState(() {
      if (data["message"].toString() == '1') {
        showsuccess("Produk berhasil ditambahkan ke gudang "+widget.kodeGudang+"");
      } else {
        //showerror("Product sudah ada di outlet ini, silahkan cari produk yang lain");
      }
    });

  }


  _doAddStockAwal2 () async {
    Navigator.pop(context);
    if (addJumlahawal.text == "") {
      showerror("Keterangan atau Jumlah tidak boleh kosong");
    }
    final response = await http.post(applink+"api_model.php?act=action_addprodukgudang",
        body: {"id": "",
          "addJumlahawal" : addJumlahawal.text,
          "kodeGudang" : widget.kodeGudang,
          "branch" : widget.getLegalCode,
          "namaUser" : widget.getNamaUser,
          "storeId" : widget.getIdOutlet},
        headers: {"Accept":"application/json"});
    Map data = jsonDecode(response.body);
    setState(() {
      if (data["message"].toString() == '1') {
        showsuccess("Produk berhasil ditambahkan ke gudang "+widget.kodeGudang+"");
      } else {
        //showerror("Product sudah ada di outlet ini, silahkan cari produk yang lain");
      }
    });
  }



  _cekProduk (String valueParse2) async {
    final response = await http.post(applink+"api_model.php?act=action_cekaddprodukgudang",
        body: {"id": valueParse2, "kodeGudang" : widget.kodeGudang},
        headers: {"Accept":"application/json"});
    Map data = jsonDecode(response.body);
    setState(() {
      if (data["message"].toString() == '2') {
        _showadd(valueParse2);
      } else {
        showerror("Produk sudah ada di gudang ini, silahkan cari produk yang lain");
      }
    });
  }





  _showadd(String valueParse) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            //title: Text(),
            content: Container(
                width: double.infinity,
                height: 200,
                child: Column(
                  children: [
                    Align(alignment: Alignment.center, child:
                    Text("Tambah Ke Gudang", style: TextStyle(fontFamily: 'VarelaRound', fontSize: 20,
                        fontWeight: FontWeight.bold)),),
                    Padding(padding: const EdgeInsets.only(top: 15), child:
                    Align(alignment: Alignment.center, child:
                    Text("Menambah produk baru ke gudang "+widget.kodeGudang,
                      style: TextStyle(fontFamily: 'VarelaRound', fontSize: 12),textAlign: TextAlign.center,),)),
                    Padding(padding: const EdgeInsets.only(top: 15), child:
                    Align(alignment: Alignment.center, child:
                    Container(
                      child : TextFormField(
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                            fontFamily: 'VarelaRound', fontSize: 14),
                        controller: addJumlahawal,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left:15,top:5,bottom:5,right: 15),
                          hintText: "Stock Awal",
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                              color: HexColor("#602d98"),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                              color: HexColor("#dbd0ea"),
                              width: 1.0,
                            ),
                          ),

                        ),
                      ),
                    )
                    )),
                    Padding(padding: const EdgeInsets.only(top: 25), child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(child: OutlineButton(
                          onPressed: () {Navigator.pop(context);}, child: Text("Tutup"),)),
                        Expanded(child: RaisedButton(
                          color: HexColor(main_color),
                          onPressed: () {
                            _doAddStockAwal(valueParse);
                          }, child: Text("Post", style: TextStyle(color: Colors.white),),)),
                      ],),)
                  ],
                )
            ),
          );
        });
  }



  _showadd2() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            //title: Text(),
            content: Container(
                width: double.infinity,
                height: 230,
                child: Column(
                  children: [
                    Align(alignment: Alignment.center, child:
                    Text("Tambah Ke Gudang", style: TextStyle(fontFamily: 'VarelaRound', fontSize: 20,
                        fontWeight: FontWeight.bold)),),
                    Padding(padding: const EdgeInsets.only(top: 15), child:
                    Align(alignment: Alignment.center, child:
                    Text("Menambah semua produk baru ke gudang "+widget.kodeGudang+ ", produk yang sudah ada tidak akan dimasukkan",
                      style: TextStyle(fontFamily: 'VarelaRound', fontSize: 12),textAlign: TextAlign.center,),)),
                    Padding(padding: const EdgeInsets.only(top: 15), child:
                    Align(alignment: Alignment.center, child:
                    Container(
                      child : TextFormField(
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                            fontFamily: 'VarelaRound', fontSize: 14),
                        controller: addJumlahawal,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left:15,top:5,bottom:5,right: 15),
                          hintText: "Stock Awal",
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                              color: HexColor("#602d98"),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                              color: HexColor("#dbd0ea"),
                              width: 1.0,
                            ),
                          ),

                        ),
                      ),
                    )
                    )),
                    Padding(padding: const EdgeInsets.only(top: 25), child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(child: OutlineButton(
                          onPressed: () {Navigator.pop(context);}, child: Text("Tutup"),)),
                        Expanded(child: RaisedButton(
                          color: HexColor(main_color),
                          onPressed: () {
                            _doAddStockAwal2();
                          }, child: Text("Post", style: TextStyle(color: Colors.white),),)),
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
          child : Scaffold(
            appBar: new AppBar(
              backgroundColor: HexColor("#602d98"),
              title: Text(
                "Tambah produk ke gudang",
                style: TextStyle(
                    color: Colors.white, fontFamily: 'VarelaRound', fontSize: 16),
              ),
              leading: Builder(
                builder: (context) => IconButton(
                    icon: new FaIcon(FontAwesomeIcons.times,size: 20,),
                    color: Colors.white,
                    onPressed: () => {
                      Navigator.pop(context)
                    }),
              ),
              actions: [
                InkWell(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    _showadd2();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 27,top : 14),
                    child: FaIcon(
                        FontAwesomeIcons.plusSquare
                    ),
                  ),
                )
              ],
            ),
            body : Container(
              child: Column(
                children: [
                  Padding(padding: const EdgeInsets.only(left: 15,top: 10,
                      right: 15),
                      child: Container(
                        height: 45,
                        child: TextFormField(
                          enableInteractiveSelection: false,
                          onChanged: (text) {
                            setState(() {
                              filter = text;
                              _isvisible = false;
                              startSCreen();
                            });
                          },
                          style: TextStyle(fontFamily: "ProximaNova",fontSize: 15),
                          decoration: new InputDecoration(
                            contentPadding: const EdgeInsets.all(10),
                            fillColor: HexColor("#f4f4f4"),
                            filled: true,
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Icon(Icons.search,size: 18,
                                color: HexColor("#6c767f"),),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white,
                                width: 1.0,),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: HexColor("#f4f4f4"),
                                  width: 1.0),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            hintText: 'Cari Produk...',
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
                            return snapshot.data == 0 || snapshot.data.length == 0 ?
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
                              padding: const EdgeInsets.only(top: 2,bottom: 80,left: 5,right: 5),
                              itemBuilder: (context, i) {
                                return Column(
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          FocusScope.of(context).requestFocus(FocusNode());
                                          showModalBottomSheet(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(15),
                                                  topRight: Radius.circular(15),
                                                ),
                                              ),
                                              context: context,
                                              builder: (context) {
                                                return Padding(
                                                    padding: const EdgeInsets.only(left: 5,right: 15,top: 15),
                                                    child :  Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: <Widget>[
                                                        Padding(padding: const EdgeInsets.only(top: 10,right: 25,left: 15),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment
                                                                .spaceBetween,
                                                            children: [
                                                              Text("Category", style: GoogleFonts.varelaRound(
                                                                  fontSize: 14, fontWeight: FontWeight.bold)
                                                              ),
                                                              Text(snapshot.data[i]["b"], style: GoogleFonts.varelaRound(
                                                                  fontSize: 14),textAlign: TextAlign.right,)
                                                            ],
                                                          ),),
                                                        Padding(padding: const EdgeInsets.only(top: 10,right: 15,left: 15),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment
                                                                .spaceBetween,
                                                            children: [
                                                              Text("Date Created", style: GoogleFonts.varelaRound(
                                                                  fontSize: 14, fontWeight: FontWeight.bold)
                                                              ),
                                                              Text(snapshot.data[i]["j"], style: GoogleFonts.varelaRound(
                                                                  fontSize: 14),textAlign: TextAlign.right,)
                                                            ],
                                                          ),),

                                                        Padding(
                                                            padding: const EdgeInsets.only(left: 15,right: 15,top: 10, bottom: 10),
                                                            child : Divider(height:5)
                                                        ),


                                                      ],
                                                    )
                                                );
                                              });
                                        },
                                        child : ListTile(
                                          leading: SizedBox(
                                              width: 45,
                                              height: 45,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(6.0),
                                                child : CachedNetworkImage(
                                                  fit: BoxFit.cover,
                                                  imageUrl:
                                                  snapshot.data[i]["d"] == '' ?
                                                  applink+"photo/nomage.jpg"
                                                      :
                                                  applink+"photo/"+widget.getLegalCode+"/"+snapshot.data[i]["d"],
                                                  progressIndicatorBuilder: (context, url,
                                                      downloadProgress) =>
                                                      CircularProgressIndicator(value:
                                                      downloadProgress.progress),
                                                  errorWidget: (context, url, error) =>
                                                      Icon(Icons.error),
                                                ),
                                              )),
                                          title: Align(alignment: Alignment.centerLeft,
                                            child: Opacity(
                                                opacity: 0.8,
                                                child : Text("#"+snapshot.data[i]["g"],
                                                    style: GoogleFonts.varelaRound(fontSize: 12))
                                            ),
                                          ),
                                          subtitle: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Column(
                                              children: [
                                                Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Padding(padding: const EdgeInsets.only(top:2), child :
                                                  Text(snapshot.data[i]["a"].toString(),
                                                      style: GoogleFonts.varelaRound(fontSize: 14,fontWeight: FontWeight.bold,
                                                          color: Colors.black))),
                                                ),
                                                Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Padding(padding: const EdgeInsets.only(top:2), child :
                                               Row(
                                                 children: [

                                                   Padding(
                                                     padding : const EdgeInsets.only(left: 0),
                                                     child : Container(
                                                       decoration: BoxDecoration(
                                                         borderRadius: BorderRadius.circular(6),
                                                         color: HexColor(color_9),
                                                       ),
                                                       child: Padding(padding : const EdgeInsets.only(left: 5,right: 5,top: 2,bottom: 1),
                                                         child: Text(snapshot.data[i]["b"],
                                                             style: TextStyle(fontFamily: "VarelaRound",
                                                                 color: Colors.white,
                                                                 fontSize: 11)),),
                                                     ),
                                                   )
                                                 ],
                                               )
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          trailing: InkWell(
                                            child: Padding(
                                              padding: const EdgeInsets.only(right: 10),
                                              child: FaIcon(FontAwesomeIcons.plus,size: 20,color: Colors.green,),
                                            ),
                                            onTap: (){
                                              FocusScope.of(context).requestFocus(FocusNode());
                                              _cekProduk(snapshot.data[i]["g"].toString());
                                            },
                                          ),
                                        )
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height: 8,
                                      child :Divider(
                                        height: 5,
                                      ),
                                      padding: const EdgeInsets.only(left:15,right:15),
                                    )
                                  ],
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