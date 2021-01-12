




import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProdukStok extends StatefulWidget{
  final String idProduk;
  const ProdukStok(this.idProduk);
  @override
  _ProdukStokState createState() => _ProdukStokState();
}

class _ProdukStokState extends State<ProdukStok> {

  @override
  Widget build(BuildContext context) {
     return WillPopScope(
          child: Scaffold(

          ),
     );

  }
}