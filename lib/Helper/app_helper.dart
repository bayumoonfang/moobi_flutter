


import 'package:intl/intl.dart';
import 'package:moobi_flutter/Helper/api_link.dart';
import 'package:moobi_flutter/Helper/check_connection.dart';
import 'package:moobi_flutter/Helper/session.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class AppHelper {
  String getUserEmail ;
  static var today = new DateTime.now();
  var getBulan = new DateFormat.MMMM().format(today);
  var getTahun = new DateFormat.y().format(today);



  Future<String> getConnect() async {
    Checkconnection().check().then((internet){
      if (internet != null && internet) {} else {
        return "ConnInterupted";
      }
    });
  }


  Future<dynamic> getSession () async {
    int value = await Session.getValue();
    String getEmail = await Session.getEmail();
    String getRole = await Session.getRole();
    String getLevel = await Session.getLevel();
    String getLegalCode = await Session.legalCode();
    String getLegalName = await Session.legalName();
    String getLegalId = await Session.legalId();
    String getNamaUser = await Session.namaUser();
    String getLegalPhone = await Session.legalPhone();
    String getUserId = await Session.userId();
    String getLegalIdCode = await Session.legalIdCode();
    String serverName = await Session.serverName();
    String serverCode = await Session.serverCode();
    return [value,//0
      getEmail,//1
      getRole,//2
      getLevel,//3
      getLegalCode,//4
      getLegalName,//5
      getLegalId,//6
      getNamaUser,//7
      getLegalPhone, //8
      getUserId,//9
      getLegalIdCode,//10,
      serverName, //11,
      serverCode //12
    ];
  }

  Future<dynamic> cekServer(String getValue) async {
    http.Response response = await http.Client().get(
        Uri.parse(applink+"api_model.php?act=cekserver&user="+getValue.toString()+""),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"}).timeout(
        Duration(seconds: 10),onTimeout: (){
      http.Client().close();
      return http.Response('Error',500);
    }
    );
    var data = jsonDecode(response.body);
    return [data["message"].toString()];
  }


  Future<dynamic> getDetailUser(String getValue, String getServer) async {
    http.Response response = await http.Client().get(
        Uri.parse(applink+"api_model.php?act=userdetail&id="+getValue.toString()+"&getServer="+getServer.toString()),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"}).timeout(
        Duration(seconds: 10),onTimeout: (){
      http.Client().close();
      return http.Response('Error',500);
    }
    );
    var data = jsonDecode(response.body);
    //print(applink+"api_model.php?act=userdetail&id="+getValue.toString()+"&getServer="+getServer.toString());
    return [
      data["legal_nama"].toString(), //0
      data["user_cabang"].toString(),//1
      data["user_level"].toString(),//2
      data["legal_alamat"].toString(),//3
      data["legal_id"].toString(),//4
      data["legal_kota"].toString(),//5
      data["legal_phone"].toString(),//6
      data["legal_status"].toString(),//7
      data["user_nama"].toString(),//8
      data["user_username"].toString(),//9
      data["user_id"].toString(),//10
      data["user_registerdate"].toString(),//11
      data["legal_web"].toString(),//12
      data["legal_subscription"].toString(),//13
      data["user_userno"].toString(),//14
      data["legal_code"].toString(),//15
      data["user_pict"].toString(),//16
      data["legal_idcode"].toString(),//17
      data["legal_license"].toString(),//18
      data["legal_regdate"].toString(),//19
      data["legal_enddate"].toString()//20
    ];
  }


  Future<dynamic> cekLegalUser(String getValue, String getServer) async {
    http.Response response = await http.Client().get(
        Uri.parse(applink+"api_model.php?act=cek_legalanduser&username="+getValue.toString()+"&getServer="+getServer.toString()),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"}).timeout(
        Duration(seconds: 10),onTimeout: (){
      http.Client().close();
      return http.Response('Error',500);
    }
    );
    var data = jsonDecode(response.body);
   return[data["message"].toString(),data["data"].toString()];
  }



}