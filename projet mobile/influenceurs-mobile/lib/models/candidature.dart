import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class CandidatureModel {
  final String id;
  String libelleOffre;
  String idOffre;
  String idEntreprise;
  String idInfluenceur;
  String nomInfluenceur;
  String nomEntreprise;
  String motivation;
  String fileUrl;
  String photo;
  String affiche;
  String reponse;
  CandidatureModel(
      {required this.id,
      required this.libelleOffre,
      required this.idOffre,
      required this.idEntreprise,
      required this.idInfluenceur,
      required this.nomEntreprise,
      required this.nomInfluenceur,
      required this.motivation,
      required this.affiche,
      required this.photo,
      this.fileUrl = "",
      this.reponse="En attente",
      }
       
      );
    

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'libelleOffre': libelleOffre,
      'idOffre': idOffre,
      'nomInfluenceur': nomInfluenceur,
      'idInfluenceur': idInfluenceur,
      'idEntreprise': idEntreprise,
      'nomEntreprise': nomEntreprise,
      'motivation': motivation,
      'fileUrl': fileUrl,
      'affiche': affiche,
      'photo':photo,
      'reponse':reponse,
    };
  }

  factory CandidatureModel.fromMap(Map<String, dynamic> map) {
    log(map.toString());
    return CandidatureModel(
      id: map['id'] as String,
      libelleOffre: map['libelleOffre'] as String,
      idOffre: map['idOffre'] as String,
      idEntreprise: map['idEntreprise'] as String,
      nomEntreprise: map['nomEntreprise'] as String,
      motivation: map['motivation'] as String,
      idInfluenceur: map['idInfluenceur'] as String,
      nomInfluenceur: map['nomInfluenceur'] as String,
      affiche: map['affiche'] as String,
      photo:map['photo'] as String,
      fileUrl: map['fileUrl'] as String,
      reponse: map['reponse'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CandidatureModel.fromJson(String source) =>
      CandidatureModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CandidatureModel(id: $id,libelleOffre: $libelleOffre,idOffre:$idOffre, idEntreprise: $idEntreprise, idInfluenceur: $idInfluenceur, nomInfluenceur:$nomInfluenceur , affiche: $affiche,nomEntreprise:$nomEntreprise,photo:$photo, motivation: $motivation, fileUrl: $fileUrl ,reponse:$reponse)';
  }
}
