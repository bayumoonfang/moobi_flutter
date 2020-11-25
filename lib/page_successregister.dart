




import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SuksesRegister extends StatefulWidget {
  final String email;
  const SuksesRegister(this.email);

  @override
  _SuksesRegisterState createState() => _SuksesRegisterState();
}


class _SuksesRegisterState extends State<SuksesRegister> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      child : Scaffold(
        body: (
            Container(
              child: Center(
                child: Text("ssssssssssssss"),
              ),
            )
        ),
      )
    );
  }
}