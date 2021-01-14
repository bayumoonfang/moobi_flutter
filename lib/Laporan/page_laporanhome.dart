


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:moobi_flutter/Helper/page_route.dart';
import 'package:moobi_flutter/page_home.dart';
import 'package:moobi_flutter/Laporan/page_laporanharian.dart';
class LaporanHome extends StatefulWidget {
  @override
  _LaporanHomeState createState() => _LaporanHomeState();
}

class _LaporanHomeState extends State<LaporanHome> {

  Future<bool> _onWillPop() async {Navigator.pushReplacement(context, EnterPage(page: Home()));}


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            appBar: new AppBar(
            backgroundColor: HexColor("#602d98"),
            leading: Builder(
              builder: (context) => IconButton(icon: new Icon(Icons.arrow_back,size: 20,),color: Colors.white,
                  onPressed: () => {Navigator.pushReplacement(context, EnterPage(page: Home()))}),),
            title: Text("Laporan", style: TextStyle(color: Colors.white, fontFamily: 'VarelaRound',fontSize: 16),),),
            body: Column(
                  children: [
                    Padding(padding: const EdgeInsets.only(top: 10),),
                      Padding(padding: const EdgeInsets.only(top: 5),
                          child: InkWell(
                            child: ListTile(
                              onTap: (){Navigator.pushReplacement(context, ExitPage(page: LaporanHarian()));},
                              title: Text("Laporan Transaksi Harian",style: TextStyle(
                                  color: Colors.black, fontFamily: 'VarelaRound',fontSize: 15,
                                  fontWeight: FontWeight.bold)),
                              trailing: FaIcon(FontAwesomeIcons.angleRight,color: HexColor("#594d75"),size: 15,),
                            ),
                          )
                      ),
                      Padding(padding: const EdgeInsets.only(top: 0,left: 15),
                        child: Divider(height: 3,),),

                    Padding(padding: const EdgeInsets.only(top: 5),
                        child: InkWell(
                          child: ListTile(
                            onTap: (){},
                            title: Text("Laporan Transaksi Bulanan",style: TextStyle(
                                color: Colors.black, fontFamily: 'VarelaRound',fontSize: 15,
                                fontWeight: FontWeight.bold)),
                            trailing: FaIcon(FontAwesomeIcons.angleRight,color: HexColor("#594d75"),size: 15,),
                          ),
                        )
                    ),
                    Padding(padding: const EdgeInsets.only(top: 0,left: 15),
                      child: Divider(height: 3,),),

                    Padding(padding: const EdgeInsets.only(top: 5),
                        child: InkWell(
                          child: ListTile(
                            onTap: (){},
                            title: Text("Laporan Transaksi Tahunan",style: TextStyle(
                                color: Colors.black, fontFamily: 'VarelaRound',fontSize: 15,
                                fontWeight: FontWeight.bold)),
                            trailing: FaIcon(FontAwesomeIcons.angleRight,color: HexColor("#594d75"),size: 15,),
                          ),
                        )
                    ),
                    Padding(padding: const EdgeInsets.only(top: 0,left: 15),
                      child: Divider(height: 3,),),



                    ],
              )
        ),
    );
  }
}