import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../extra/models/messenger/user/user.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class AdminModel {
  final String id;
  String nomPrenom;
  String email;
  String password;
  
 AdminModel({
    required this.id,
    required this.nomPrenom,
    required this.email,
    required this.password,
    
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nomPrenom': nomPrenom,
      'email': email,
      'password': password,
      
    };
  }

  factory AdminModel.fromMap(Map<String, dynamic> map) {
   
    return AdminModel(
      id: map['id'] as String,
      nomPrenom: map['nomPrenom'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AdminModel.fromJson(String source) =>
      AdminModel.fromMap(json.decode(source) as Map<String, dynamic>);

  

  @override
  String toString() {
    return 'AdminModel(id: $id, nomPrenom: $nomPrenom, email: $email, password: $password)';
  }
}
