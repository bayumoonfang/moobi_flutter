
import 'dart:io';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:moobi_flutter/Helper/api_link.dart';
import 'package:moobi_flutter/Helper/app_helper.dart';
import 'package:moobi_flutter/Helper/check_connection.dart';
import 'package:moobi_flutter/Helper/page_route.dart';
import 'dart:async';
import 'dart:convert';

import 'package:moobi_flutter/Helper/session.dart';
import 'package:moobi_flutter/Helper/setting_apps.dart';
import 'package:moobi_flutter/Produk/page_insert2.dart';
import 'package:moobi_flutter/page_login.dart';
import 'package:toast/toast.dart';

import '../page_intoduction.dart';


class ProdukInsert extends StatefulWidget {
  final String getEmail;
  final String getLegalCode;
  final String getNamaUser;
  final String getTipe;


  const ProdukInsert(this.getEmail,this.getLegalCode,this.getNamaUser, this.getTipe);

    @override
    _ProdukInsertState createState() => _ProdukInsertState();
}

class _ProdukInsertState extends State<ProdukInsert> {
  bool _isVisible = true;
  String _isVisible_val = "true";
  String selectedSatuan;
  String selectedTipe;
  String selectedCategory;
  List _listType = ["Product", "Service"];
  List itemList = List();
  List categoryList = List();
  List tipeList = List();
  File galleryFile;
  String Base64;
  String Baseq = "";
  String namaFileq = "";
  String tesMessage = "";
  FocusNode focusNama;
  FocusNode focusHarga;
  final _namaproduk = TextEditingController();
  final _kodeproduk = TextEditingController();
  final _stockawalproduk = TextEditingController();

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);}



  Future getAllItem() async {
    //var url = applink+"api_model.php?act=getdata_unit&id="+getBranchVal;
    var response = await http.get(
        Uri.encodeFull(applink+"api_model.php?act=getdata_unit&id="+widget.getLegalCode+"&getserver="+serverCode.toString()));
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        itemList = jsonData;
      });
    }
  }

  Future getAllCategory() async {
    var response = await http.get(
        Uri.encodeFull(applink+"api_model.php?act=getdata_category&id="+widget.getLegalCode+"&getserver="+serverCode.toString()));
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        categoryList = jsonData;
      });
    }
  }

  Future getAllTipe() async {
    var response = await http.get(
        Uri.encodeFull(applink+"api_model.php?act=getdata_tipelist&getserver="+serverCode.toString()));
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        tipeList = jsonData;
      });
    }
  }

  //=============================================================================
  String serverName = '';
  String serverCode = '';
  _startingVariable() async {
    await AppHelper().getConnect().then((value){if(value == 'ConnInterupted'){
      showToast("Koneksi terputus..", gravity: Toast.CENTER,duration:
      Toast.LENGTH_LONG);}});
    await AppHelper().getSession().then((value){
      setState(() {serverName = value[11];serverCode = value[12];});});
    await AppHelper().cekServer(widget.getEmail).then((value){
      if(value[0] == '0') {Navigator.pushReplacement(context, ExitPage(page: Introduction()));}});
    await AppHelper().cekLegalUser(widget.getEmail.toString(), serverCode.toString()).then((value){
      if(value[0] == '0') {Navigator.pushReplacement(context, ExitPage(page: Introduction()));}});

    await getAllCategory();
    await getAllItem();
    await getAllTipe();
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


  imageSelectorGallery() async {
    galleryFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    String fileName = galleryFile.path.split('/').last;
    Base64 = base64Encode((galleryFile.readAsBytesSync()));
    final Bytes = galleryFile.readAsBytesSync().lengthInBytes;
    final Kb = Bytes / 1024;
    final Mb = Kb / 1024;
   // print("You selected gallery image : " + Base64);
    setState(() {
      if(Kb > 5000) {
        showsuccess("Mohon maaf , ukuran gambar maksimal 5Mb");
        namaFileq = "";
        Base64 = "";
        Baseq = "";
        return;
      } else {
        Baseq = Base64;
        namaFileq = fileName;
      }

    });
  }


  doSimpan() async {
    EasyLoading.show(status: easyloading_text);
    final response = await http.post(applink+"api_model.php?act=add_produk", body: {
      "produk_nama": _namaproduk.text,
      "produk_number": _kodeproduk.text,
      "produk_satuan" : selectedSatuan,
      "produk_kategori" : selectedCategory,
      "produk_tipe": selectedTipe,
      "produk_image": Baseq,
      "produk_branch" : widget.getLegalCode,
      "image_nama" : namaFileq,
      "user_nama" : widget.getNamaUser,
      "getserver" : serverCode
    });
    Map data = jsonDecode(response.body);
    setState(() {
      EasyLoading.dismiss();
      if (data["message"].toString() == '0') {
        showsuccess("Nama Produk sudah ada");
        _isVisible = true;
        _isVisible_val = "true";
        return false;
      } else {
        _namaproduk.clear();
        _kodeproduk.clear();
        namaFileq = "";
        Base64 = "";
        Baseq = "";
        Navigator.pop(context);
        Navigator.push(context, ExitPage(page: ProdukInsert2(widget.getEmail, widget.getLegalCode, data["message"].toString(), selectedTipe,selectedSatuan, widget.getNamaUser)));
        return false;
      }

    });
  }

  alertSimpan() {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_namaproduk.text == "" || selectedSatuan == null || selectedCategory == null ) {
      showsuccess("Form tidak boleh kosong ");
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
                            _isVisible = false;
                            _isVisible_val = "false";
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



  Future<bool> _onWillPop() async {
    Navigator.pop(context);
  }

  var items = [
    'Product',
    'Service'
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
          appBar: new AppBar(
            backgroundColor: HexColor("#602d98"),
            leading: Visibility(
              visible : _isVisible,
              child : Builder(
                builder: (context) => IconButton(
                    icon: new Icon(Icons.arrow_back),
                    color: Colors.white,
                    onPressed: () {
                      _onWillPop();
                    }
                ),
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
            Visibility(
                visible : _isVisible,
              child :   InkWell(
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
            )
            ],
          ),
        body: Container(
          padding: const EdgeInsets.only(left: 5,right: 5),
          child : SingleChildScrollView(
          child:
          _isVisible_val == 'false' ?
          SizedBox(
            height: MediaQuery.of(context).size.height / 1.3,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
              :
          Visibility(
            visible: _isVisible,
              child :
          Column(
            children: [
                Padding(padding: const EdgeInsets.only(left: 15,top: 10,right: 15),
                    child: Column(
                      children: [
                        Align(alignment: Alignment.centerLeft,child: Padding(
                          padding: const EdgeInsets.only(left: 0,top: 15),
                          child: Text("Kode ",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "VarelaRound",
                              fontSize: 12,color: HexColor("#0074D9")),),
                        ),),
                        Align(alignment: Alignment.centerLeft,child: Padding(
                          padding: const EdgeInsets.only(left: 0),
                          child: TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            controller: _kodeproduk,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(top:2),
                              hintText: 'Boleh dikosongi (generate otomatis)',
                              labelText: '',
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              hintStyle: TextStyle(fontFamily: "VarelaRound", color: HexColor("#c4c4c4"), fontSize: 13),
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
                          child: Text("Nama  ",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "VarelaRound",
                              fontSize: 12,color: HexColor("#0074D9")),),
                        ),),
                        Align(alignment: Alignment.centerLeft,child: Padding(
                          padding: const EdgeInsets.only(left: 0),
                          child: TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            controller: _namaproduk,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(top:2),
                              hintText: 'Contoh : Nasi Goreng, Es Jeruk, Jasa Photo',
                              labelText: '',
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              hintStyle: TextStyle(fontFamily: "VarelaRound", color: HexColor("#c4c4c4"), fontSize: 13),
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
                        child: Text("Tipe",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "VarelaRound",
                            fontSize: 12,color: HexColor("#0074D9")),),
                      ),),
                      Align(alignment: Alignment.centerLeft,child: Padding(
                        padding: const EdgeInsets.only(top:10),
                        child: DropdownButton(
                          isExpanded: false,
                          hint: Text("Pilih Tipe Produk", style : GoogleFonts.varelaRound(fontSize: 13)),
                          value: selectedTipe,
                          items: tipeList.map((myitem){
                            return DropdownMenuItem(
                                value: myitem['b'],
                                child: Text(myitem['b'], style : GoogleFonts.nunito(fontSize: 15))
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              FocusScope.of(context).requestFocus(FocusNode());
                              selectedTipe = value;
                            });
                          },
                        ),
                      ))
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
                        Align(alignment: Alignment.centerLeft,child: Padding(
                          padding: const EdgeInsets.only(top:10),
                          child: DropdownButton(
                            isExpanded: false,
                            hint: Text("Pilih Satuan", style : GoogleFonts.varelaRound(fontSize: 13)),
                            value: selectedSatuan,
                            items: itemList.map((myitem){
                              return DropdownMenuItem(
                                  value: myitem['DATA'],
                                  child: Text(myitem['DATA']+" ("+myitem['DESCRIPTION']+")", style : GoogleFonts.nunito(fontSize: 15))
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                FocusScope.of(context).requestFocus(FocusNode());
                                selectedSatuan = value;
                              });
                            },
                          ),
                        ))
                      ],
                    )
                ),



                Padding(padding: const EdgeInsets.only(left: 15,top: 10,right: 15),
                    child: Column(
                      children: [
                        Align(alignment: Alignment.centerLeft,child: Padding(
                          padding: const EdgeInsets.only(left: 0,top: 15),
                          child: Text("Kategori",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "VarelaRound",
                              fontSize: 12,color: HexColor("#0074D9")),),
                        ),),
                        Align(alignment: Alignment.centerLeft,child: Padding(
                          padding: const EdgeInsets.only(top:10),
                          child: DropdownButton(
                            isExpanded: false,
                            hint: Text("Pilih Kategori", style : GoogleFonts.varelaRound(fontSize: 13)),
                            value: selectedCategory,
                            items: categoryList.map((myitem2){
                              return DropdownMenuItem(
                                  value: myitem2['DATA'],
                                  child: Text(myitem2['DATA'], style : GoogleFonts.nunito(fontSize: 15))
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                FocusScope.of(context).requestFocus(FocusNode());
                                selectedCategory = value;
                              });
                            },
                          ),
                        ))
                      ],
                    )
                ),



                Padding(padding: const EdgeInsets.only(left: 15,top: 10,right: 15),
                    child: Column(
                      children: [
                        Align(alignment: Alignment.centerLeft,child: Padding(
                          padding: const EdgeInsets.only(left: 0,top: 15),
                          child: Text("Photo "+widget.getTipe,style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "VarelaRound",
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
          ))

          ),
        ),
      ),
    );
  }
}