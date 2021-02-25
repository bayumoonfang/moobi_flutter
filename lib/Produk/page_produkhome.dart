


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:moobi_flutter/Helper/page_route.dart';
import 'package:moobi_flutter/Produk/page_produk.dart';
import 'package:moobi_flutter/Produk/page_kategori.dart';
import 'package:moobi_flutter/Produk/page_produkstok.dart';
import 'package:moobi_flutter/Produk/page_satuan.dart';
class ProdukHome extends StatefulWidget {

  @override
  _ProdukHomeState createState() => _ProdukHomeState();
}


class _ProdukHomeState extends State<ProdukHome> {


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
            "Kelola Produk",
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
                    onTap: (){Navigator.push(context, ExitPage(page: Produk()));},
                    title: Text("Produk",style: TextStyle(
                        color: Colors.black, fontFamily: 'VarelaRound',fontSize: 15,
                        fontWeight: FontWeight.bold)),
                    subtitle: Text("Kelola produk toko anda dengan mudah disini",style: TextStyle(
                        color: Colors.black, fontFamily: 'VarelaRound',fontSize: 12)),
                    trailing: FaIcon(FontAwesomeIcons.angleRight,color: HexColor("#594d75"),size: 15,),
                  ),
                ),
                Padding(padding: const EdgeInsets.only(top: 5,left: 15),
                  child: Divider(height: 3,),),

                InkWell(
                  child: ListTile(
                    onTap: (){Navigator.push(context, ExitPage(page: ProdukSatuan()));},
                    title: Text("Satuan ",style: TextStyle(
                        color: Colors.black, fontFamily: 'VarelaRound',fontSize: 15,
                        fontWeight: FontWeight.bold)),
                    subtitle: Text("Kelola satuan jual untuk produk kamu disini",style: TextStyle(
                        color: Colors.black, fontFamily: 'VarelaRound',fontSize: 12)),
                    trailing: FaIcon(FontAwesomeIcons.angleRight,color: HexColor("#594d75"),size: 15,),
                  ),
                ),
                Padding(padding: const EdgeInsets.only(top: 5,left: 15),
                  child: Divider(height: 3,),),

                InkWell(
                  child: ListTile(
                    onTap: (){Navigator.push(context, ExitPage(page: ProdukKategori()));},
                    title: Text("Kategori",style: TextStyle(
                        color: Colors.black, fontFamily: 'VarelaRound',fontSize: 15,
                        fontWeight: FontWeight.bold)),
                    subtitle: Text("Kelola kategori produk kamu dengan mudah disini",style: TextStyle(
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