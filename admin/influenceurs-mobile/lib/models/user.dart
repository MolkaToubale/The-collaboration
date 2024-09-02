import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../extra/models/messenger/user/user.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  final String id;
  String nomPrenom;
  String email;
  String password;
  DateTime dateDeNaissance;
  String genre;
  String bio;
  String statut;
  final DateTime creeLe;
  String photo;
  String tel;
    String insta;
    String youtube;
    String linkedin;
    String facebook;
    String? abonnement;
    DateTime? dateInscription;
     DateTime? dateFinAbonnement;
  UserModel({
    required this.id,
    required this.nomPrenom,
    required this.email,
    required this.password,
    required this.dateDeNaissance,
    required this.genre,
    required this.bio,
    required this.statut,
    required this.creeLe,
    required this.photo,
    required this.tel,
      this.insta='https://www.instagram.com/',
      this.youtube='https://www.youtube.com/',
     this.facebook='https://www.facebook.com/',
     this.linkedin='https://www.linkedin.com/feed/',
     this.abonnement,
     this.dateInscription,
     this.dateFinAbonnement,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nomPrenom': nomPrenom,
      'email': email,
      'password': password,
      'dateDeNaissance': dateDeNaissance.millisecondsSinceEpoch,
      'genre': genre,
      'bio': bio,
      'statut': statut,
      'creeLe': creeLe.millisecondsSinceEpoch,
      'photo': photo,
      'tel': tel,
        'insta':insta,
        'facebook':facebook,
        'linkedin':linkedin,
        'youtube':youtube,
        'abonnement':abonnement,
         'dateInscription':dateInscription,
         'dateFinAbonnement':dateFinAbonnement,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    log(map.toString());
    bool isString = map['dateDeNaissance'] is String;
    return UserModel(
      id: map['id'] as String,
      nomPrenom: map['nomPrenom'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      dateDeNaissance: isString
          ? DateTime.now()
          : DateTime.fromMillisecondsSinceEpoch(
              map['dateDeNaissance'] is Timestamp
                  ? (map['dateDeNaissance'] as Timestamp).millisecondsSinceEpoch
                  : map['dateDeNaissance']),
      genre: map['genre'] as String,
      bio: map['bio'] as String,
      statut: map['statut'] as String,
      creeLe: DateTime.fromMillisecondsSinceEpoch(map['creeLe'] is Timestamp
          ? (map['creeLe'] as Timestamp).millisecondsSinceEpoch
          : map['creeLe']),
      photo: map['photo'] as String,
      tel: map['tel'] as String,
        insta:map ['insta'] as String,
        facebook: map ['facebook'] as String,
        linkedin: map ['linkedin'] as String,
        youtube: map ['youtube'] as String, 
         abonnement: map ['abonnement'] as String?, 
          dateInscription:map['dateInscription'] == null? null: DateTime.fromMillisecondsSinceEpoch(map['dateInscription'] is Timestamp
          ? (map['dateInscription'] as Timestamp).millisecondsSinceEpoch
           : map['dateInscription']),
           dateFinAbonnement: map['dateFinAbonnement'] == null? null:DateTime.fromMillisecondsSinceEpoch(map['dateFinAbonnement'] is Timestamp
           ? (map['dateFinAbonnement'] as Timestamp).millisecondsSinceEpoch
           : map['dateFinAbonnement']),

    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  User toUser() {
    return User(
      id: id.toString(),
      image: photo,
      name: nomPrenom,
    );
  }

 

  @override
  String toString() {
    return 'UserModel(id: $id, nomPrenom: $nomPrenom, email: $email, password: $password, dateDeNaissance: $dateDeNaissance, genre: $genre, bio: $bio, statut: $statut, creeLe: $creeLe, photo: $photo, tel: $tel)';
  }
}
