


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:moobi_flutter/Helper/color_based.dart';
import 'package:moobi_flutter/helper/api_link.dart';
import 'package:moobi_flutter/helper/check_connection.dart';
import 'package:moobi_flutter/helper/page_route.dart';
import 'package:moobi_flutter/page_home.dart';
import 'package:moobi_flutter/page_index.dart';
import 'package:moobi_flutter/page_register.dart';
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();

}


class _LoginState extends State<Login> {
    final _username = TextEditingController();
    final _password = TextEditingController();
    GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
    String _email = '';
    String authEmail = '';
    String login_proses = '0';
    void showToast(String msg, {int duration, int gravity}) {
      Toast.show(msg, context, duration: duration, gravity: gravity);
    }

  Future<bool> _onWillPop() async {
    Navigator.pop(context);
  }

  _loginGoogle() async {

      try {
          await _googleSignIn.signIn();
          setState(() {
            authEmail = _googleSignIn.currentUser.email;
            if (authEmail != '') {
              _actloginGoogle(authEmail.toString());
            }else {
              showToast("Invalid email", gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
              login_proses = '0';
              return;
            }
          });
      }
      catch(err) {
        print(err);
      }
}


    _actloginGoogle(String parEmail) async {
      setState(() {
        login_proses = '1';
      });
      final response = await http.post(applink+"api_model.php?act=login_google",
          body: {"email": parEmail},
          headers: {"Accept":"application/json"});
      Map data = jsonDecode(response.body);
      setState(() {
        if (data["message"].toString() == '1') {
          String getEmail = data["email"];
          String getNamaUser = data["nama_user"];
          String getLevel = data["level"];
          String getUserId = data["user_id"];
          String getLegalCode = data["legal_kode"];
          String getLegalName = data["legal_name"];
          String getLegalId = data["legal_id"];
          String getLegalPhone = data["legal_phone"];
          String getRole = data["legal_role"];
          String getLegalIdCode =  data["legal_idcode"];
          String getServerName =  data["server_name"];
          String getServerCode =  data["server_code"];
          savePref(1, getEmail, getRole, getLevel, getLegalCode, getLegalName, getLegalId,
              getNamaUser, getLegalPhone, getUserId, getLegalIdCode, getServerName, getServerCode);
          login_proses = '0';
          Navigator.pushReplacement(context, EnterPage(page: Home()));
          _googleSignIn.signOut();
        }  else if (data["message"].toString() == '3') {
          showToast("Mohon maaf status toko anda sudah non aktif, silahkan hubungi admin untuk info"
              "lebih lanjut", gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
          login_proses = '0';
          return;
        }  else if (data["message"].toString() == '4') {
          showToast("Mohon maaf status subscription akun anda sudah kadaluarsa, silahkan lakukan pembaharuan lisensi atau hubungi adminuntuk informasi lebih lanjut"
              "lebih lanjut", gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
          login_proses = '0';
          return;
        } else if (data["message"].toString() == '5') {
          showToast("Mohon maaf server yang anda gunakan sedang offline", gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
          login_proses = '0';
          return;
        } else {
          _googleSignIn.signOut();
          showToast(data["message"].toString(), gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
          login_proses = '0';
          return;
        }
      });
    }



    _connect() async {
      Checkconnection().check().then((internet){
        if (internet != null && internet) {
          // Internet Present Case
        } else {
          showToast("Koneksi internet anda terputus..", gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        }
      });
    }


  _login() async {
      if(_username.text == '' || _password.text == '') {
        showToast("Form tidak boleh kosong", gravity: Toast.BOTTOM, duration: Toast.LENGTH_LONG);
        return;
      } else {
        setState(() {
          login_proses = '1';
        });
        final response = await http.post(applink+"api_model.php?act=login",
            body: {"username": _username.text, "password": _password.text},
            headers: {"Accept":"application/json"});
        Map data = jsonDecode(response.body);
        setState(() {

          if (data["message"].toString() == '1') {
            String getEmail = data["email"];
            String getNamaUser = data["nama_user"];
            String getLevel = data["level"];
            String getUserId = data["user_id"];
            String getLegalCode = data["legal_kode"];
            String getLegalName = data["legal_name"];
            String getLegalId = data["legal_id"];
            String getLegalPhone = data["legal_phone"];
            String getRole = data["legal_role"];
            String getLegalIdCode = data["legal_idcode"];
            String getServerName = data["server_name"];
            String getServerCode = data["server_code"];
            savePref(1, getEmail, getRole, getLevel, getLegalCode, getLegalName, getLegalId,
                getNamaUser, getLegalPhone, getUserId, getLegalIdCode, getServerName, getServerCode);
            login_proses = '0';
            Navigator.pushReplacement(context, EnterPage(page: Home()));
            _googleSignIn.signOut();
          }  else if (data["message"].toString() == '3') {
            showToast("Mohon maaf status toko anda sudah non aktif, silahkan hubungi admin untuk info"
                "lebih lanjut", gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
            login_proses = '0';
            return;
          } else if (data["message"].toString() == '4') {
            showToast("Mohon maaf status subscription akun anda sudah kadaluarsa, silahkan lakukan pembaharuan lisensi atau hubungi adminuntuk informasi lebih lanjut"
                "lebih lanjut", gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
            login_proses = '0';
            return;
          } else if (data["message"].toString() == '5') {
            showToast("Mohon maaf server yang anda gunakan sedang offline", gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
            login_proses = '0';
            return;
          } else {
            showToast("Gagal Login", gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
            login_proses = '0';
            return;
          }
        });
      }
  }




    savePref(int value, String emailval, String roleVal, String levelVal, String legalCodeVal
        , String legalNameVal, String legalIdVal, String namaUserVal, String legalPhoneVal, String userId, String legalIdCode,
        String serverName, String serverCode) async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      setState(() {
        preferences.setInt("value", value);
        preferences.setString("email", emailval);
        preferences.setString("role", roleVal);
        preferences.setString("level", levelVal);
        preferences.setString("legalCode", legalCodeVal);
        preferences.setString("legalName", legalNameVal);
        preferences.setString("legalId", legalIdVal);
        preferences.setString("namaUser", namaUserVal);
        preferences.setString("legalPhone", legalPhoneVal);
        preferences.setString("userId", userId);
        preferences.setString("legalIdCode", legalIdCode);
        preferences.setString("serverName", serverName);
        preferences.setString("serverCode", serverCode);
        preferences.commit();
      });
    }

    _loginact() async {
      await _connect();
      await _login();
    }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body :
        Container(
          child: Center(
              child : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("assets/logo4.png",width: 150,),
                  Padding(padding: const EdgeInsets.only(left: 35,top: 60,right: 35),
                    child:   TextFormField(
                      style: TextStyle(
                          fontFamily: 'VarelaRound', fontSize: 17),
                      validator: (e) {
                        if (e.isEmpty) {
                          return "Username tidak boleh kosong";
                        }
                      },
                      controller: _username,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 20,top:10,right: 10),
                          child: Opacity(
                            opacity: 0.8,
                            child: FaIcon(FontAwesomeIcons.envelope,color: Colors.black,size: 20,),
                          )
                        ),
                        hintText: "Email",
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                            color: HexColor("#602d98"),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                            color: HexColor("#dbd0ea"),
                            width: 1.0,
                          ),
                        ),

                      ),
                    ),
                  ),
                  Padding(padding: const EdgeInsets.only(left: 35,top: 20,right: 35),
                    child: TextFormField(
                      style: TextStyle(
                          fontFamily: 'VarelaRound', fontSize: 17),
                      validator: (e) {
                        if (e.isEmpty) {
                          return "Email tidak boleh kosong";
                        }
                      },
                      controller: _password,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 20,top:10,right: 10),
                          child: Opacity(
                            opacity: 0.8,
                            child: FaIcon(FontAwesomeIcons.lock,color: Colors.black,size: 20,),
                          )
                        ),
                        hintText: "Password",
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                            color: HexColor("#602d98"),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                            color: HexColor("#dbd0ea"),
                            width: 1.0,
                          ),
                        ),

                      ),
                    ),
                  ),
                        Padding(padding: const EdgeInsets.only(left: 35,right: 35,top: 30),child:
                              Container(
                                  height: 50,
                                  width: double.infinity,
                                  child :

                     login_proses != '1' ?
                      RaisedButton(
                          shape: RoundedRectangleBorder(side: BorderSide(
                              color: Colors.black,
                              width: 0.1,
                              style: BorderStyle.solid
                          ),
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                                    color: HexColor(main_color),
                                    child: Text(
                                      "Sign In",
                                      style: TextStyle(
                                          fontFamily: 'VarelaRound',
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white
                                      ),
                                    ),
                                    onPressed: () {
                                      _loginact();

                                    }
                                )
                         :
                    Opacity(
                      opacity: 0.4,
                      child : RaisedButton(
                        shape: RoundedRectangleBorder(side: BorderSide(
                            color: Colors.black,
                            width: 0.1,
                            style: BorderStyle.solid
                        ),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        color: HexColor(main_color),
                        child: Text(
                          "Sign In",
                          style: TextStyle(
                              fontFamily: 'VarelaRound',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),
                      )
                    )
                          )
                        ),




                  Padding(padding: const EdgeInsets.only(left: 35,right: 35,top: 30),child:
                  Container(
                      height: 50,
                      width: double.infinity,
                      child :
                      login_proses != '1' ?
                      RaisedButton(
                          shape: RoundedRectangleBorder(side: BorderSide(
                              color: Colors.black,
                              width: 0.1,
                              style: BorderStyle.solid
                          ),
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          color: Colors.white,
                          child:
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                             Image.asset("assets/logo_google.png",height: 30,width: 30,),// <-- Use 'Image.asset(...)' here
                              SizedBox(width: 18),
                              Text('Sign in with Google',
                                style: TextStyle(
                                    fontFamily: 'VarelaRound',
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black
                                )),
                            ],
                          ),
                          onPressed: () {
                            _loginGoogle();
                          }
                      )
                          :
                          Opacity(
                            opacity : 0.4,
                            child : RaisedButton(
                                shape: RoundedRectangleBorder(side: BorderSide(
                                    color: Colors.black,
                                    width: 0.1,
                                    style: BorderStyle.solid
                                ),
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                                color: Colors.white,
                                child:
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Image.asset("assets/logo_google.png",height: 30,width: 30,),// <-- Use 'Image.asset(...)' here
                                    SizedBox(width: 18),
                                    Text('Sign in with Google',
                                        style: TextStyle(
                                            fontFamily: 'VarelaRound',
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black
                                        )),
                                  ],
                                ),
                            )
                          )
                  )
                  ),


                  Center(
                    child:
                    Padding(padding: const EdgeInsets.only(left: 35,right: 35,top: 30),child:
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Anda tidak mempunyai akun ?",textAlign: TextAlign.center,style: TextStyle(fontFamily: 'VarelaRound'),),
                            Padding(padding: const EdgeInsets.only(left: 10),child:
                            InkWell(
                              child: Text("Daftar",style: TextStyle(color: Colors.blue,fontFamily: 'VarelaRound',fontWeight: FontWeight.bold),),
                              onTap: (){
                                Navigator.push(context, ExitPage(page: Register()));
                              },
                            ),)
                          ],
                        )
                    ),
                  )
                ]
              )
          ),
        ),
      )
    );
  }
}