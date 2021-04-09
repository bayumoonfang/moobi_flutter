


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
  List data2;
  List data3;
  List dataSubTotal;
  List dataServCharge;
  List dataPPN;
  bool _isvisible = true;
  bool isSemua = true;
  bool isTerjual = false;
  bool isDiskon = false;
  bool isTerlaris = false;
  bool isTermurah = false;
  bool isTermahal = false;
  bool isArrowDown = true;
  bool isArrowUp = false;
  bool isContentDetail = false;
  TextEditingController _transcomment = TextEditingController();
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



  String valServCharge = '0';
  _getServCharge() async {
    final response = await http.get(
        applink+"api_model.php?act=getdata_servcharge&branch="+getBranchVal+"&operator="+getNamaUser);
    Map data = jsonDecode(response.body);
    setState(() {
      valServCharge = data["a"].toString();
    });
  }


  String valSubTotal = '0';
  _getSubTotal() async {
    final response = await http.get(
        applink+"api_model.php?act=getdata_subtotal&branch="+getBranchVal+"&operator="+getNamaUser);
    Map data = jsonDecode(response.body);
    setState(() {
      valSubTotal = data["a"].toString();
    });
  }


  Future<List> _getTax() async {
    http.Response response = await http.get(
        Uri.encodeFull(applink+"api_model.php?act=getdata_tax&branch="+getBranchVal+"&operator="+getNamaUser),
        headers: {"Accept":"application/json"}
    );
    setState((){
      data3 = json.decode(response.body);
    });
  }


  int valJumlahq = 0;
  void _kurangqty() {
    setState(() {
      valJumlahq -= 1;
    });
  }

  void _tambahqty() {
    setState(() {
      valJumlahq += 1;
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


  Future<List> getDataTotal() async {
    http.Response response = await http.get(
        Uri.encodeFull(applink+"api_model.php?act=getdata_charttotal&branch="+getBranchVal+"&operator="+getNamaUser),
        headers: {"Accept":"application/json"}
    );
    setState((){
      data2 = json.decode(response.body);
    });
  }


  Future<List> getDataSubTotal() async {
    http.Response response = await http.get(
        Uri.encodeFull(applink+"api_model.php?act=getdata_subtotal2&branch="+getBranchVal+"&operator="+getNamaUser),
        headers: {"Accept":"application/json"}
    );
    setState((){
      dataSubTotal = json.decode(response.body);
    });
  }


  Future<List> getDataServchargeTotal() async {
    http.Response response = await http.get(
        Uri.encodeFull(applink+"api_model.php?act=getdata_servchargetotal&branch="+getBranchVal+"&operator="+getNamaUser),
        headers: {"Accept":"application/json"}
    );
    setState((){
      dataServCharge = json.decode(response.body);
    });
  }


  Future<List> getDataPPNTotal() async {
    http.Response response = await http.get(
        Uri.encodeFull(applink+"api_model.php?act=getdata_ppntotal&branch="+getBranchVal+"&operator="+getNamaUser),
        headers: {"Accept":"application/json"}
    );
    setState((){
      dataPPN = json.decode(response.body);
    });
  }


  _prepare() async {
    await _connect();
    await _session();
    await _getBranch();
    await _getServCharge();
    await _getSubTotal();
    //await _getTotal();
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


  doEditOrder(String idOrder) async {
    final response = await http.post(applink+"api_model.php?act=edit_orderpending", body: {
      "order_id": idOrder,
      "order_comment" : _transcomment.text,
      "order_qty" : valJumlahq.toString()
    });
    Map data = jsonDecode(response.body);
    setState(() {
    if (data["message"].toString() == '0') {
        showToast("Mohon maaf stock habis", gravity: Toast.BOTTOM,
            duration: Toast.LENGTH_LONG);
        return false;
      } else if (data["message"].toString() == '2') {
        showToast("Mohon maaf stock tidak mencukupi", gravity: Toast.BOTTOM,
            duration: Toast.LENGTH_LONG);
        return false;
      }

    });
  }



  TambahBiayaAdd() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                //title: Text(),
                content: ResponsiveContainer(
                    widthPercent: 100,
                    heightPercent: 29,
                    child: Column(
                      children: [
                        Padding(padding: const EdgeInsets.only(top: 8), child:
                        Align(alignment: Alignment.center, child: Text("Tambah Biaya",
                            style: TextStyle(fontFamily: 'VarelaRound', fontSize: 16, fontWeight: FontWeight.bold))
                        ),),
                        Padding(padding: const EdgeInsets.only(top: 15), child:
                        Align(alignment: Alignment.center, child:
                        TextFormField(
                          controller: _transcomment,
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
                            hintText: 'Nama Biaya. Contoh : Ongkir, dll',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintStyle: TextStyle(fontFamily: "VarelaRound", color: HexColor("#c4c4c4")),
                          ),
                        ),
                        )),
                        Padding(padding: const EdgeInsets.only(top: 15), child:
                        Align(alignment: Alignment.center, child:
                        TextFormField(
                          controller: _transcomment,
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
                            hintText: 'Biaya. Contoh : 12000, 15000',
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
                                Navigator.pop(context);
                              }, child: Text("Keluar"),)),
                            Expanded(child: OutlineButton(
                              borderSide: BorderSide(width: 1.0, color: Colors.redAccent),
                              onPressed: () {
                                FocusScope.of(context).requestFocus(FocusNode());

                                Navigator.pop(context);
                              }, child: Text("Tambah", style: TextStyle(color: Colors.red),),)),
                          ],),)
                      ],
                    )
                ),
              );
            },
          );
        });


  }





  dialogAdd(String valID, String valNama, int valQty) {
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
                    heightPercent: 34,
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
                                    _kurangqty();
                                    valJumlahq2 -= 1;
                                  });
                                },),
                              Text("$valJumlahq2",style: TextStyle(fontSize: 52,fontWeight: FontWeight.bold),),
                              FlatButton(child: Text("+",style: TextStyle(fontSize: 46,fontWeight: FontWeight.bold),),
                                onPressed: (){
                                  setState(() {
                                    _tambahqty();
                                    valJumlahq2 += 1;
                                  });
                                },),
                            ],
                          ),),
                        Padding(padding: const EdgeInsets.only(top: 15), child:
                        Align(alignment: Alignment.center, child:
                        TextFormField(
                          controller: _transcomment,
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
                                FocusScope.of(context).requestFocus(FocusNode());
                                doEditOrder(valID);
                                Navigator.pop(context);
                              }, child: Text("Edit Order", style: TextStyle(color: Colors.red),),)),
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
            title: Container(
              padding: const EdgeInsets.only(top: 2),
              height: 78,
              width: 100,
              child: FutureBuilder(
                future: getDataTotal(),
                builder: (context, snapshot) {
                  return ListView.builder(
                    itemCount: (data2 == null ? 0 : data2.length),
                    itemBuilder: (context, i) {
                      return Opacity(
                          child:
                          data2[i]['a'] == null ?
                              Text("0")
                          :

                          Text( "Rp. "+
                              NumberFormat.currency(
                                  locale: 'id', decimalDigits: 0, symbol: '').format(
                                  int.parse(data2[i]['a'].toString())),
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          opacity:0.7 ,
                        );
                    },
                  );
                },
              )
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
                                  TambahBiayaAdd();
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
       SingleChildScrollView(
         child: Container(child: _dataField(),
             height: MediaQuery.of(context).copyWith().size.height /2.8),
       )
                ),
                Padding(padding: const EdgeInsets.only(left:15,top: 5,right: 18 ),
                  child: Divider(height: 5,),
                ),
                Visibility(visible: isArrowDown, child: InkWell(
                  onTap: (){
                    setState(() {
                      isArrowDown = false;
                      isArrowUp = true;
                      isContentDetail = true;
                    });
                  },
                    child: Container(
                      width: double.infinity,
                      height: 60,
                      child: Center(
                        child: IconButton(
                          tooltip: "Show all",
                          icon: FaIcon(FontAwesomeIcons.arrowCircleDown,size: 30,),
                        ),
                      ),
                    )
                ),),
                Visibility(visible: isArrowUp, child:
                InkWell(
                    onTap: (){
                      setState(() {
                        isArrowDown = true;
                        isArrowUp = false;
                        isContentDetail = false;
                      });
                    },
                  child :
                Container(
                  width: double.infinity,
                  height: 60,
                  child: Center(
                    child: IconButton(
                      tooltip: "Hide All",
                      icon: FaIcon(FontAwesomeIcons.arrowAltCircleUp,size: 30,),
                    ),
                  ),
                ))),
              Visibility(visible: isContentDetail,
                  child: Padding(padding: const EdgeInsets.only(left:15,top: 15, right: 13 ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceBetween,
                    children: [
                      Text("Sub Total :",style: TextStyle(fontSize: 13,
                          fontFamily: 'VarelaRound',
                          color: Colors.black)),
                          Container(
                            height: 13,
                            width: 150,
                            alignment: Alignment.centerRight,
                            child: FutureBuilder(
                              future: getDataSubTotal(),
                              builder: (context, snapshot) {
                                return ListView.builder(
                                  itemCount: dataSubTotal == null ? 0 : dataSubTotal.length,
                                  itemBuilder: (context, i) {
                                      return Align(
                                        alignment: Alignment.centerRight,
                                        child: Text("Rp. "+
                                            NumberFormat.currency(
                                                locale: 'id', decimalDigits: 0, symbol: '').format(
                                                int.parse(dataSubTotal[i]["a"].toString())),style: TextStyle(fontSize: 13,
                                            fontWeight: FontWeight.bold,fontFamily: 'VarelaRound',
                                            color: Colors.black)),
                                      );
                                  },
                                );
                              },
                            ),
                          )
                    ],
                  ),
                  Padding(padding: const EdgeInsets.only(top: 10),
                      child : Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceBetween,
                        children: [
                          Text("Service Charge :",style: TextStyle(fontSize: 13,
                              fontFamily: 'VarelaRound',
                              color: Colors.black)),
                          Container(
                            height: 13,
                            width: 150,
                            alignment: Alignment.centerRight,
                            child: FutureBuilder(
                              future: getDataServchargeTotal(),
                              builder: (context, snapshot) {
                                return ListView.builder(
                                  itemCount: dataServCharge == null ? 0 : dataServCharge.length,
                                  itemBuilder: (context, i) {
                                    return Align(
                                      alignment: Alignment.centerRight,
                                      child: Text("Rp. "+
                                          NumberFormat.currency(
                                              locale: 'id', decimalDigits: 0, symbol: '').format(
                                              int.parse(dataServCharge[i]["a"].toString())),style: TextStyle(fontSize: 13,
                                          fontWeight: FontWeight.bold,fontFamily: 'VarelaRound',
                                          color: Colors.black)),
                                    );
                                  },
                                );
                              },
                            ),
                          )
                        ],
                      )),
                  Padding(padding: const EdgeInsets.only(top: 10),
                      child : Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceBetween,
                        children: [
                          Text("PPN (Tax)  :",style: TextStyle(fontSize: 13,
                              fontFamily: 'VarelaRound',
                              color: Colors.black)),
                          Container(
                            height: 13,
                            width: 150,
                            alignment: Alignment.centerRight,
                            child: FutureBuilder(
                              future: getDataPPNTotal(),
                              builder: (context, snapshot) {
                                return ListView.builder(
                                  itemCount: dataPPN == null ? 0 : dataPPN.length,
                                  itemBuilder: (context, i) {
                                    return Align(
                                      alignment: Alignment.centerRight,
                                      child: Text("Rp. "+
                                          NumberFormat.currency(
                                              locale: 'id', decimalDigits: 0, symbol: '').format(
                                              int.parse(dataPPN[i]["a"].toString())),style: TextStyle(fontSize: 13,
                                          fontWeight: FontWeight.bold,fontFamily: 'VarelaRound',
                                          color: Colors.black)),
                                    );
                                  },
                                );
                              },
                            ),
                          )
                        ],
                      ))
                ],
              )
          ))
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
                      if (data[i]["n"].toString() == "null") {
                        _transcomment.text = "";
                      } else {
                        _transcomment.text = data[i]["n"].toString();
                      }
                      valJumlahq = data[i]["j"];
                      dialogAdd(data[i]["m"].toString(), data[i]["a"], data[i]["j"]);
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
                      title: data[i]["n"] != "" ?
                        Column(
                          children: [
                            Align(alignment: Alignment.centerLeft,
                              child: Text(data[i]["a"],
                                  style: TextStyle(fontFamily: "VarelaRound",
                                      fontSize: 13,fontWeight: FontWeight.bold)),),
                      Padding(padding: const EdgeInsets.only(top: 5,bottom: 5),child:
                      Align(alignment: Alignment.centerLeft,
                        child: Text(":: "+data[i]["n"],
                            style: TextStyle(fontFamily: "VarelaRound",
                                fontSize: 12,)),),)
                          ],
                        )
                        :
                        Align(alignment: Alignment.centerLeft,
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