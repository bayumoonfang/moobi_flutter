

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class DetailImageProduk extends StatefulWidget{
  final String ImgFile;
  const DetailImageProduk(this.ImgFile);
  @override
  _DetailImageProdukState createState() => _DetailImageProdukState();
}


class _DetailImageProdukState extends State<DetailImageProduk> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
              tag: 'imagehero',
              child:
              PhotoView(
                imageProvider: NetworkImage("https://duakata-dev.com/moobi/m-moobi/photo/"+widget.ImgFile),
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