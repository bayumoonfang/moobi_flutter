





import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:moobi_flutter/page_login.dart';

class Introduction extends StatefulWidget {

  @override
  _Introduction createState() => _Introduction();
}


class _Introduction extends State<Introduction> {



  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontFamily: "VarelaRound",fontSize: 16);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontWeight: FontWeight.bold,fontFamily: "VarelaRound",fontSize: 20),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.white,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: IntroductionScreen(
          globalBackgroundColor: Colors.white,
          done: Text("Login/Register"),
          onDone: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Login()),
            );
          },
          pages: [
            PageViewModel(
                image: Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Image.asset(
                    "assets/logo4.png",width: 200,
                  ),
                ),
                title: "Aplikasi Kasir Moobi",
                body: "Selamat Datang di aplikasi kasir terbaik untuk bisnis kamu",
                footer: Text("@moobi", style: GoogleFonts.varelaRound(),),
                decoration: pageDecoration
            ),
            PageViewModel(
                image: Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Image.asset(
                    "assets/kasirq.jpg",width: 300,
                  ),
                ),
                title: "Memudahkan usaha kamu",
                body: "Nikmati kemudahan manajamen dan transaksi toko kamu dalam satu aplikasi",
                footer: Text("@moobi", style: GoogleFonts.varelaRound(),),
                decoration: pageDecoration
            ),
            PageViewModel(
                image: Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Image.asset(
                    "assets/invent.jpg",width: 300,
                  ),
                ),
                title: "Permudah manajemen stok barang kamu",
                body: "Inventory kamu menjadi lebih rapi dan baik, disertai dengan report yang mudah untuk dianalisa",
                footer: Text("@moobi", style: GoogleFonts.varelaRound(),),
                decoration: pageDecoration
            ),
            PageViewModel(
                image: Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Image.asset(
                    "assets/reportq.jpg",width: 250,
                  ),
                ),
                title: "Report lengkap dan mudah",
                body: "Analisa data transaksi kamu jauh lebih mudah.",
                footer: Text("@moobi", style: GoogleFonts.varelaRound(),),
                decoration: pageDecoration
            ),
          ],
          showSkipButton: true,
          skipFlex: 0,
          nextFlex: 0,
          skip: const Text('Skip'),
          next: const Icon(Icons.arrow_forward),
          curve: Curves.fastLinearToSlowEaseIn,
          dotsDecorator: const DotsDecorator(
            size: Size(10.0, 10.0),
            color: Color(0xFFBDBDBD),
            activeSize: Size(22.0, 10.0),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
            ),
          ),
        ),
      ),
    );


  }
}