


import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:moobi_flutter/helper/check_connection.dart';
import 'package:moobi_flutter/helper/page_route.dart';
import 'package:moobi_flutter/helper/session.dart';
import 'package:moobi_flutter/page_detailimageproduk.dart';
import 'package:moobi_flutter/page_login.dart';
import 'package:responsive_container/responsive_container.dart';
import 'package:toast/toast.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class DetailProduk extends StatefulWidget {
  final String idItem;

  const DetailProduk(this.idItem);
  @override
  _DetailProdukState createState() => _DetailProdukState();
}


class _DetailProdukState extends State<DetailProduk> {
  bool _isvisible = true ;
  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }


  String getEmail,getUsername = '0';
  _session() async {
    int value = await Session.getValue();
    getEmail = await Session.getEmail();
    getUsername = await Session.getUsername();
    if (value != 1) {
      Navigator.push(context, ExitPage(page: Login()));
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



  String getBranchVal = '0';
  _getBranch() async {
    final response = await http.get(
        "https://duakata-dev.com/moobi/m-moobi/api_model.php?act=userdetail&id="+getUsername);
    Map data = jsonDecode(response.body);
    setState(() {
      getBranchVal = data["c"].toString();
    });
  }


  String getName = '...';
      String getPhoto,getHarga,getDiskonPerc,getDiskonVal,getCategory,g,h = '0';
  _getDetail() async {
    final response = await http.get(
        "https://duakata-dev.com/moobi/m-moobi/api_model.php?act=item_detail&id="+widget.idItem+"&branch="+getBranchVal);
    Map data = jsonDecode(response.body);
    setState(() {
      getName = data["aa"].toString();
      getPhoto = data["bb"].toString();
      getHarga = data["cc"].toString();
      getDiskonPerc = data["dd"].toString();
      getDiskonVal = data["ee"].toString();
      getCategory = data["ff"].toString();
    });
  }


  String getStokVal = '0';
  _getStok() async {
    final response = await http.get(
        "https://duakata-dev.com/moobi/m-moobi/api_model.php?act=getdata_stokitem&id="+widget.idItem+"&branch="+getBranchVal);
    Map data2 = jsonDecode(response.body);
    setState(() {
      getStokVal = data2["aa"].toString();
    });
  }


  _prepare() async {
    await _connect();
    await _session();
    await _getBranch();
    await _getDetail();
    await _getStok();
    _isvisible = false;
  }


  @override
  void initState() {
    super.initState();
    _prepare();
  }




  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.white,
          leading: Builder(
            builder: (context) => IconButton(
                icon: new Icon(Icons.arrow_back,size: 20,),
                color: Colors.black,
                onPressed: () => {
                  Navigator.pop(context)
                }),
          ),
          actions: [
                 Padding(padding: const EdgeInsets.only(top: 20,right: 25),child:
                 InkWell(
                   child: FaIcon(FontAwesomeIcons.pencilAlt,color: Colors.black,size: 18,),
                 ),),
            Padding(padding: const EdgeInsets.only(top: 20,right: 20),child:
            InkWell(
              child: FaIcon(FontAwesomeIcons.percent,color: Colors.black,size: 18,),
            ),)

          ],
          title: Text(
            getName.toString(),
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'VarelaRound',
                fontSize: 16),
          ),
        ),
        body:
        _isvisible == true ?
        Center(
            child: Image.asset(
              "assets/loadingq.gif",
              width: 110.0,
            )
        )
            :
        Container(
          child: Column(
            children: [
              Padding(padding: const EdgeInsets.only(top: 20,left: 20),child:
                  Align(alignment: Alignment.centerLeft,child :
                    GestureDetector(
                      child: Hero(
                        tag: getPhoto.toString(),
                        child :
                        getPhoto == '' ?
                        CachedNetworkImage(
                          fit: BoxFit.cover,
                          height: 100,
                          width: 100,
                          imageUrl: "https://duakata-dev.com/moobi/m-moobi/photo/nomage.jpg",
                          placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        )
                            :
                        CachedNetworkImage(
                          fit: BoxFit.cover,
                          height: 100,
                          width: 100,
                          imageUrl: "https://duakata-dev.com/moobi/m-moobi/photo/"+getPhoto,
                          placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                      ),
                      onTap: (){
                        Navigator.pushReplacement(context, ExitPage(page: DetailImageProduk(getPhoto)));
                      },
                    )
              )),
              Padding(padding: const EdgeInsets.only(top: 20,left: 20),
              child:
              Align(alignment: Alignment.centerLeft,child :
              Text(
                getName,
                  style: TextStyle(fontFamily: "VarelaRound",
                      fontSize: 14,fontWeight: FontWeight.bold))
              )),
              Padding(padding: const EdgeInsets.only(top: 5,left: 20),
                  child:
                  Align(alignment: Alignment.centerLeft,child :
                      Opacity(
                        opacity: 0.7,
                        child:
                        getDiskonPerc == '0' ?
                        Text(
                            "Rp "+
                                NumberFormat.currency(
                                    locale: 'id', decimalDigits: 0, symbol: '').format(
                                    int.parse(getHarga)),
                            style: TextStyle(fontFamily: "VarelaRound",
                                fontSize: 14))

                            :
                            Row(
                              children: [
                                Text(
                                    "Rp "+
                                        NumberFormat.currency(
                                            locale: 'id', decimalDigits: 0, symbol: '').format(
                                            int.parse(getHarga)),
                                    style: TextStyle(fontFamily: "VarelaRound",
                                        decoration: TextDecoration.lineThrough,
                                        fontSize: 14)),
                                Padding(padding: const EdgeInsets.only(left: 15),child:
                                Text(
                                    "Rp "+
                                        NumberFormat.currency(
                                            locale: 'id', decimalDigits: 0, symbol: '').format(
                                            int.parse(getHarga) - double.parse(getDiskonVal)),
                                    style: TextStyle(fontFamily: "VarelaRound",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14)),),

                              ],
                            )
                      )
                  )
              ),
              Align(alignment: Alignment.centerLeft,child :
              Padding(padding: const EdgeInsets.only(top: 5,left: 20,right: 30),
                child:
                  getDiskonPerc != '0' ?
                      Text("Diskon : "+getDiskonPerc+"%",style: TextStyle(fontFamily: "VarelaRound",))
                      :
                      Container()
              )),

          Padding(padding: const EdgeInsets.only(top: 20,left: 20,right: 30),child:
            Divider(height: 5,),),
           Padding(padding: const EdgeInsets.only(top: 30,left: 20,right: 30),
           child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Opacity(opacity: 0.7,child: Text("Kode",style: TextStyle(fontFamily: "VarelaRound",)),),
                  Text(widget.idItem,style: TextStyle(fontFamily: "VarelaRound",fontWeight: FontWeight.bold))
                ],
                )
              ),

              Padding(padding: const EdgeInsets.only(top: 10,left: 20,right: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Opacity(opacity: 0.7,child: Text("Kategori",style: TextStyle(fontFamily: "VarelaRound",)),),
                      Text(getCategory,style: TextStyle(fontFamily: "VarelaRound",fontWeight: FontWeight.bold))
                    ],
                  )
              ),

              Padding(padding: const EdgeInsets.only(top: 10,left: 20,right: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Opacity(opacity: 0.7,child: Text("Stok",style: TextStyle(fontFamily: "VarelaRound",)),),
                      Container(
                        height: 25,
                        width: 60,
                        child: RaisedButton(
                          color: HexColor("#063761"),
                          child:
                      Text(getStokVal,style: TextStyle(
                          fontFamily: "VarelaRound",fontWeight: FontWeight.bold,color: Colors.white))
                          ,onPressed: (){},),)
                    ],
                  )
              ),
              
              Padding(padding: const EdgeInsets.only(top: 90,left: 40,right: 40),
              child: Container(
                width: double.infinity,
                child: Expanded(
                  child: OutlineButton(
                    borderSide: BorderSide(
                      width: 1.0,
                      color: HexColor("#063761"),
                      style: BorderStyle.solid,
                    ),
                    child: Text("Hapus Produk"),
                  onPressed: (){},),
                ),
              ),)
            ],
          ),
        ),
      ),
    );
  }
}