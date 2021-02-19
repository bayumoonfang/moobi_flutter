


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class ProdukInsert extends StatefulWidget {
    @override
    _ProdukInsertState createState() => _ProdukInsertState();
}

class _ProdukInsertState extends State<ProdukInsert> {


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
              "Input Produk Baru",
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'VarelaRound',
                  fontSize: 16),
            ),
          ),
        body: Container(
          child: Column(
            children: [
              Padding(padding: const EdgeInsets.only(left: 15,top: 10,right: 15),
                child: TextFormField(
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                    style: TextStyle(fontFamily: "VarelaRound", color: Colors.black),
                    decoration: InputDecoration(
                    labelText: 'Nama Produk',
                    labelStyle: TextStyle(
                      height: 3.0,fontWeight: FontWeight.bold,fontFamily: "VarelaRound",fontSize: 18
                    ),
                    hintText: 'Contoh : Nasi Goreng, Es Jeruk',
                    hintStyle: TextStyle(height:4,fontFamily: "VarelaRound", color: HexColor("#c4c4c4")),
                    contentPadding: EdgeInsets.only(bottom: 1),
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
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}