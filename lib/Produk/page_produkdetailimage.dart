




import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
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
  final String getLegalCode;
  const ProdukDetailImage(this.ImgFile,this.getLegalCode);
  @override
  _ProdukDetailImageState createState() => new _ProdukDetailImageState();
}



class _ProdukDetailImageState extends State<ProdukDetailImage> {

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
              tag: 'imagehero',
              child:   PhotoView(
                imageProvider: CachedNetworkImageProvider(applink+"photo/"+widget.getLegalCode+"/"+widget.ImgFile),
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