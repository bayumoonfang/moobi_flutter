

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:moobi_flutter/Helper/page_route.dart';
import 'package:moobi_flutter/Setting/page_metodebayar.dart';
import 'package:moobi_flutter/Setting/page_ppn.dart';
import 'package:moobi_flutter/Setting/page_servcharge.dart';
import 'package:moobi_flutter/Setting/page_legalentites.dart';

class SettingHome extends StatefulWidget{
  final String getEmail;
  final String getLegalCode;
  const SettingHome(this.getEmail, this.getLegalCode);
  @override
  SettingHomeState createState() => SettingHomeState();
}


class SettingHomeState extends State<SettingHome> {
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
            "Pengaturan",
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'VarelaRound',
                fontSize: 16),
          ),
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.only(top: 10,left: 5,right: 15),
            child: Column(
              children: [
                InkWell(
                  child: ListTile(
                    onTap: (){Navigator.push(context, ExitPage(page: LegalEntities(widget.getEmail, widget.getLegalCode)));},
                    title: Text("Legal Entities",style: TextStyle(
                        color: Colors.black, fontFamily: 'VarelaRound',fontSize: 15,
                        fontWeight: FontWeight.bold)),
                    subtitle: Text("Lihat detail legal entities kamu",style: TextStyle(
                        color: Colors.black, fontFamily: 'VarelaRound',fontSize: 12)),
                    trailing: FaIcon(FontAwesomeIcons.angleRight,color: HexColor("#594d75"),size: 15,),
                  ),
                ),
                Padding(padding: const EdgeInsets.only(top: 5,left: 15),
                  child: Divider(height: 3,),),

                InkWell(
                  child: ListTile(
                    onTap: (){Navigator.push(context, ExitPage(page: MetodeBayar(widget.getEmail, widget.getLegalCode)));},
                    title: Text("Metode Pembayaran",style: TextStyle(
                        color: Colors.black, fontFamily: 'VarelaRound',fontSize: 15,
                        fontWeight: FontWeight.bold)),
                    subtitle: Text("Lihat dan atur metode pembayaran kamu",style: TextStyle(
                        color: Colors.black, fontFamily: 'VarelaRound',fontSize: 12)),
                    trailing: FaIcon(FontAwesomeIcons.angleRight,color: HexColor("#594d75"),size: 15,),
                  ),
                ),
                Padding(padding: const EdgeInsets.only(top: 5,left: 15),
                  child: Divider(height: 3,),),



                InkWell(
                  child: ListTile(
                    onTap: (){Navigator.push(context, ExitPage(page: SettingPPN()));},
                    title: Text("Tax / PPN",style: TextStyle(
                        color: Colors.black, fontFamily: 'VarelaRound',fontSize: 15,
                        fontWeight: FontWeight.bold)),
                    subtitle: Text("Atur PPN atas penjualan mu",style: TextStyle(
                        color: Colors.black, fontFamily: 'VarelaRound',fontSize: 12)),
                    trailing: FaIcon(FontAwesomeIcons.angleRight,color: HexColor("#594d75"),size: 15,),
                  ),
                ),
                Padding(padding: const EdgeInsets.only(top: 5,left: 15),
                  child: Divider(height: 3,),),

                InkWell(
                  child: ListTile(
                    onTap: (){Navigator.push(context, ExitPage(page: SettingServCharge()));},
                    title: Text("Service Charge",style: TextStyle(
                        color: Colors.black, fontFamily: 'VarelaRound',fontSize: 15,
                        fontWeight: FontWeight.bold)),
                    subtitle: Text("Atur Service Charge atas pelayanan mu",style: TextStyle(
                        color: Colors.black, fontFamily: 'VarelaRound',fontSize: 12)),
                    trailing: FaIcon(FontAwesomeIcons.angleRight,color: HexColor("#594d75"),size: 15,),
                  ),
                ),
                Padding(padding: const EdgeInsets.only(top: 5,left: 15),
                  child: Divider(height: 3,),),


              ],
            ),
          ),
        ),
      ),
    );

  }
}