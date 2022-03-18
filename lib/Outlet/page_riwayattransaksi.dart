


import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:moobi_flutter/Helper/api_link.dart';
import 'package:moobi_flutter/Helper/app_helper.dart';
import 'package:moobi_flutter/Helper/color_based.dart';
import 'package:http/http.dart' as http;
import 'package:moobi_flutter/Helper/page_route.dart';
import 'package:moobi_flutter/Outlet/page_riwayattransaksi_detail.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:toast/toast.dart';

import '../page_intoduction.dart';
import '../page_login.dart';


class RiwayatTransaksiOutlet extends StatefulWidget {
  final String getEmail;
  final String getLegalCode;
  final String idOutlet;

  const RiwayatTransaksiOutlet(this.getEmail, this.getLegalCode,this.idOutlet);
  @override
  _RiwayatTransaksiOutlet createState() => _RiwayatTransaksiOutlet();
}

class  ProdukData {

}

class _RiwayatTransaksiOutlet extends State<RiwayatTransaksiOutlet> {

  List data;
  bool _isVisible = false;
  bool _isvisiblefiltertanggal = false;
  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
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
  }



  String limit = "30";
  int temp_limit;
  String filter2 = "harian";
  String filter2_txt = "Transaksi Hari Ini";
  bool pemasukan = false;
  bool pengeluaran = false;
  String filter_lain = "";
  String tglFrom = "";
  String tglTo = "";
  String filter = "";
  String dateFromval = '...';
  String dateToval = '...';
  String valTanggalFix;
  final dateFrom = TextEditingController();
  final dateTo = TextEditingController();
  DateTime selectedDate = DateTime.now();
  DateTime selectedDate2 = DateTime.now();

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2020),
      helpText: 'Pilih tanggal', // Can be used as title
      cancelText: 'Keluar',
      confirmText: 'Pilih',
      lastDate: DateTime(2055),
    );

    setState(() {
      selectedDate = picked;
      if (picked != null && picked != selectedDate) {
        dateFrom.text = new DateFormat("dd-MM-yyyy").format(picked);
        dateFromval = new DateFormat("yyyy-MM-dd").format(picked);
      } else {
        dateFrom.text = new DateFormat("dd-MM-yyyy").format(selectedDate);
        dateFromval = new DateFormat("yyyy-MM-dd").format(selectedDate);
      }

    });
  }



  _selectDate2(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate2, // Refer step 1
      firstDate: DateTime(2020),
      helpText: 'Pilih tanggal', // Can be used as title
      cancelText: 'Keluar',
      confirmText: 'Pilih',
      lastDate: DateTime(2055),
    );

    setState(() {
      selectedDate2 = picked;
      if (picked != null && picked != selectedDate2) {
        dateTo.text = new DateFormat("dd-MM-yyyy").format(picked);
        dateToval = new DateFormat("yyyy-MM-dd").format(picked);
      } else {
        dateTo.text = new DateFormat("dd-MM-yyyy").format(selectedDate2);
        dateToval = new DateFormat("yyyy-MM-dd").format(selectedDate2);
      }

    });
  }


  _prepare() async {
    await _startingVariable();
  }



  @override
  void initState() {
    super.initState();
    _prepare();
    getDataProduk();
  }

  @override
  void dispose() {
    super.dispose();
  }



  getDataProduk() async {
    http.Response response = await http.get(
        Uri.parse(applink+"api_model.php?act=getdata_outlettransaksi&id="+widget.idOutlet+""
            "&filter2="+filter2+"&filter_lain="+filter_lain+"&tglFrom="+dateFromval+"&tglTo="
            ""+dateToval+"&filter="+filter+"&getserver="+serverCode.toString()),
        headers: {
          "Accept":"application/json",
          "Content-Type": "application/json"}
    );
    return json.decode(response.body);
  }
  Future<bool> _onWillPop() async {
    Navigator.pop(context);
  }

  int _radioValue = 0;

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: new AppBar(
          backgroundColor: HexColor(main_color),
          title: Text(
            "Riwayat Transaksi Outlet",
            style: TextStyle(
                color: Colors.white, fontFamily: 'VarelaRound', fontSize: 16),
          ),
          leading: Builder(
            builder: (context) => IconButton(
                icon: new FaIcon(FontAwesomeIcons.times,size: 20,),
                color: Colors.white,
                onPressed: () => {
                  //Navigator.pushReplacement(context, EnterPage(page: DetailOutlet(widget.idOutlet)))
                  Navigator.pop(context)
                }),
          ),
        ),
        body : Container(
            child:
            Column(
              children: [
                Padding(
                    padding: const EdgeInsets.only(left: 15,right: 15,top: 10),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                              height: 28,
                              child :
                              OutlinedButton(
                                child: Text(filter2_txt,style: GoogleFonts.nunito(color: HexColor(main_color)) ),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: HexColor(main_color), width: 1),
                                ),
                                onPressed: (){
                                  showModalBottomSheet(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15),
                                      ),
                                    ),
                                      context: context,
                                      builder: (context) {
                                            return Container(
                                              height: 330,
                                              child :
                                                Padding(
                                                    padding: const EdgeInsets.only(left: 5,right: 15,top: 15),
                                                    child : Column(
                                                      children: [
                                                        Padding(padding : const EdgeInsets.only(left:10,top:10),
                                                            child : Align(
                                                              alignment: Alignment.centerLeft,
                                                              child: Text("Filter Tanggal", style : GoogleFonts.varelaRound(
                                                                  fontSize: 17, fontWeight: FontWeight.bold) ),
                                                            )),

                                                        Padding(padding: const EdgeInsets.only(top: 10,right: 15,left: 15),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment
                                                                .spaceBetween,
                                                            children: [
                                                              Text("Hari Ini", style: GoogleFonts.varelaRound(
                                                                  fontSize: 14, fontWeight: FontWeight.bold)
                                                              ),
                                                              Radio(
                                                                value: 0,
                                                                groupValue: _radioValue,
                                                                activeColor: Colors.blue,
                                                                onChanged: (value) {
                                                                  setState(() {
                                                                    _radioValue = value as int;
                                                                     filter2 = "harian";
                                                                     filter2_txt = "Transaksi Hari Ini";
                                                                    dateFrom.text = "";
                                                                    dateTo.text = "";
                                                                     getDataProduk();
                                                                     Navigator.pop(context);
                                                                    //_radioVal = 'Check In';
                                                                   // print(_radioVal);
                                                                  });
                                                                },
                                                              )
                                                            ],
                                                          ),),
                                                        Padding(padding : const EdgeInsets.only(left:15,right: 15), child : Divider(
                                                          height: 5,
                                                        )),
                                                        Padding(padding: const EdgeInsets.only(right: 15,left: 15),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment
                                                                .spaceBetween,
                                                            children: [
                                                              Text("Bulan Ini", style: GoogleFonts.varelaRound(
                                                                  fontSize: 14, fontWeight: FontWeight.bold)
                                                              ),
                                                              Radio(
                                                                value: 1,
                                                                groupValue: _radioValue,
                                                                activeColor: Colors.blue,
                                                                onChanged: (value) {
                                                                  setState(() {
                                                                    _radioValue = value as int;
                                                                    filter2 = "bulanan";
                                                                    filter2_txt = "Transaksi Bulan Ini";
                                                                    dateFrom.text = "";
                                                                    dateTo.text = "";
                                                                    getDataProduk();
                                                                    Navigator.pop(context);
                                                                  });
                                                                },
                                                              )
                                                            ],
                                                          ),),
                                                        Padding(padding : const EdgeInsets.only(left:15,right: 15), child : Divider(
                                                          height: 5,
                                                        )),
                                                        Padding(padding: const EdgeInsets.only(right: 15,left: 15,top:15),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment
                                                                .spaceBetween,
                                                            children: [
                                                              Text("Pilih tanggal", style: GoogleFonts.varelaRound(
                                                                  fontSize: 14, fontWeight: FontWeight.bold)
                                                              ),
                                                            ],
                                                          ),),
                                                        Padding(padding : const EdgeInsets.only(left : 15,right: 15),
                                                            child: Container(
                                                              height: 80,
                                                              width : double.infinity,
                                                              child : Row(
                                                                mainAxisAlignment: MainAxisAlignment
                                                                    .spaceBetween,
                                                              children: [
                                                                 Container(
                                                                   height : 40,
                                                                   width : 150,
                                                                   child : TextField(
                                                                     controller: dateFrom,
                                                                     onTap: (){
                                                                       FocusScope.of(context).requestFocus(FocusNode());
                                                                       _selectDate(context);
                                                                     },
                                                                       decoration: InputDecoration(
                                                                           border: OutlineInputBorder(),
                                                                        labelText: 'Dari Tanggal',
                                                                      ),
                                                                   ),
                                                                 ),
                                                                Container(
                                                                  height : 40,
                                                                  width : 150,
                                                                  child : TextField(
                                                                    controller: dateTo,
                                                                    onTap: (){
                                                                      FocusScope.of(context).requestFocus(FocusNode());
                                                                      _selectDate2(context);
                                                                    },
                                                                    decoration: InputDecoration(
                                                                      border: OutlineInputBorder(),
                                                                      labelText: 'Sampai Tanggal',
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            )
                                                        ),
                                                        Container(
                                                          padding: const EdgeInsets.only(left: 15,right:15),
                                                          width : double.infinity,
                                                              child : Expanded(
                                                                            child :
                                                                            RaisedButton(
                                                                            child : Text("Terapkan"),
                                                                              onPressed: (){
                                                                              setState(() {
                                                                                filter2 = "pilih";
                                                                                filter2_txt = "Transaksi Periode";
                                                                                getDataProduk();
                                                                                _radioValue = 3;
                                                                                Navigator.pop(context);
                                                                              });
                                                                              },
                                                                )
                                                            )
                                                        )



                                                      ],
                                                    )
                                                )
                                            );
                                      }
                                  );
                                },
                              )
                          ),
                          Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Container(
                                  height: 28,
                                  child :
                                  OutlinedButton(
                                    child: Text("Pemasukan",style: GoogleFonts.nunito(color: pemasukan == false ? Colors.black : HexColor(main_color)) ),
                                    style: OutlinedButton.styleFrom(
                                      side:  BorderSide(color: pemasukan == false ? HexColor("#DDDDDD") : HexColor(main_color) , width: 1) ,
                                    ),
                                    onPressed: (){
                                      setState(() {
                                        pemasukan = true;
                                        pengeluaran = false;
                                        filter_lain = "2";
                                        getDataProduk();
                                      });
                                    },
                                  )
                              )
                          ),
                          Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Container(
                                  height: 28,
                                  child :
                                  OutlinedButton(
                                    child: Text("Pengeluaran",style: GoogleFonts.nunito(color: pengeluaran == false ? Colors.black : HexColor(main_color)) ),
                                    style: OutlinedButton.styleFrom(
                                      side:  BorderSide(color: pengeluaran == false ? HexColor("#DDDDDD") : HexColor(main_color) , width: 1) ,
                                    ),
                                      onPressed: (){
                                        setState(() {
                                          pemasukan = false;
                                          pengeluaran = true;
                                          filter_lain = "2";
                                          getDataProduk();
                                        });
                                      },
                                  )
                              )
                          )
                        ],
                      ),
                    )
                ),
                Padding(padding: const EdgeInsets.only(left: 15,top: 10,right: 15),
                    child: Container(
                      height: 50,
                      child: TextFormField(
                        enableInteractiveSelection: false,
                        onChanged: (text) {
                          setState(() {
                            filter = text;
                            getDataProduk();
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
                          hintText: 'Cari Transaksi...',
                        ),
                      ),
                    )
                ),
                Padding(padding: const EdgeInsets.only(top: 10),),
                Expanded(
                    child:
                    FutureBuilder(
                        future : getDataProduk(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState != ConnectionState.done) {
                            return Center(
                                child :CircularProgressIndicator()
                            );
                          } else {
                            return snapshot.data.length == 0 ?
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
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => RiwayatTransaksiDetail(widget.getEmail, widget.getLegalCode, snapshot.data[i]["n"].toString())));
                                    },
                                    child : Column(
                                      children: [
                                        ListTile(
                                            subtitle: Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 5),
                                                  child: Align(alignment: Alignment.centerLeft, child: Text(
                                                    snapshot.data[i]["k"].toString().substring(0,1) == '-' ?
                                                    snapshot.data[i]["i"]+" "+snapshot.data[i]["j"]+" "+snapshot.data[i]["f"]+ " (RETUR)"
                                                        :
                                                    snapshot.data[i]["i"]+" "+snapshot.data[i]["j"]+" "+snapshot.data[i]["f"]
                                                    ,
                                                    style: TextStyle(
                                                        fontFamily: 'VarelaRound',
                                                        fontWeight: FontWeight.bold,
                                                        color : Colors.black,
                                                        fontSize: 13),),),
                                                ),
                                                Padding(padding: const EdgeInsets.only(top: 7),
                                                    child: Align(alignment: Alignment.centerLeft, child:
                                                    Text(
                                                      snapshot.data[i]["c"] != 'Cash' ?
                                                      "# "+snapshot.data[i]["c"]+" - "+snapshot.data[i]["m"]
                                                          :
                                                      "# "+snapshot.data[i]["c"]
                                                      ,
                                                      style: TextStyle(
                                                          fontFamily: 'VarelaRound',
                                                          fontSize: 12,color: Colors.black),)
                                                      ,)),
                                                Padding(padding: const EdgeInsets.only(top: 4,bottom: 5),
                                                    child: Align(alignment: Alignment.centerLeft, child:
                                                    Opacity(
                                                        opacity: 0.7,
                                                        child: Text("a.n "+snapshot.data[i]["l"],
                                                          style: TextStyle(
                                                              fontFamily: 'VarelaRound',
                                                              fontSize: 12,color: Colors.black),))
                                                      ,))
                                              ],
                                            ),

                                            trailing:
                                            snapshot.data[i]["k"].toString().substring(0,1) == '-' ?
                                            Container(
                                              height: 22,
                                              child: RaisedButton(
                                                onPressed: (){},
                                                color: HexColor("#fe5c83"),
                                                elevation: 0,
                                                child: Text(NumberFormat.currency(
                                                    locale: 'id', decimalDigits: 0, symbol: '').format(
                                                    snapshot.data[i]["k"]),style: TextStyle(
                                                    color: HexColor("#f9fffd"), fontFamily: 'Nunito',fontSize: 12,fontWeight: FontWeight.bold)),
                                              ),
                                            )
                                                :
                                            Container(
                                              height: 22,
                                              child: RaisedButton(
                                                onPressed: (){},
                                                color: HexColor("#00aa5b"),
                                                elevation: 0,
                                                child: Text(NumberFormat.currency(
                                                    locale: 'id', decimalDigits: 0, symbol: '').format(
                                                    snapshot.data[i]["k"]),style: TextStyle(
                                                    color: HexColor("#f9fffd"), fontFamily: 'Nunito',fontSize: 12,fontWeight: FontWeight.bold)),
                                              ),
                                            )
                                        ),
                                        Divider(height: 5,)
                                      ],
                                    )
                                  );
                                });


                          }

                        }

                    )
                )
              ],
            )
        ),
        bottomSheet: Visibility(
          visible: _isVisible,
          child: Container(
            width: double.infinity,
            height: 60,
            color: Colors.white,
            child: Center(
              child: SizedBox(
                child: CircularProgressIndicator(),
                height: 30.0,
                width: 30.0,
              ),
            ),
          ),
        ),
      ),
    );
  }





}