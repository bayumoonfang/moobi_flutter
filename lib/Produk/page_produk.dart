

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:moobi_flutter/Helper/app_helper.dart';
import 'package:moobi_flutter/Helper/page_route.dart';
import 'package:moobi_flutter/Produk/page_produkdetail.dart';
import 'package:moobi_flutter/Produk/page_produkhome.dart';
import 'package:moobi_flutter/Produk/page_produkinsert.dart';
import 'package:moobi_flutter/helper/api_link.dart';
import 'package:moobi_flutter/helper/check_connection.dart';
import 'package:moobi_flutter/helper/session.dart';
import 'package:moobi_flutter/page_home.dart';
import 'package:moobi_flutter/page_login.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:responsive_container/responsive_container.dart';
import 'package:toast/toast.dart';

import '../page_intoduction.dart';


class Produk extends StatefulWidget{
  final String getEmail;
  final String getLegalCode;
  final String getNamaUser;

  const Produk(this.getEmail, this.getLegalCode, this.getNamaUser);
  @override
  _ProdukState createState() => _ProdukState();
}


class _ProdukState extends State<Produk> {
  List data;
  String getFilter = '';
  FocusNode focusNode;

  bool _isVisible = true;

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

  startSCreen() async {
    Timer.periodic(Duration(milliseconds: 600), (timer) {
      setState(() {
        //getDataProduk();
        _isVisible = true;
      });
    });
  }


  String filter = "";
  String filterq = "";
  Future<dynamic> getDataProduk() async {
    http.Response response = await http.get(
        Uri.parse(applink+"api_model.php?act=getdata_produk_all&branch="
            +widget.getLegalCode+""
            "&filter="+filter+"&filterq="+filterq),
        headers: {
          "Accept":"application/json",
          "Content-Type": "application/json"}
    );

    return json.decode(response.body);
  }


  Future<dynamic> getKategori() async {
    http.Response response = await http.get(
        Uri.parse(applink+"api_model.php?act=getdata_kategori&branch="
            +widget.getLegalCode),
        headers: {
          "Accept":"application/json",
          "Content-Type": "application/json"}
    );
    return json.decode(response.body);
  }



  _prepare() async {
      await _startingVariable();
  }

  @override
  void initState() {
    super.initState();
    _prepare();
    //startSCreen ();
  }



  FutureOr onGoBack(dynamic value) {
    setState(() {
      getDataProduk();
    });
  }


