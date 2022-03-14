



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';

class ProdukInsert2 extends StatefulWidget {
  final String getEmail;
  final String getLegalCode;
  final String getProdukNumber;
  final String getProdukTipe;

  const ProdukInsert2(this.getEmail,this.getLegalCode,this.getProdukNumber, this.getProdukTipe);

  @override
  _ProdukInsertState2 createState() => _ProdukInsertState2();
}

class _ProdukInsertState2 extends State<ProdukInsert2> {

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
                "Informasi Lainnya",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'VarelaRound',
                    fontSize: 16),
              ),
            ),
          ),
          onWillPop: _onWillPop
      );
  }

}