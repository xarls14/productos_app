
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier{

  final String _baseUrl = 'identitytoolkit.googleapis.com';
  final String _firebaseToken = 'AIzaSyA85-_KutgRd-iqMtKTX_sn1Bx6Q5W-eK4';

  final storage = const FlutterSecureStorage();


  //si retornamos algo es un error si no todo ok
  Future<String?> createUser(String email, String password) async{

    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final url = Uri.https(_baseUrl, '/v1/accounts:signUp', {
      'key': _firebaseToken
    });

    final resp = await http.post(url, body: json.encode(authData)); //peticion http
    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    if (decodedResp.containsKey('idToken')) {
      //guardamos el token si la resp lo entrega
      await storage.write(key: 'token', value: decodedResp['idToken']);
      // return decodedResp['idToken'];
      return null;
    }else{
      return decodedResp['error']['message'];
    }
  }

  Future<String?> login(String email, String password) async{

    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final url = Uri.https(_baseUrl, '/v1/accounts:signInWithPassword', {
      'key': _firebaseToken
    });

    final resp = await http.post(url, body: json.encode(authData)); //peticion http
    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    if (decodedResp.containsKey('idToken')) {
      //guardamos el token si la resp lo entrega
      // return decodedResp['idToken'];
      await storage.write(key: 'token', value: decodedResp['idToken']);
      return null;
    }else{
      return decodedResp['error']['message'];
    }
  }

  Future logOut() async {

    await storage.delete(key: 'token');
    return;

  }

  Future<String> readToken() async {

    return await storage.read(key: 'token') ?? '';


  }


}