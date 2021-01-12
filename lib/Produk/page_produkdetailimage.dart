




import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moobi_flutter/helper/api_link.dart';
import 'package:photo_view/photo_view.dart';

class ProdukDetailImage extends StatefulWidget {
  final String ImgFile;
  const ProdukDetailImage(this.ImgFile);
  @override
  _ProdukDetailImageState createState() => new _ProdukDetailImageState(
      getImgFile: this.ImgFile);
}



class _ProdukDetailImageState extends State<ProdukDetailImage> {
  String getImgFile;
  _ProdukDetailImageState({this.getImgFile});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
              tag: 'imagehero',
              child:
              PhotoView(
                imageProvider: NetworkImage(applink+"photo/"+widget.ImgFile),
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