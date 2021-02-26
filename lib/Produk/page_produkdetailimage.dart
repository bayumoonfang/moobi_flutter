




import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moobi_flutter/Helper/check_connection.dart';
import 'package:moobi_flutter/Helper/page_route.dart';
import 'package:moobi_flutter/Helper/session.dart';
import 'package:moobi_flutter/helper/api_link.dart';
import 'package:moobi_flutter/page_login.dart';
import 'package:photo_view/photo_view.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
class ProdukDetailImage extends StatefulWidget {
  final String ImgFile;
  final String Branchq;
  const ProdukDetailImage(this.ImgFile,this.Branchq);
  @override
  _ProdukDetailImageState createState() => new _ProdukDetailImageState(
      getImgFile: this.ImgFile, getBranchq: this.Branchq);
}



class _ProdukDetailImageState extends State<ProdukDetailImage> {
  String getImgFile;
  String getBranchq;
  _ProdukDetailImageState({this.getImgFile, this.getBranchq});
  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }
  String getEmail = '...';
  _session() async {
    int value = await Session.getValue();
    getEmail = await Session.getEmail();
    if (value != 1) {Navigator.pushReplacement(context, ExitPage(page: Login()));}
  }

  _connect() async {
    Checkconnection().check().then((internet){
      if (internet != null && internet) {} else {
        showToast("Koneksi terputus..", gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      }
    });
  }


  _prepare() async {
    await _connect();
    await _session();
  }


  @override
  void initState() {
    super.initState();
    _prepare();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
              tag: 'imagehero',
              child:
              PhotoView(
                imageProvider: NetworkImage(applink+"photo/"+widget.Branchq+"/"+widget.ImgFile),
              )
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}