  void _filterMe() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content:
            Container(
              height: 160,
              width: double.infinity,
              child:
              FutureBuilder(
                future : getKategori(),
                builder: (context, snapshot) {
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
                                )
                              ],
                            )))
                        :
                  Column(
                       crossAxisAlignment: CrossAxisAlignment.stretch,
                       children: [
                         Container(
                             width: 100,
                             height: 160,
                             child : ListView.builder(
                                 itemCount: snapshot.data == null ? 0 : snapshot.data.length,
                                 itemBuilder: (context, i) {
                                   return SingleChildScrollView(
                                       child : Column(
                                         children: [
                                           Align(
                                             alignment : Alignment.centerLeft,
                                             child : Padding(padding: const EdgeInsets.only(top:15),
                                               child : InkWell(
                                                   onTap: (){
                                                     setState(() {
                                                       filter = snapshot.data[i]["b"].toString();
                                                       Navigator.pop(context);
                                                       _isVisible = false;
                                                       startSCreen();
                                                     });
                                                   },
                                                   child : Row(
                                                     children: [
                                                       FaIcon(FontAwesomeIcons.circle,size: 8,color: Colors.black,),
                                                       Padding(
                                                           padding: const EdgeInsets.only(left : 10),
                                                           child : Text(snapshot.data[i]["b"].toString(),
                                                               style : GoogleFonts.varelaRound(

                                                               ))
                                                       )
                                                     ],
                                                   )
                                               ),
                                             ),
                                           ),
                                           Padding(padding: const EdgeInsets.only(top:15),
                                               child : Divider(height : 5)),

                                         ],
                                       )
                                   );
                                 }
                             )
                         )
                       ],

                   );
                  }
                },

              )
            )
          );
        });
  }

  Future<bool> _onWillPop() async {
    Navigator.pop(context);
  }



  alertHapus(String IDProduk) {
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
                    Align(alignment: Alignment.center, child: FaIcon(FontAwesomeIcons.trash,
                      color: Colors.redAccent,size: 35,)),),
                    Padding(padding: const EdgeInsets.only(top: 15), child:
                    Align(alignment: Alignment.center, child:
                    Text("Apakah anda yakin menghapus data ini ? ",
                        style: TextStyle(fontFamily: 'VarelaRound', fontSize: 12)),)),
                    Padding(padding: const EdgeInsets.only(top: 25), child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(child: OutlineButton(
                          onPressed: () {Navigator.pop(context);}, child: Text("Tidak"),)),
                        Expanded(child: OutlineButton(
                          borderSide: BorderSide(width: 1.0, color: Colors.redAccent),
                          onPressed: () {
                            doHapus(IDProduk);
                          }, child: Text("Hapus", style: TextStyle(color: Colors.red),),)),
                      ],),)
                  ],
                )
            ),
          );
        });
  }


  doHapus(String IDq) {
    http.post(applink+"api_model.php?act=hapus_produkhome", body: {
      "produk_id" : IDq
    });
    Navigator.pop(context);
    showToast("Produk berhasil dihapus", gravity: Toast.BOTTOM,
        duration: Toast.LENGTH_LONG);
    setState(() {
      getDataProduk();
    });
    return false;
  }

  @override
  Widget build(BuildContext context) {
        return WillPopScope(
          onWillPop: _onWillPop,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: HexColor("#602d98"),
                leading: Builder(
                  builder: (context) => IconButton(
                    icon: new Icon(Icons.arrow_back),
                    color: Colors.white,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                title: Text(
                  "Master Data Produk",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'VarelaRound',
                      fontSize: 16),
                ),
                actions: [
                  Padding(padding: const EdgeInsets.only(top:0,right: 18), child:
                  Builder(
                    builder: (context) => IconButton(
                      icon: new FaIcon(FontAwesomeIcons.sortAmountDown,size: 18,),
                      color: Colors.white,
                      onPressed: ()  {
                        FocusScope.of(context).requestFocus(FocusNode());
                        _filterMe();
                      }
                    ),
                  )),

                ],
              ),
              body: RefreshIndicator(
                onRefresh: getDataProduk,
                child: Container(
                  child: Column(
                    children: [
                      Padding(padding: const EdgeInsets.only(left: 15,top: 10,right: 15),
                          child: Container(
                            height: 50,
                            child: TextFormField(
                              enableInteractiveSelection: false,
                              onChanged: (text) {
                                setState(() {
                                  filterq = text;
                                });
                              },
                              style: TextStyle(fontFamily: "VarelaRound",fontSize: 14),
                              decoration: new InputDecoration(
                                contentPadding: const EdgeInsets.all(10),
                                fillColor: HexColor("#f4f4f4"),
                                filled: true,
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Icon(Icons.search,size: 18,color: HexColor("#6c767f"),),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white, width: 1.0,),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: HexColor("#f4f4f4"), width: 1.0),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                hintText: 'Cari Produk...',
                              ),
                            ),
                          )
                      ),
                      Padding(padding: const EdgeInsets.only(top: 10),),
                      filter != '' ?
                      Padding(padding: const EdgeInsets.only(left: 20,top: 2,right: 15, bottom : 15),
                      child :
                            Align(
                              alignment: Alignment.centerLeft,
                              child :  FittedBox(
                                  fit: BoxFit.none,
                                  child :
                                RaisedButton(child :
                                  Row(
                                    children: [
                                      Text(filter.toString(), style: GoogleFonts.varelaRound(fontSize: 13),),
                                      Padding(padding : const EdgeInsets.only(left  :10),
                                      child : FaIcon(FontAwesomeIcons.times,size: 12,))
                                    ],
                                  ),
                                  elevation: 0,
                                  onPressed: (){
                                      setState(() {
                                         filter = "";
                                         _isVisible = false;
                                         startSCreen();
                                      });
                                  },
                              ))
                            )

                      )
                      :Container(),
                      Visibility(
                          visible: _isVisible,
                          child: Expanded(child: _dataField()))//
                    ],
                  )
              )),
              floatingActionButton: Padding(
                padding: const EdgeInsets.only(right : 10),
                child: FloatingActionButton(
                  onPressed: (){

                    FocusScope.of(context).requestFocus(FocusNode());
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProdukInsert(widget.getEmail, widget.getLegalCode, widget.getNamaUser))).then(onGoBack);

                    //Navigator.push(context, ExitPage(page: ProdukInsert()));
                  },
                  child: FaIcon(FontAwesomeIcons.plus),
                ),
              )
              //floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            ),
        );
  }

  Widget _dataField() {
    return FutureBuilder(
      future: getDataProduk(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Center(
              child: CircularProgressIndicator()
          );
        } else {
          return snapshot.data == 0  || snapshot.data.length == 0 ?
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ProdukDetail(widget.getEmail, widget.getLegalCode,snapshot.data[i]["g"].toString(), widget.getNamaUser))).then(onGoBack);
                      },
                      child :
                      snapshot.data[i]['j'] == 'Tidak Aktif' ?
                          Opacity(
                            opacity : 0.4,
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
                                      child: Padding(padding: const EdgeInsets.only(top:1), child :
                                      Text(snapshot.data[i]["a"].toString(),
                                          style: GoogleFonts.varelaRound(fontSize: 13,fontWeight: FontWeight.bold,
                                              color: Colors.black))),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(padding: const EdgeInsets.only(top:1), child :
                                      Row(
                                        children: [
                                          Opacity(
                                            opacity: 0.8,
                                            child :   Text(snapshot.data[i]["b"], style: GoogleFonts.varelaRound(fontSize: 11,color:Colors.black),),
                                          )

                                        ],
                                      )

                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          )
                          :
                      ListTile(
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
                                child: Padding(padding: const EdgeInsets.only(top:1), child :
                                Text(snapshot.data[i]["a"].toString(),
                                    style: GoogleFonts.varelaRound(fontSize: 13,fontWeight: FontWeight.bold,
                                        color: Colors.black))),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(padding: const EdgeInsets.only(top:1), child :
                                Row(
                                  children: [
                                    Opacity(
                                      opacity: 0.8,
                                      child :   Text(snapshot.data[i]["b"], style: GoogleFonts.varelaRound(fontSize: 11,color:Colors.black),),
                                    )

                                  ],
                                )

                                ),
                              )
                            ],
                          ),
                        ),
                      )
                  ),


                  Container(
                    width: double.infinity,
                    height: 16,
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
    );
  }


}