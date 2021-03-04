


import 'dart:async';
import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:moobi_flutter/Helper/check_connection.dart';
import 'package:moobi_flutter/Helper/page_route.dart';
import 'package:moobi_flutter/Helper/session.dart';
import 'package:moobi_flutter/page_login.dart';
import 'package:responsive_container/responsive_container.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:moobi_flutter/helper/api_link.dart';

class Checkout extends StatefulWidget{
  @override
  CheckoutState createState() => CheckoutState();
}

class CheckoutState extends State<Checkout> {
  List data;
  bool _isvisible = true;
  bool isSemua = true;
  bool isTerjual = false;
  bool isDiskon = false;
  bool isTerlaris = false;
  bool isTermurah = false;
  bool isTermahal = false;
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
      if (internet != null && internet) {
        // Internet Present Case
      } else {
        showToast("Koneksi terputus..", gravity: Toast.CENTER,
            duration: Toast.LENGTH_LONG);
      }
    });
  }

  String getBranchVal = '';
  String getNamaUser = '';
  _getBranch() async {
    final response = await http.get(
        applink+"api_model.php?act=userdetail&id="+getEmail.toString());
    Map data = jsonDecode(response.body);
    setState(() {
      getBranchVal = data["c"].toString();
      getNamaUser = data["j"].toString();
    });
  }


  String valgetTotal = '0';
  _getTotal() async {
    final response = await http.get(
        applink+"api_model.php?act=getdata_charttotal&branch="+getBranchVal+"&operator="+getNamaUser);
    Map data = jsonDecode(response.body);
    setState(() {
      valgetTotal = data["a"].toString();
    });
  }



  @override
  void initState() {
    super.initState();
    _prepare();
  }


  String filter = "Semua";
  String filterq = "";
  String sortby = '0';
  Future<List> getData() async {
    http.Response response = await http.get(
        Uri.encodeFull(applink+"api_model.php?act=getdata_produkcheckout&branch="+getBranchVal+"&operator="+getNamaUser),
        headers: {"Accept":"application/json"}
    );
    setState((){
      data = json.decode(response.body);
    });
  }

  _prepare() async {
    await _connect();
    await _session();
    await _getBranch();
    await _getTotal();
  }

  startSCreen() async {
    var duration = const Duration(seconds: 1);
    return Timer(duration, () {
      setState(() {
        _isvisible = true;
      });
    });
  }

  doHapus(String idOrder) {
      http.post(applink+"api_model.php?act=hapus_orderpending", body: {
        "order_id": idOrder
      });
    Navigator.pop(context);
  }


  dialogAdd(String valID, String valNama, String valComment, int valQty) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          int valJumlahq2 = valQty;
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                //title: Text(),
                content: ResponsiveContainer(
                    widthPercent: 100,
                    heightPercent: 32,
                    child: Column(
                      children: [
                        Padding(padding: const EdgeInsets.only(top: 8), child:
                        Align(alignment: Alignment.center, child: Text(valNama,
                            style: TextStyle(fontFamily: 'VarelaRound', fontSize: 16, fontWeight: FontWeight.bold))
                        ),),
                        Padding(padding: const EdgeInsets.only(top: 25,bottom: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FlatButton(child: Text("-",style: TextStyle(fontSize: 48,fontWeight: FontWeight.bold),),
                                onPressed: (){
                                  setState(() {
                                   // _kurangqty();
                                    valJumlahq2 -= 1;
                                  });
                                },),
                              Text("$valJumlahq2",style: TextStyle(fontSize: 52,fontWeight: FontWeight.bold),),
                              FlatButton(child: Text("+",style: TextStyle(fontSize: 46,fontWeight: FontWeight.bold),),
                                onPressed: (){
                                  setState(() {
                                   // _tambahqty();
                                    valJumlahq2 += 1;
                                  });
                                },),
                            ],
                          ),),


                        Padding(padding: const EdgeInsets.only(top: 15), child:
                        Align(alignment: Alignment.center, child:
                        TextFormField(
                         // controller: _transcomment,
                          style: TextStyle(fontFamily: "VarelaRound",fontSize: 15),
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: new InputDecoration(
                            contentPadding: const EdgeInsets.only(top: 1,left: 10,bottom: 1),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: HexColor("#DDDDDD"), width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: HexColor("#DDDDDD"), width: 1.0),
                            ),
                            hintText: 'Note. Contoh : Pedas, Tidak Pedas',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintStyle: TextStyle(fontFamily: "VarelaRound", color: HexColor("#c4c4c4")),
                          ),
                        ),
                        )),
                        Padding(padding: const EdgeInsets.only(top: 20), child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Expanded(child: OutlineButton(
                              onPressed: () {
                                doHapus(valID);
                              }, child: Text("Hapus"),)),
                            Expanded(child: OutlineButton(
                              borderSide: BorderSide(width: 1.0, color: Colors.redAccent),
                              onPressed: () {
                                //addKeranjang2(valID);
                              }, child: Text("Add to Chart", style: TextStyle(color: Colors.red),),)),
                          ],),)
                      ],
                    )
                ),
              );
            },
          );
        });


  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
          appBar: new AppBar(
            centerTitle: true,
            elevation: 0.5,
            backgroundColor: Colors.white,
            title:Opacity(
              child: Text( "Rp. "+
                  NumberFormat.currency(
                      locale: 'id', decimalDigits: 0, symbol: '').format(
                      int.parse(valgetTotal)),
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              opacity:0.7 ,
            ),
            leading: Container(
              padding: const EdgeInsets.only(left: 7),
              child: Builder(
                builder: (context) => IconButton(
                    icon: new Icon(Icons.arrow_back),
                    color: Colors.black,
                    iconSize: 25,
                    onPressed: () => {
                      Navigator.pop(context)
                    }),
              ),
            ),
            actions: [
    Container(
      height: double.infinity,
      width: 60,
      color: HexColor("#602d98"),
      child: Align(
        alignment: Alignment.center,
        child: InkWell(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
            //_showAlert();
          },
          child: Padding(
            padding: const EdgeInsets.only(top : 5),
            child: FaIcon(
              FontAwesomeIcons.check,color: Colors.white,
            ),
          ),
        ),
      )
    )
            ],
          ),
          body: Container(
            color: Colors.white,
            child: Column(
              children: [
                Container(
                    height: 50,
                    width: double.infinity,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Padding(padding: const EdgeInsets.only(left: 10),
                            child: Container(
                              height: 30,
                              child: FlatButton(
                                child: Text("Tambah Biaya",style: TextStyle(fontSize: 13,
                                    fontWeight: FontWeight.bold,fontFamily: 'VarelaRound',
                                    color: Colors.black
                                ),),
                                //color: isSemua == true ? HexColor("#602d98") : Colors.white ,
                                onPressed: (){

                                },
                              ),
                            ),),
                        ],
                      ),
                    )
                ),
                Padding(padding: const EdgeInsets.only(left: 15,right: 15),
                  child: Divider(height: 4,),),
                Padding(padding: const EdgeInsets.only(top: 10),),
                Visibility(
                    visible: _isvisible,
                    child :
                    Expanded(child: _dataField())
                )
                //
              ],
            ),
          )
      ),
    );

  }



  Widget _dataField() {
    return FutureBuilder(
      future : getData(),
      builder: (context, snapshot) {
        if (data == null) {
          return Center(
              child: Image.asset(
                "assets/loadingq.gif",
                width: 110.0,
              )
          );
        } else {
          return data == 0 ?
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
                        "Data tidak ditemukan",
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
            itemCount: data == null ? 0 : data.length,
            padding: const EdgeInsets.only(top: 2,bottom: 80),
            itemBuilder: (context, i) {
              return Column(
                children: <Widget>[
                  InkWell(
                    onTap: (){
                      dialogAdd(data[i]["m"].toString(), data[i]["a"], data[i]["n"], data[i]["j"]);
                    },
                    child: ListTile(
                      leading:
                      SizedBox(
                          width: 50,
                          height: 50,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6.0),
                            child : CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl:
                              data[i]["d"] == '' ?
                              applink+"photo/nomage.jpg"
                                  :
                              applink+"photo/"+getBranchVal+"/"+data[i]["d"],
                              progressIndicatorBuilder: (context, url, downloadProgress) =>
                                  CircularProgressIndicator(value: downloadProgress.progress),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            ),
                          )),
                      title: Align(alignment: Alignment.centerLeft,
                        child: Text(data[i]["a"],
                            style: TextStyle(fontFamily: "VarelaRound",
                                fontSize: 13,fontWeight: FontWeight.bold)),),
                      subtitle: Align(alignment: Alignment.centerLeft,
                          child:
                          Text(data[i]["j"].toString() + " x"+" Rp. "+
                              NumberFormat.currency(
                                  locale: 'id', decimalDigits: 0, symbol: '').format(
                                  data[i]["k"])+" = "+NumberFormat.currency(
                              locale: 'id', decimalDigits: 0, symbol: '').format(
                              data[i]["l"]), style: new TextStyle(
                              fontFamily: 'VarelaRound',fontSize: 12),)
                      ),
                      trailing: Container(
                        height: 20,
                        width : 55,
                        child: OutlineButton(
                          child: Text(data[i]["j"].toString(),style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14
                          ),textAlign: TextAlign.center,),
                        onPressed: (){},
                          borderSide: BorderSide(
                            color: Colors.black, //Color of the border
                            style: BorderStyle.solid, //Style of the border
                            width: 0.4, //width of the border
                          ),),
                      )
                    ),
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }


}